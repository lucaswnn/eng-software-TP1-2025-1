CREATE IF NOT EXISTS DATABASE BodyFit;

CREATE TABLE Usario(
	e_mail varchar(50) PRIMARY KEY,
	nome varchar(50),
	senha varchar(50),
);

CREATE TABLE Nutricionista(
	e_mail varchar(50) PRIMARY KEY,
	nome varchar(50),
	senha varchar(50),
);

CREATE TABLE Personal(
	e_mail varchar(50) PRIMARY KEY,
	nome varchar(50),
	senha varchar(50),
);

CREATE TABLE Dados_do_Usuario(
	dia date PRIMARY KEY,
	peso decimal,
		
);

CREATE TABLE Ficha_Nutricional(
	e_mail_user varchar(50),
	data_ficha varchar(50),
	e_mail_nutri varchar(50),

	FOREIGN KEY (e_mail_usuario) REFERENCES Usuario(e_mail),
	FOREIGN KEY (data_ficha) REFERENCES Usuario(data_ficha),
	FOREIGN KEY (e_mail_nutri) REFERENCES Nutricionista(e_mail),
);

CREATE TABLE Ficha_Personal(
	e_mail_user varchar(50),
	data_ficha varchar(50),
	e_mail_personal varchar(50),

	FOREIGN KEY (e_mail_usuario) REFERENCES Usuario(e_mail),
	FOREIGN KEY (data_ficha) REFERENCES Usuario(data_ficha),
	FOREIGN KEY (e_mail_personal) REFERENCES Personal(e_mail),
);
	
