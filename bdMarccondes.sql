CREATE DATABASE cantinaMarcondes;

USE cantinaMarcondes;

CREATE TABLE Produto(
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(50) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50) NOT NULL
);

CREATE TABLE Estoque(
    id_produto INT NOT NULL,
    qtd SMALLINT DEFAULT 0,
    FOREIGN KEY(id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE,
    PRIMARY KEY(id_produto)
);

CREATE TABLE Cliente(
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(70) NOT NULL,
    telefone_cliente CHAR(11) NOT NULL,
    turma VARCHAR(20),
    tipo_cliente ENUM('Aluno', 'Responsável', 'Professor', 'Funcionário') NOT NULL
);

CREATE TABLE Venda(
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_pagamento INT,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Concluída', 'Cancelada') DEFAULT 'Pendente',
    FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente) ON DELETE SET NULL
);

CREATE TABLE Forma_pgto(
    id_formaPgto INT PRIMARY KEY AUTO_INCREMENT,
    nome_forma VARCHAR(15) NOT NULL
);

CREATE TABLE Pagamento(
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_formaPgto INT,
    id_venda INT,
    prestacao INT NOT NULL,
    FOREIGN KEY(id_formaPgto) REFERENCES Forma_pgto(id_formaPgto),
    FOREIGN KEY(id_venda) REFERENCES Venda(id_venda) ON DELETE CASCADE
);

CREATE TABLE Itens_compra(
    id_venda INT,
    id_produto INT,
    qtd_compra TINYINT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(id_venda) REFERENCES Venda(id_venda) ON DELETE CASCADE,
    FOREIGN KEY(id_produto) REFERENCES Produto(id_produto),
    PRIMARY KEY(id_venda, id_produto)
);

CREATE TABLE Conta_receber(
    id_cliente INT,
    id_venda INT,
    data_vencimento DATETIME NOT NULL, 
    status ENUM('Pendente', 'Pago', 'Atrasado') DEFAULT 'Pendente',
    url_comprovante VARCHAR(255),
    FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY(id_venda) REFERENCES Venda(id_venda) ON DELETE CASCADE,
    PRIMARY KEY(id_cliente, id_venda)
);

CREATE TABLE Credito(
    id_credito INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT,
    valor_deposito DECIMAL(8,2),
    data_deposito DATETIME NOT NULL,
    saldo_restante DECIMAL(8,2),
    valor_compra DECIMAL(8,2),
    FOREIGN KEY(id_aluno) REFERENCES Cliente(id_cliente) ON DELETE SET NULL
);

