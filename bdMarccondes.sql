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