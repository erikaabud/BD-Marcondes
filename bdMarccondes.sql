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

