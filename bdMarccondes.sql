CREATE DATABASE cantinaMarcondes;

USE cantinaMarcondes;

CREATE TABLE Produto(
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
	nome_produto VARCHAR(50) NOT NULL,
	valor DECIMAL(10,2) NOT NULL,
	categoria VARCHAR(50) NOT NULL
);

CREATE TABLE Estoque(
	id_produto INT NOT NULL,
	qtd SMALLINT,
	FOREIGN KEY(id_produto) REFERENCES Produto(id_produto),
	PRIMARY KEY(id_produto)
);

CREATE TABLE Cliente(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(70) NOT NULL,
	tipo_Cliente VARCHAR(50) NOT NULL,
	telefone_cliente CHAR(11) NOT NULL,
	responsavel_nome VARCHAR(70),
	turma VARCHAR(20)
);

CREATE TABLE Venda(
	id_venda INT PRIMARY KEY AUTO_INCREMENT,
	id_cliente INT,
	data_venda DATETIME,
	status BOOLEAN,
	FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Itens_compra(
	id_venda INT,
	id_produto INT,
	qtd_compra TINYINT,
	FOREIGN KEY(id_venda) REFERENCES Venda(id_venda),
	FOREIGN KEY(id_produto) REFERENCES Produto(id_produto),
	PRIMARY KEY(id_venda, id_produto)
);

CREATE TABLE Cont_receber(
	id_cliente INT,
	id_venda INT,
	data_venda DATETIME,
	status BOOLEAN,
	FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente),
	FOREIGN KEY(id_venda) REFERENCES Venda(id_venda),
	PRIMARY KEY(id_cliente, id_venda)
);

--- Usuários que tem acesso ao BD ---
CREATE USER 'Backend'@'%' IDENTIFIED BY 'marcondes12@34';

CREATE USER 'Analista'@'%' IDENTIFIED BY 'marcondes12@34@';

-- Analista: Permissão de leitura 
GRANT SELECT ON cantinaMarcondes.Conta_receber TO 'Analista'@'%';
GRANT SELECT ON cantinaMarcondes.Venda TO 'Analista'@'%';
GRANT SELECT ON cantinaMarcondes.Itens_compra TO 'Analista'@'%';

--- Backend: Permissão de leitura/escrita
GRANT SELECT, INSERT, UPDATE ON cantinaMarcondes.Venda TO 'Backend'@'%';
GRANT SELECT, INSERT, UPDATE ON cantinaMarcondes.Conta_receber TO 'Backend'@'%';
GRANT SELECT, INSERT, UPDATE ON cantinaMarcondes.Itens_compra TO 'Backend'@'%';
GRANT SELECT, INSERT, UPDATE ON cantinaMarcondes.Produto TO 'Backend'@'%';


-- Se você está como root, pode trocar de usuário:
SYSTEM mysql -u Analista -p -h localhost;

SELECT USER(); -- Ver usuário atual

SHOW GRANTS; --Ver minhas permissões

--teste
SELECT * FROM cantinaMarcondes.venda LIMIT 5;

SELECT*FROM cantinaMarcondes.Conta_receber;

---teste de erro 
SELECT * FROM cantinaMarcondes.itens_compra; 

--sair do usuário
exit;

-- Ver usuários
SELECT USER, host FROM mysql.USER

--Teste tabela Produto
INSERT INTO cantinaMarcondes.produto (nome_produto, valor_unitario, categoria) 
VALUES ('Teste Seguranca', 5.50, 'suco');

SELECT * FROM cantinaMarcondes.produto 
WHERE nome_produto = 'Teste Seguranca';

UPDATE cantinaMarcondes.produto SET valor_unitario = 6.00 WHERE nome_produto = 'Teste Seguranca';

--Teste tabela Venda
INSERT INTO cantinaMarcondes.Venda (id_cliente, id_pagamento, status)
VALUES (1, 2, 'Pendente');

SELECT * FROM cantinaMarcondes.Venda 
WHERE id_cliente = 1;

UPDATE cantinaMarcondes.Venda SET status = 'Concluída' WHERE id_venda = 1;

--Teste Conta_receber
INSERT INTO cantinaMarcondes.conta_receber (id_venda, id_cliente, data_vencimento, status) 
VALUES (17, 1, DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'Atrasado');

SELECT * FROM cantinaMarcondes.conta_receber
WHERE id_cliente = 1;