CREATE TABLE Dependente_aluno(
    id_dependente INT PRIMARY KEY AUTO_INCREMENT,
    id_responsavel INT NOT NULL,
    parentesco VARCHAR(100),
    status ENUM('Ativo', 'Inativo', 'Removido') DEFAULT 'Ativo',
    FOREIGN KEY(id_responsavel) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

--INSERÇÃO DE DADOS 
USE cantinaMarcondes;

-- ==============================================
-- 1. INSERIR PRODUTOS
-- ==============================================
INSERT INTO Produto (nome_produto, valor_unitario, categoria) VALUES
('Caderno 10 matérias', 25.90, 'Papelaria'),
('Caneta esferográfica azul', 2.50, 'Papelaria'),
('Caneta esferográfica preta', 2.50, 'Papelaria'),
('Lápis grafite HB', 1.80, 'Papelaria'),
('Borracha branca', 1.50, 'Papelaria'),
('Mochila escolar', 89.90, 'Acessórios'),
('Estojo 24 peças', 35.00, 'Papelaria'),
('Calculadora científica', 120.00, 'Eletrônicos'),
('Régua 30cm', 3.50, 'Papelaria'),
('Fichário 20 argolas', 42.00, 'Papelaria'),
('Pasta plástica', 8.90, 'Papelaria'),
('Marcador de texto', 3.00, 'Papelaria'),
('Corretivo líquido', 4.50, 'Papelaria'),
('Tesoura sem ponta', 6.00, 'Papelaria'),
('Cola bastão', 4.00, 'Papelaria');

-- ==============================================
-- 2. INSERIR ESTOQUE
-- ==============================================
INSERT INTO Estoque (id_produto, qtd) VALUES
(1, 50), (2, 200), (3, 180), (4, 150), (5, 120),
(6, 30), (7, 45), (8, 15), (9, 80), (10, 25),
(11, 60), (12, 100), (13, 70), (14, 40), (15, 90);

-- ==============================================
-- 3. INSERIR CLIENTES
-- ==============================================
INSERT INTO Cliente (nome, telefone_cliente, turma, tipo_cliente) VALUES
('Ana Carolina Silva', '11987654321', '3º Ano EM', 'Aluno'),
('Bruno Henrique Santos', '11976543210', '2º Ano EM', 'Aluno'),
('Carla Fernanda Lima', '11965432109', '9º Ano EF', 'Aluno'),
('Daniel Souza Costa', '11954321098', NULL, 'Responsável'),
('Eduarda Oliveira Rocha', '11943210987', '1º Ano EM', 'Aluno'),
('Fernando Alves Mendes', '11932109876', NULL, 'Professor'),
('Gabriela Torres Lima', '11921098765', '8º Ano EF', 'Aluno'),
('Henrique Dias Pinto', '11910987654', NULL, 'Responsável'),
('Isabela Ferreira Cruz', '11909876543', '2º Ano EM', 'Aluno'),
('João Pedro Gomes', '11998765432', NULL, 'Funcionário'),
('Larissa Martins Ribeiro', '11987654309', '7º Ano EF', 'Aluno'),
('Marcelo Augusto Nunes', '11976543298', NULL, 'Responsável'),
('Natália Castro Mendes', '11965432187', '3º Ano EM', 'Aluno'),
('Otávio Ribeiro Lopes', '11954321076', NULL, 'Professor'),
('Patrícia Lima Verde', '11943210965', '6º Ano EF', 'Aluno');

-- ==============================================
-- 4. INSERIR FORMAS DE PAGAMENTO
-- ==============================================
INSERT INTO Forma_pgto (nome_forma) VALUES
('Dinheiro'),
('Pix'),
('Cartão Débito'),
('Cartão Crédito'),
('Boleto');

-- ==============================================
-- 5. INSERIR VENDAS
-- ==============================================
INSERT INTO Venda (id_cliente, data_venda, status) VALUES
(1, '2026-05-10 09:30:00', 'Concluída'),
(2, '2026-05-12 14:15:00', 'Concluída'),
(3, '2026-05-15 10:45:00', 'Concluída'),
(5, '2026-05-18 16:20:00', 'Concluída'),
(7, '2026-05-20 11:00:00', 'Concluída'),
(9, '2026-05-22 08:30:00', 'Concluída'),
(11, '2026-05-23 15:10:00', 'Pendente'),
(13, '2026-05-24 13:45:00', 'Concluída'),
(15, '2026-05-25 09:00:00', 'Cancelada'),
(1, '2026-05-26 10:30:00', 'Concluída'),
(2, '2026-05-27 14:00:00', 'Pendente'),
(4, '2026-05-28 11:15:00', 'Concluída'),
(8, '2026-05-28 16:45:00', 'Concluída'),
(12, '2026-05-29 09:20:00', 'Pendente'),
(14, '2026-05-29 15:30:00', 'Concluída');

-- ==============================================
-- 6. INSERIR ITENS DE COMPRA
-- ==============================================
INSERT INTO Itens_compra (id_venda, id_produto, qtd_compra, valor_unitario) VALUES
-- Venda 1 (Ana)
(1, 1, 2, 25.90), (1, 2, 5, 2.50), (1, 4, 3, 1.80),
-- Venda 2 (Bruno)
(2, 6, 1, 89.90), (2, 7, 1, 35.00), (2, 8, 1, 120.00),
-- Venda 3 (Carla)
(3, 2, 10, 2.50), (3, 3, 10, 2.50), (3, 12, 4, 3.00),
-- Venda 4 (Eduarda)
(4, 1, 1, 25.90), (4, 10, 2, 42.00), (4, 11, 3, 8.90),
-- Venda 5 (Gabriela)
(5, 5, 2, 1.50), (5, 13, 1, 4.50), (5, 15, 1, 4.00),
-- Venda 6 (Isabela)
(6, 8, 1, 120.00), (6, 9, 2, 3.50),
-- Venda 7 (Larissa)
(7, 2, 8, 2.50), (7, 4, 5, 1.80),
-- Venda 8 (Natália)
(8, 1, 3, 25.90), (8, 6, 1, 89.90), (8, 7, 2, 35.00),
-- Venda 9 (Patrícia) - Cancelada
(9, 14, 1, 6.00), (9, 15, 2, 4.00),
-- Venda 10 (Ana)
(10, 3, 6, 2.50), (10, 12, 3, 3.00),
-- Venda 11 (Bruno)
(11, 8, 1, 120.00),
-- Venda 12 (Daniel)
(12, 2, 12, 2.50), (12, 5, 3, 1.50),
-- Venda 13 (Henrique)
(13, 1, 2, 25.90), (13, 6, 1, 89.90),
-- Venda 14 (Marcelo)
(14, 10, 1, 42.00),
-- Venda 15 (Otávio)
(15, 8, 1, 120.00), (15, 1, 1, 25.90);

-- ==============================================
-- 7. INSERIR PAGAMENTOS
-- ==============================================
INSERT INTO Pagamento (id_formaPgto, id_venda, prestacao) VALUES
(1, 1, 1), (3, 2, 1), (2, 3, 1), (4, 4, 2), (1, 5, 1),
(3, 6, 1), (2, 7, 1), (4, 8, 3), (1, 10, 1), (2, 12, 1),
(3, 13, 1), (4, 15, 2);

-- ==============================================
-- 8. INSERIR CONTAS A RECEBER
-- ==============================================
INSERT INTO Conta_receber (id_cliente, id_venda, data_vencimento, status, url_comprovante) VALUES
(1, 1, '2026-05-20 00:00:00', 'Pago', '/comprovantes/venda1.pdf'),
(2, 2, '2026-05-27 00:00:00', 'Pago', '/comprovantes/venda2.pdf'),
(3, 3, '2026-05-30 00:00:00', 'Pendente', NULL),
(5, 4, '2026-06-05 00:00:00', 'Atrasado', NULL),
(7, 5, '2026-06-10 00:00:00', 'Pendente', NULL),
(9, 6, '2026-06-07 00:00:00', 'Pago', '/comprovantes/venda6.pdf'),
(11, 7, '2026-06-15 00:00:00', 'Pendente', NULL),
(13, 8, '2026-06-20 00:00:00', 'Atrasado', NULL),
(1, 10, '2026-06-18 00:00:00', 'Pendente', NULL),
(4, 12, '2026-06-25 00:00:00', 'Pendente', NULL),
(8, 13, '2026-06-28 00:00:00', 'Pendente', NULL),
(14, 15, '2026-06-30 00:00:00', 'Pendente', NULL);

-- ==============================================
-- 9. INSERIR CRÉDITOS
-- ==============================================
INSERT INTO Credito (id_aluno, valor_deposito, data_deposito, saldo_restante, valor_compra) VALUES
(1, 100.00, '2026-05-01 10:00:00', 50.00, 50.00),
(2, 200.00, '2026-05-05 14:30:00', 120.00, 80.00),
(5, 50.00, '2026-05-10 09:15:00', 0.00, 50.00),
(7, 150.00, '2026-05-15 11:00:00', 75.00, 75.00),
(9, 80.00, '2026-05-20 16:45:00', 30.00, 50.00),
(11, 300.00, '2026-05-22 08:00:00', 200.00, 100.00),
(13, 45.00, '2026-05-25 13:20:00', 10.00, 35.00),
(15, 120.00, '2026-05-28 10:30:00', 60.00, 60.00);

-- ==============================================
-- 10. INSERIR DEPENDENTES
-- ==============================================
INSERT INTO Dependente_aluno (id_responsavel, parentesco, status) VALUES
(4, 'Pai', 'Ativo'),
(4, 'Mãe', 'Ativo'),
(8, 'Responsável Legal', 'Ativo'),
(8, 'Avó', 'Ativo'),
(12, 'Pai', 'Ativo'),
(12, 'Mãe', 'Ativo'),
(4, 'Tio', 'Inativo'),
(8, 'Irmão', 'Ativo');

-- ==============================================
-- 11. ATUALIZAR ID_PAGAMENTO NA TABELA VENDA
-- ==============================================
UPDATE Venda SET id_pagamento = 1 WHERE id_venda = 1;
UPDATE Venda SET id_pagamento = 2 WHERE id_venda = 2;
UPDATE Venda SET id_pagamento = 3 WHERE id_venda = 3;
UPDATE Venda SET id_pagamento = 4 WHERE id_venda = 4;
UPDATE Venda SET id_pagamento = 5 WHERE id_venda = 5;
UPDATE Venda SET id_pagamento = 6 WHERE id_venda = 6;
UPDATE Venda SET id_pagamento = 7 WHERE id_venda = 7;
UPDATE Venda SET id_pagamento = 8 WHERE id_venda = 8;
UPDATE Venda SET id_pagamento = 9 WHERE id_venda = 10;
UPDATE Venda SET id_pagamento = 10 WHERE id_venda = 12;
UPDATE Venda SET id_pagamento = 11 WHERE id_venda = 13;
UPDATE Venda SET id_pagamento = 12 WHERE id_venda = 15;

-- CRIAÇÃO DAS VIEWS

--VIEW PARA RELATORIO GERAL

CREATE VIEW relatorio_vendas AS
SELECT 
    v.id_venda,
    DATE_FORMAT(v.data_venda, '%d/%m/%Y') AS data_venda,
    v.status,
    
    c.id_cliente,
    c.nome,
    c.turma,
    c.tipo_cliente,
    
    ic.id_produto,
    ic.qtd_compra,
    
    p.nome_produto,
    p.valor_unitario, 
    p.categoria
    
FROM Venda v
INNER JOIN Cliente c ON v.id_cliente = c.id_cliente
INNER JOIN Itens_compra ic ON v.id_venda = ic.id_venda
INNER JOIN Produto p ON ic.id_produto = p.id_produto

ORDER BY v.data_venda DESC;


--VIEW PARA RELATORIO DE PRODUTOS DE 15 DIAS 

CREATE VIEW produtos_15dias AS
SELECT 
    DATE_FORMAT(V.data_venda, '%d/%m/%Y') AS data_venda,
    P.nome_produto, 
    IC.qtd_compra
FROM Itens_compra IC
JOIN Produto P ON IC.id_produto = P.id_produto
JOIN Venda V ON IC.id_venda = V.id_venda
WHERE V.data_venda >= CURDATE() - INTERVAL 15 DAY
ORDER BY V.data_venda DESC;

-- VIEW PARA CONCULTA DO FATURAMENTO DOS ULTIMOS 15 DIAS
CREATE VIEW faturamento_15dias AS
SELECT 
    CONCAT('De ', DATE_FORMAT(CURDATE() - INTERVAL 15 DAY, '%d/%m/%Y'), 
           ' até ', DATE_FORMAT(CURDATE(), '%d/%m/%Y')) AS periodo,
    SUM(IC.qtd_compra * IC.valor_unitario) AS faturamento_total
FROM Itens_compra IC
JOIN Venda V ON IC.id_venda = V.id_venda
WHERE V.data_venda >= CURDATE() - INTERVAL 15 DAY;

--USAR AS VIEWS
SELECT * FROM relatorio_vendas;
SELECT * FROM produtos_15dias;
SELECT * FROM faturamento_15dias;

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

---Transação com simulação correta 
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

-- Captura o id gerado para o pagamento
SET @idPagamento = LAST_INSERT_ID();

-- Atualiza a venda com o id do pagamento
UPDATE Venda
SET status = 'Concluída',
    id_pagamento = @idPagamento
WHERE id_venda = @idVenda;

COMMIT;

ROLLBACK; 

--- verifique os resultados
SELECT * FROM Venda WHERE id_venda = @idVenda;
SELECT * FROM Itens_compra WHERE id_venda = @idVenda;
SELECT * FROM Pagamento WHERE id_venda = @idVenda;
SELECT * FROM Estoque WHERE id_produto = 2;

----Transação com de simulação de erro
START TRANSACTION;

INSERT INTO Venda (id_cliente, status)
VALUES (1, 'Pendente');

SET @idVenda = LAST_INSERT_ID();

INSERT INTO Itens_compra (id_venda, id_produto, qtd_compra, valor_unitario)
VALUES (@idVenda, 2, 1, 5.50);

-- Simula um erro: tenta inserir pagamento com id_formaPgto inexistente
INSERT INTO Pagamento (id_formaPgto, id_venda, prestacao)
VALUES (999, @idVenda, 1);

COMMIT; 

ROLLBACK;


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
