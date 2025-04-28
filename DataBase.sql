CREATE TABLE IF NOT EXISTS Login(
	e_mail varchar(50) PRIMARY KEY,
	nome varchar(50),
	senha varchar(50),
	tipo bit(3)
);

CREATE TABLE IF NOT EXISTS Usuario(
	e_mail_usuario varchar(50),
	
	PRIMARY KEY(e_mail_usuario),
	FOREIGN KEY(e_mail_usuario) REFERENCES login(e_mail)

);

CREATE TABLE IF NOT EXISTS Nutricionista(
	e_mail_nutri varchar(50),

	PRIMARY KEY(e_mail_nutri),
	FOREIGN KEY(e_mail_nutri) REFERENCES login(e_mail)
);

CREATE TABLE IF NOT EXISTS Personal(
	e_mail_personal varchar(50),

	PRIMARY KEY(e_mail_personal),
	FOREIGN KEY(e_mail_personal) REFERENCES login(e_mail)
);

CREATE TABLE IF NOT EXISTS Dados_do_Usuario(
	dia date,
	e_mail_usuario varchar(50),
	peso decimal,
	percentual_gordura decimal,
	indice_massa_magra decimal,
	relacao_cintura_quadril decimal,
	percentual_agua decimal,

	PRIMARY KEY (dia, e_mail_usuario),
	FOREIGN KEY (e_mail_usuario) REFERENCES usuario(e_mail_usuario)
);

CREATE TABLE IF NOT EXISTS Ficha_Nutricional (
    e_mail_usuario varchar(50),
    data_ficha date,
    e_mail_nutri varchar(50),
	dieta varchar(500),

    PRIMARY KEY (e_mail_usuario, data_ficha, e_mail_nutri),
    FOREIGN KEY (data_ficha, e_mail_usuario) REFERENCES Dados_do_Usuario(dia, e_mail_usuario),
    FOREIGN KEY (e_mail_nutri) REFERENCES Nutricionista(e_mail_nutri)
);

CREATE TABLE IF NOT EXISTS Ficha_Treino (
	e_mail_usuario varchar(50),
    data_ficha date,
	e_mail_personal varchar(50),
	marcador varchar(1) CHECK (marcador IN ('A', 'B', 'C', 'D', 'E', 'F', 'G')),
	exercicio varchar(50),
	frequencia varchar(50),

	PRIMARY KEY(e_mail_usuario, data_ficha, marcador)
);

CREATE TABLE IF NOT EXISTS Log_Diario(
	dia date,
	e_mail_usuario varchar(50),
	identificador int,
	exercicio varchar(50),
	feito boolean,
	
	PRIMARY KEY (dia, e_mail_usuario, identificador),
	FOREIGN KEY (e_mail_usuario) REFERENCES usuario(e_mail_usuario)
);

CREATE TABLE IF NOT EXISTS Ficha_Personal (
    e_mail_usuario varchar(50),
    data_ficha date,
    e_mail_personal varchar(50),
	

    PRIMARY KEY (e_mail_usuario, data_ficha, e_mail_personal),
    FOREIGN KEY (data_ficha, e_mail_usuario) REFERENCES Dados_do_Usuario(dia, e_mail_usuario),
    FOREIGN KEY (e_mail_personal) REFERENCES Personal(e_mail_personal)
);

	