UPDATE cantinaMarcondes.conta_receber SET status = 'PAGO', data_vencimento = CURDATE() 
WHERE id_cliente = 1;

--Teste Itens_compra
INSERT INTO cantinaMarcondes.Itens_compra (id_venda, id_produto, qtd_compra, valor_unitario) 
VALUES (17, 1, 2, 5.50);

SELECT * FROM cantinaMarcondes.Itens_compra
WHERE id_venda = 17;

UPDATE cantinaMarcondes.itens_compra SET qtd_compra = 20 WHERE id_venda = 17;

--- DELETE dados dos testes
--Produto
SELECT*FROM Produto;
DELETE FROM produto WHERE id_produto= 16;

--Venda, Conta_receber e Itens_compra
DELETE FROM Venda WHERE id_venda= 17;
SELECT*FROM Venda;

--- criptografia
CREATE TABLE usuario(
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(50) NOT NULL UNIQUE,
	senha VARCHAR(64) NOT NULL
);

INSERT into usuario(nome,senha)
VALUES('Tatiana', SHA2('1234',256)),('Cristiane Barbosa', SHA2('1234',256));

SELECT* FROM usuario;

---Transação
START TRANSACTION;


INSERT INTO Venda (id_cliente, status)
VALUES (1, 'Pendente');


SET @idVenda = LAST_INSERT_ID();

INSERT INTO Itens_compra (id_venda, id_produto, qtd_compra, valor_unitario)
VALUES (@idVenda, 2, 1, 5.50);

UPDATE Estoque
SET qtd = qtd - 1
WHERE id_produto = 2;


INSERT INTO Pagamento (id_formaPgto, id_venda, prestacao)
VALUES (1, @idVenda, 1);


UPDATE Venda
SET status = 'Concluída'
WHERE id_venda = @idVenda;

COMMIT;

--- PROCEDURE de controle de estoque com mensagem de erro caso a venda seja maior que o estoque 
DELIMITER //

CREATE PROCEDURE registrar_venda(IN p_id_produto INT, IN p_qtd_compra INT)
BEGIN
    DECLARE qtd_estoque INT;

    -- Verifica o estoque atual
    SELECT qtd INTO qtd_estoque
    FROM Estoque
    WHERE id_produto = p_id_produto;

    -- Se não houver estoque suficiente, dispara erro
    IF (qtd_estoque < p_qtd_compra) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    -- Caso contrário, atualiza o estoque
    UPDATE Estoque
    SET qtd = qtd - p_qtd_compra
    WHERE id_produto = p_id_produto;

END//

DELIMITER ;
CALL registrar_venda(2,1200); -- total estoque: 1154 acima disso mensagem de erro 

--- PROCEDURE de credito aluno com mensagem de erro caso saldo seja insuficiente
DELIMITER //

CREATE PROCEDURE usar_credito(
    IN p_id_aluno INT,
    IN p_id_produto INT,
    IN p_qtd_compra INT,
    IN p_valor DECIMAL(10,2)
)
BEGIN
    DECLARE saldo_atual DECIMAL(10,2);

    -- Buscar saldo atual do aluno
    SELECT saldo_restante INTO saldo_atual
    FROM Credito
    WHERE id_aluno = p_id_aluno
    ORDER BY id_credito DESC
    LIMIT 1;

    -- Verificar saldo
    IF (saldo_atual < p_valor) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo insuficiente';
    END IF;

    -- Registrar a venda
    INSERT INTO Venda (id_cliente, status)
    VALUES (p_id_aluno, 'Pendente');

    SET @idVenda = LAST_INSERT_ID();

    -- Inserir item da compra
    INSERT INTO Itens_compra (id_venda, id_produto, qtd_compra, valor_unitario)
    VALUES (@idVenda, p_id_produto, p_qtd_compra, p_valor);

    -- Atualizar saldo
    UPDATE Credito
    SET saldo_restante = saldo_restante - p_valor,
        valor_compra = p_valor
    WHERE id_aluno = p_id_aluno
    ORDER BY id_credito DESC
    LIMIT 1;

    -- Finalizar venda
    UPDATE Venda
    SET status = 'Concluída'
    WHERE id_venda = @idVenda;
END//

DELIMITER ;
CALL usar_credito(1, 2, 1, 7.50); - Saldo Ok 
CALL usar_credito(1, 2, 1, 100.00); - Saldo insuficiente

