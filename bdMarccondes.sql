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

-- Cadastrar Produto + Criar Estoque

DELIMITER //

CREATE PROCEDURE sp_cadastrar_produto (
  IN p_nome VARCHAR(50),
  IN p_valor DECIMAL(10,2),
  IN p_categoria VARCHAR(50)
)
BEGIN
  INSERT INTO Produto (nome_produto, valor_unitario, categoria)
  VALUES (p_nome, p_valor, p_categoria);

  INSERT INTO Estoque (id_produto, qtd)
  VALUES (LAST_INSERT_ID(), 0);
END //

DELIMITER ;

-- Atualizar Estoque (entrada ou saída)

DELIMITER //

CREATE PROCEDURE sp_atualizar_estoque (
  IN p_id_produto INT,
  IN p_qtd INT
)
BEGIN
  UPDATE Estoque
  SET qtd = qtd + p_qtd
  WHERE id_produto = p_id_produto;
END //

DELIMITER ;

-- Cadastrar Cliente

DELIMITER //

CREATE PROCEDURE sp_cadastrar_cliente (
  IN p_nome VARCHAR(70),
  IN p_telefone CHAR(11),
  IN p_turma VARCHAR(20),
  IN p_tipo ENUM('Aluno','Responsável','Professor','Funcionário')
)
BEGIN
  INSERT INTO Cliente (nome, telefone_cliente, turma, tipo_cliente)
  VALUES (p_nome, p_telefone, p_turma, p_tipo);
END //

DELIMITER ;

--  Criar Venda

DELIMITER //

CREATE PROCEDURE sp_criar_venda (
  IN p_id_cliente INT
)
BEGIN
  INSERT INTO Venda (id_cliente)
  VALUES (p_id_cliente);
END //

DELIMITER ;

-- Adicionar Item na Venda (baixa estoque)

DELIMITER //

CREATE PROCEDURE sp_adicionar_item_venda (
  IN p_id_venda INT,
  IN p_id_produto INT,
  IN p_qtd INT
)
BEGIN
  DECLARE v_valor DECIMAL(10,2);

  SELECT valor_unitario
  INTO v_valor
  FROM Produto
  WHERE id_produto = p_id_produto;

  INSERT INTO Itens_compra (id_venda, id_produto, qtd_compra, valor_unitario)
  VALUES (p_id_venda, p_id_produto, p_qtd, v_valor);

  UPDATE Estoque
  SET qtd = qtd - p_qtd
  WHERE id_produto = p_id_produto;
END //

DELIMITER ;

-- Finalizar Venda

DELIMITER //

CREATE PROCEDURE sp_finalizar_venda (
  IN p_id_venda INT
)
BEGIN
  UPDATE Venda
  SET status = 'Concluída'
  WHERE id_venda = p_id_venda;
END //

DELIMITER ;

-- Registrar Pagamento

DELIMITER //

CREATE PROCEDURE sp_registrar_pagamento (
  IN p_id_venda INT,
  IN p_id_formaPgto INT,
  IN p_prestacao INT
)
BEGIN
  INSERT INTO Pagamento (id_venda, id_formaPgto, prestacao)
  VALUES (p_id_venda, p_id_formaPgto, p_prestacao);
END //

DELIMITER ;