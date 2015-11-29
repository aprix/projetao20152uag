-- criando banco
CREATE DATABASE IF NOT EXISTS zona_azul;

USE zona_azul;

-- criando tabelas
CREATE TABLE IF NOT EXISTS user(
	id INT AUTO_INCREMENT NOT NULL,
	cpf CHAR (11) NOT NULL,
	saldo DECIMAL(10,2)  NOT NULL,
	senha CHAR(32) NOT NULL,
	email VARCHAR (200) NOT NULL,
	nickname VARCHAR(200) NOT NULL,

	PRIMARY KEY (cpf),
	UNIQUE KEY(id)
);

CREATE TABLE IF NOT EXISTS vehicle(
	id INT AUTO_INCREMENT NOT NULL,
	plate VARCHAR (7)  NOT NULL,
	id_user INT NOT NULL,
	status INT (1) NOT NULL,
	
	PRIMARY KEY (plate, id_user),
	FOREIGN KEY (id_user) REFERENCES user(id),
	UNIQUE KEY(id)
);

CREATE TABLE IF NOT EXISTS credit_card(
	id INT AUTO_INCREMENT NOT NULL,
	num CHAR(16) NOT NULL,
	id_user INT NOT NULL,
	flag VARCHAR (50)  NOT NULL,
	name VARCHAR (100) NOT NULL,
	validate_month INT (2) NOT NULL,
	validate_year INT (4) NOT NULL,
	status INT (1) NOT NULL,

	PRIMARY KEY (num, id_user),
	FOREIGN KEY (id_user) REFERENCES user(id),
	UNIQUE KEY (id)	
);

CREATE TABLE IF NOT EXISTS payment(
	id INT AUTO_INCREMENT NOT NULL,
	id_user INT NOT NULL,
	id_credit_card INT NOT NULL,
	val NUMERIC NOT NULL,
	date_payment TIMESTAMP NOT NULL,
	status INT(1) NOT NULL,

	PRIMARY KEY (id),
	FOREIGN KEY (id_user) REFERENCES user(id),
	FOREIGN KEY (id_credit_card) REFERENCES credit_card(id),
	UNIQUE  KEY (id)
);

-- locação de vagas
CREATE TABLE IF NOT EXISTS vacancy_location(
	id INT AUTO_INCREMENT NOT NULL,
	id_user INT NOT NULL,
	id_vehicle INT NOT NULL,
	date_location TIMESTAMP NOT NULL,
	time_location INT NOT NULL,
	total_payment DECIMAL(10,2) NOT NULL,
	
	PRIMARY KEY (id_user, id_vehicle, date_location),
	FOREIGN KEY (id_user) REFERENCES user(id),
	FOREIGN KEY (id_vehicle) REFERENCES vehicle(id),
	UNIQUE  KEY (id)
);

CREATE TABLE IF NOT EXISTS institution(
	id INT AUTO_INCREMENT NOT NULL,
	razao_social VARCHAR (200) NOT NULL,
	name VARCHAR (100) NOT NULL,
	cnpj CHAR(14) NOT NULL,
	state_registration VARCHAR(20) NOT NULL,
	address VARCHAR (100) NOT NULL,
	address_num VARCHAR(10) NOT NULL,
	address_neighborhood VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	state VARCHAR(50) NOT NULL,
	cep INT(8) NOT NULL,

	PRIMARY KEY (cnpj),
	UNIQUE KEY(id)
);

CREATE TABLE IF NOT EXISTS prices(
	id INT AUTO_INCREMENT NOT NULL,
	min_time INT NOT NULL,
	un_price DECIMAL(8,2) NOT NULL,
	un_time INT NOT NULL,
	discount_sellers NUMERIC NOT NULL,
	max_price NUMERIC NOT NULL,
	
	PRIMARY KEY (id)
);
-- vendedor
CREATE TABLE IF NOT EXISTS seller(
	id INT AUTO_INCREMENT NOT NULL,
	id_user INT NOT NULL,
	status INT(1) NOT NULL,

	PRIMARY KEY (id_user),
	FOREIGN KEY (id_user) REFERENCES user(id),
	UNIQUE  KEY (id)
);

CREATE TABLE IF NOT EXISTS supervisor(
	id INT AUTO_INCREMENT NOT NULL,
	id_user INT NOT NULL,
	name VARCHAR(50) NOT NULL,
	rg INT NOT NULL,
	status INT(1) NOT NULL,

	PRIMARY KEY(id_user),
	FOREIGN KEY(id_user) REFERENCES user(id),
	UNIQUE  KEY(id)	
);

CREATE TABLE IF NOT EXISTS admin(
	login VARCHAR(20) NOT NULL,
	senha CHAR(32) NOT NULL,

	PRIMARY KEY(login)
);

-- inserindo usuario default

INSERT INTO user(id, cpf, saldo, senha, email)
VALUES (1, 000000000000, 0.0, 123456, 'notemail');

-- funcoes

CREATE FUNCTION correct_timestamp()
	RETURNS TIMESTAMP
    
	RETURN CURRENT_TIMESTAMP + INTERVAL 50 MINUTE;
