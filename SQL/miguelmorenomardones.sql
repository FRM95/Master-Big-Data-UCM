/*
MASTER BIG DATA: DATA SCIENCE UCM 2021-22
MODULO SQL: TAREA BASE DE DATOS
AUTOR: MIGUEL MORENO MARDONES
ENTREGA: 28/10/2021
*/

/*Paso 1: Creacion de la base de datos*/
DROP DATABASE IF EXISTS appMoviles;
CREATE DATABASE appMoviles;
USE appMoviles;

/*Paso 2: Creacion de las tablas, atributos y dominios*/

/*
Se ha decidido crear una tabla para todas aquellas entidades fuertes, relaciones N:M y atributos multivalorados
En las relaciones 1:N se ha incluido el valor de la clave primaria del lado '1' al lado 'N'
El atributo pais se ha decidido representar bajo el codigo ISO3 (ESP, FRA, MEX...)
El tamano de las aplicaciones esta representado en MB
Se permite un espacio de 125 caracteres para los comentarios de los usuarios
Se ha representado la vigencia del contrato de un empleado en una empresa mediante el valor NULL para el atributo finContrato
*/

DROP TABLE IF EXISTS aplicacion;
DROP TABLE IF EXISTS empresa;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS dispositivo;
DROP TABLE IF EXISTS tiendaApps;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS aloja;
DROP TABLE IF EXISTS descarga;
DROP TABLE IF EXISTS categoriaApps;

-- TABLA DE LAS EMPRESAS QUE REALIZAN LAS APPS
CREATE TABLE empresa (
  nombreEmpresa VARCHAR(30),
  paisTributa CHAR(3) NOT NULL,
  fechaCreacion YEAR NOT NULL,
  email VARCHAR(30) NOT NULL,
  dirWeb VARCHAR(30) NOT NULL,
  PRIMARY KEY(nombreEmpresa)
 );
 
-- TABLA EMPLEADO
CREATE TABLE empleado (
  dniEmpleado CHAR(9),
  nombreEmpleado VARCHAR (30),
  calle VARCHAR(30) NOT NULL,
  numero INTEGER NOT NULL,
  cPostal NUMERIC(5) NOT NULL,
  email VARCHAR(30) NOT NULL,
  telefono NUMERIC(9) NOT NULL,
  CHECK (numero > 0),
  PRIMARY KEY (dniEmpleado)
);

-- TABLA DE LAS APLICACIONES
CREATE TABLE aplicacion (
  nombreApp VARCHAR(30),
  codigoApp CHAR(5) NOT NULL,
  desarrolladaPor VARCHAR(30),
  inicDes YEAR NOT NULL, 
  finDes YEAR NOT NULL, 
  tamMB DECIMAL(5,1) NOT NULL,
  precio DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (nombreApp, desarrolladaPor),
  FOREIGN KEY (desarrolladaPor) REFERENCES empresa(nombreEmpresa)
);

-- TABLA TIENDA DE APLICACIONES
CREATE TABLE tiendaApps (
  nombreTienda VARCHAR(30),
  gestor VARCHAR(30) NOT NULL,
  dirWeb VARCHAR(30) NOT NULL,
  PRIMARY KEY(nombreTienda)
 );
 
 -- TABLA DEL USUARIO
 CREATE TABLE usuario (
  numCuenta CHAR(4),
  nombreUsuario VARCHAR(30) NOT NULL,
  cPostal NUMERIC(5) NOT NULL,
  calle VARCHAR(30) NOT NULL,
  numero INTEGER NOT NULL,
  pais CHAR(3) NOT NULL,
  CHECK (numero > 0),
  PRIMARY KEY(numCuenta)
 );

-- TABLA DE LOS DISPOSITIVOS DEL USUARIO
  CREATE TABLE dispositivo (
  imei CHAR(15),
  idUsuario VARCHAR(30) NOT NULL,
  marca VARCHAR(30) NOT NULL,
  modelo VARCHAR(10) NOT NULL,
  telefono NUMERIC(9),
  PRIMARY KEY(imei, idUsuario),
  FOREIGN KEY(idUsuario) REFERENCES usuario(numCuenta) 
 );
 
 -- TABLA DE APPS ASOCIADAS A LAS TIENDAS
 CREATE TABLE aloja (
  nomApp VARCHAR(30),
  nomTienda VARCHAR(30),
  PRIMARY KEY(nomApp,nomTienda),
  FOREIGN KEY(nomApp) REFERENCES aplicacion(nombreApp),
  FOREIGN KEY(nomTienda) REFERENCES tiendaApps(nombreTienda)
 );
 
 -- TABLA DE DESCARGAS DE LAS APPS REALIZADAS POR LOS USUARIOS
  CREATE TABLE descarga (
  idUsuario VARCHAR(30),
  nomApp VARCHAR(30),
  fechaDesc YEAR NOT NULL,
  valoracion INTEGER,
  comentario VARCHAR(125),
  CHECK (valoracion >= 0 AND valoracion <= 5),
  PRIMARY KEY(idUsuario, nomApp),
  FOREIGN KEY(nomApp) REFERENCES aplicacion(nombreApp),
  FOREIGN KEY(idUsuario) REFERENCES usuario(numCuenta)
 );
 
-- TABLA DE CATEGORIA DE APPS
CREATE TABLE categoriaApps (
nomApp VARCHAR(30),
categoria VARCHAR(30),
PRIMARY KEY (nomApp, categoria),
FOREIGN KEY (nomApp) REFERENCES aplicacion(nombreApp)
);


 CREATE TABLE participa (
  dniEmp CHAR(9),
  nomApp VARCHAR(30),
  nomEmpresa VARCHAR(30),
  cargo enum('direccion','desarrollo'),
  inicContrato YEAR NOT NULL,
  finContrato YEAR,
  PRIMARY KEY(dniEmp, nomApp, nomEmpresa),
  FOREIGN KEY (nomApp) REFERENCES aplicacion(nombreApp),
  FOREIGN KEY (nomEmpresa) REFERENCES aplicacion(desarrolladaPor),
  FOREIGN KEY (dniEmp) REFERENCES empleado(dniEmpleado)
 );
 
 
/* Paso 3: Insercion de los datos*/

/*Los datos introducidos son meramente representativos*/

-- TABLA USUARIO
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0001', 'Miguel Moreno', '12342', 'Palomos', '3', 'ESP');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0002', 'Juan Jerez', '22340', 'General Diego', '24', 'ESP');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0003', 'Rodrigo Perez', '45632', 'Santa Catalina', '60','MEX');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0004', 'Kloe Kardashian', '22345', 'Saint Michael', '10', 'USA');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0005', 'David Olie', '28027', 'Maison Bleu', '3','FRA');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0006', 'Almudena Gracia', '89564', 'San Jeronimo', '18','COL');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0007', 'Claudia Artizu', '33321', 'Eskaura', '67','ESP');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0008', 'Juan Jose Calvo', '67849', 'Alcala ', '5','ARG');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0009', 'Juan Ignacio', '76809', 'La Palma', '5','ESP');
INSERT INTO usuario (numCuenta, nombreUsuario, cPostal, calle, numero, pais) VALUES ('0010', 'Rosa Fernandez', '44442', 'Trinidad', '22','CHL');

-- TABLA TIENDA DE APPS
INSERT INTO tiendaapps (nombreTienda, gestor, dirWeb) VALUES ('App Store', 'Apple', 'www.apple.com');
INSERT INTO tiendaapps (nombreTienda, gestor, dirWeb) VALUES ('Google Play Store', 'Google Android', 'www.play.google.com');
INSERT INTO tiendaapps (nombreTienda, gestor, dirWeb) VALUES ('App World', 'BlackBerry', 'www.blackberryworld.com');
INSERT INTO tiendaapps (nombreTienda, gestor, dirWeb) VALUES ('Market Place', 'Windows Phone', 'www.micorosoft.com');
INSERT INTO tiendaapps (nombreTienda, gestor, dirWeb) VALUES ('OVITienda', 'Nokia', 'www.nokia.com');
INSERT INTO tiendaapps (nombreTienda, gestor, dirWeb) VALUES ('AppStore', 'Amazon', 'www.amazon.com');
INSERT INTO tiendaapps (nombreTienda, gestor, dirWeb) VALUES ('AppCatalog', 'HP', 'www.hp.com');

-- TABLA EMPLEADO
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('12345678Z', 'Maria Carmen Ribera', '675431211', 'm.c.r@mail.com', '23490', 'Espina Dorsal', '12');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('46344525P', 'Alexander Caparros', '657142857', 'ax.cap@mail.es', '72123', 'Murazik Plaza', '11');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('60212005Y', 'Cecilio Juarez', '705652795', 'ccc@mail.com', '32783', 'Cone Terra', '56');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('99957202F', 'Nagore Postigo', '632003544', 'nagor21@mail.es', '49841', 'Pio XII', '78');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('95172711E', 'Luna Hidalgo', '685577280', 'lh.lhj@mail.com', '16248', 'Santa Teresa ', '2');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('21096338W', 'William Andrade', '624977777', 'wwand23@mail.es', '61304', 'Emilia Zalaquita', '90');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('89771590Z', 'Brian Arcos', '677873420', 'brianar3@mail.com', '49598', 'Concha D\'or', '2');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('04709595T', 'Marcelina Rincon', '658469801', 'marc1@mail.mex', '02383', 'Castellana', '123');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('48263750K', 'Michaela Domingo', '644859659', 'md65@mail.es', '71715', 'Sargento Bucho', '67');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('47417067Z', 'Ricardo Camacho', '688826321', 'rchi3@mail.com', '29584', 'Rafael Salgado', '18');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('89466909Z', 'Nicoleta Cabezas', '669275024', 'nicol111@mail.es', '26829', 'Santa Gloria', '11');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('44186232N', 'Teo Palomares', '629138023','teoloco@mail.com', '47936', 'Paseo Denvian', '11');
INSERT INTO empleado (dniEmpleado, nombreEmpleado, telefono, email, cPostal, calle, numero) VALUES ('44155232P', 'Jose Palomares', '629138024','jsloco@mail.com', '47936', 'Paseo Denvian', '11');

-- TABLA EMPRESA
INSERT INTO empresa (nombreEmpresa, email, dirWeb, paisTributa, fechaCreacion) VALUES ('Ho Entertainment', 'hoent@mail.com', 'www.hoent.com', 'JPN', 2006);
INSERT INTO empresa (nombreEmpresa, email, dirWeb, paisTributa, fechaCreacion) VALUES ('Calixto Games', 'calix@mail.es', 'www.calixtogames.com', 'ESP', 2001);
INSERT INTO empresa (nombreEmpresa, email, dirWeb, paisTributa, fechaCreacion) VALUES ('Yumika Apps', 'yumika@mail.com', 'www.yumikaapps.com', 'ESP', 2018);
INSERT INTO empresa (nombreEmpresa, email, dirWeb, paisTributa, fechaCreacion) VALUES ('Pixel Dot', 'pxdot@mail.es', 'www.pixel3dot.com', 'USA', 1997);
INSERT INTO empresa (nombreEmpresa, email, dirWeb, paisTributa, fechaCreacion) VALUES ('Strata Devs', 'stdvs@mail.org', 'www.strata.com', 'USA', 2000);
INSERT INTO empresa (nombreEmpresa, email, dirWeb, paisTributa, fechaCreacion) VALUES ('Logical Games', 'l.games2mail.com', 'www.logicalgames.com', 'ESP', 2004);

-- TABLA DISPOSITIVO
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('995071261759938', '0001', 'Apple', 'iPhone 10', '653709074');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('999214879630168', '0002', 'Apple', 'iPhone 13', '688709023');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('544233388791147', '0003', 'Sony', 'Z4', '619163929');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo) VALUES ('861329378633979', '0004', 'Apple', 'iPad 8');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('980717116420814', '0005', 'Huawei', 'P30', '700514485');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('497281414613667', '0006', 'Samsung', 'ZFold', '792100681');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('994798307907334', '0007', 'Windows Phone', 'A5', '701841425');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('539848299516924', '0008', 'OnePlus', 'P8', '617705611');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo, telefono) VALUES ('539848299513342', '0009', 'OnePlus', 'P9', '612305447');
INSERT INTO dispositivo (imei, idUsuario, marca, modelo) VALUES ('112248200516924', '0010', 'Apple', 'iPod Touch');

-- TABLA APLICACION
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Cookie Run', '00001', 'Logical Games', 2013, 2016, '946.1', '0');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Top War', '00002', 'Logical Games', 2018, 2019, '515.1', '0');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Family Farm', '00003', 'Calixto Games', 2015, 2019, '400', '2.99');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Sea Observer', '00004', 'Ho Entertainment', 2010, 2013, '200', '0.99');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Music 4everyone', '00005', 'Pixel Dot', 2019, 2021, '150.4', '0.99');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Strata Design', '00006', 'Strata Devs', 2015, 2018, '700.7', '3.99');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Strata Art', '00007', 'Strata Devs', 2018, 2021, '300.5', '1.99');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Clash of Japan', '00008', 'Yumika Apps', 2019, 2021, '300', '0');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Journey to Survive', '00009', 'Yumika Apps', 2018, 2019, '150', '0');
INSERT INTO aplicacion (nombreApp, codigoApp, desarrolladaPor, inicDes, finDes, tamMB, precio) VALUES ('Train with Legends', '00010', 'Calixto Games', 2017, 2020, '900', '1.99');

-- TABLA ALOJA
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Clash of Japan', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Clash of Japan', 'AppStore');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Clash of Japan', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Clash of Japan', 'Market Place');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Cookie Run', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Cookie Run', 'App World');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Cookie Run', 'AppCatalog');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Cookie Run', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Cookie Run', 'AppStore');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Cookie Run', 'Market Place');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Cookie Run', 'OVITienda');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Family Farm', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Family Farm', 'AppStore');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Family Farm', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Journey to Survive', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Journey to Survive', 'AppStore');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Journey to Survive', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Journey to Survive', 'Market Place');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Music 4everyone', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Music 4everyone', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Music 4everyone', 'AppStore');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Sea Observer', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Sea Observer', 'AppCatalog');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Sea Observer', 'Market Place');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Sea Observer', 'OVITienda');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Sea Observer', 'App World');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Strata Art', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Strata Design', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Top War', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Top War', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Top War', 'AppStore');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Train with Legends', 'App Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Train with Legends', 'Google Play Store');
INSERT INTO aloja (nomApp, nomTienda) VALUES ('Train with Legends', 'AppStore');

-- TABLA CATEGORIA DE APPS
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Clash of Japan', 'Juegos');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Cookie Run', 'Juegos');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Family Farm', 'Juegos');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Journey to Survive', 'Entretenimiento');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Music 4everyone', 'Entretenimiento');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Music 4everyone', 'Estilo de vida');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Music 4everyone', 'Musica');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Music 4everyone', 'Redes Sociales');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Sea Observer', 'Entretenimiento');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Sea Observer', 'Educacion');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Strata Art', 'Foto y video');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Strata Art', 'Entretenimiento');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Strata Art', 'Redes Sociales');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Strata Art', 'Utilidades');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Strata Design', 'Foto y video');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Strata Design', 'Entretenimiento');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Strata Design', 'Utilidades');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Top War', 'Juegos');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Train with Legends', 'Juegos');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Train with Legends', 'Infantil');
INSERT INTO categoriaapps (nomApp, categoria) VALUES ('Train with Legends', 'Entretenimiento');

-- TABLA PARTICIPA
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('04709595T', 'Clash of Japan', 'Yumika Apps', 'direccion', 2019, 2021);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('04709595T', 'Journey to Survive', 'Yumika Apps', 'direccion', 2018, 2019);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato) VALUES ('12345678Z', 'Journey to Survive', 'Yumika Apps', 'desarrollo', 2018);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato) VALUES ('12345678Z', 'Clash of Japan', 'Yumika Apps', 'desarrollo', 2018);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato) VALUES ('21096338W', 'Journey to Survive', 'Yumika Apps', 'desarrollo', 2018);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato) VALUES ('21096338W', 'Clash of Japan', 'Yumika Apps', 'desarrollo', 2018);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('44155232P', 'Cookie Run', 'Logical Games', 'desarrollo', 2013, 2017);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('44186232N', 'Cookie Run', 'Logical Games', 'desarrollo', 2013, 2017);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('44155232P', 'Top War', 'Logical Games', 'desarrollo', 2018, 2019);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('44186232N', 'Top War', 'Logical Games', 'desarrollo', 2018, 2019);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('46344525P', 'Cookie Run', 'Logical Games', 'direccion', 2013, 2017);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('46344525P', 'Top War', 'Logical Games', 'direccion', 2018, 2019);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('47417067Z', 'Family Farm', 'Calixto Games', 'direccion', 2015, 2019);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato) VALUES ('47417067Z', 'Music 4everyone', 'Pixel Dot', 'direccion', 2019);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('48263750K', 'Family Farm', 'Calixto Games', 'desarrollo', 2015, 2019);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('48263750K', 'Music 4everyone', 'Pixel Dot', 'desarrollo', 2019, 2021);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('60212005Y', 'Sea Observer', 'Ho Entertainment', 'desarrollo', 2010, 2015);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('89466909Z', 'Sea Observer', 'Ho Entertainment', 'desarrollo', 2010, 2015);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('89771590Z', 'Sea Observer', 'Ho Entertainment', 'direccion', 2010, 2015);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('89771590Z', 'Strata Art', 'Strata Devs', 'direccion', 2018, 2021);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('89771590Z', 'Strata Design', 'Strata Devs', 'direccion', 2015, 2018);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('95172711E', 'Strata Art', 'Strata Devs', 'desarrollo', 2018, 2021);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('95172711E', 'Strata Design', 'Strata Devs', 'desarrollo', 2015, 2018);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('44186232N', 'Strata Art', 'Strata Devs', 'desarrollo', 2018, 2021);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('44186232N', 'Strata Design', 'Strata Devs', 'desarrollo', 2015, 2017);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('99957202F', 'Train with Legends', 'Calixto Games', 'desarrollo', 2017, 2020);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('47417067Z', 'Train with Legends', 'Calixto Games', 'direccion', 2017, 2020);
INSERT INTO participa (dniEmp, nomApp, nomEmpresa, cargo, inicContrato, finContrato) VALUES ('89466909Z', 'Train with Legends', 'Calixto Games', 'desarrollo', 2017, 2020);

-- TABLA DESCARGA
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion, comentario) VALUES ('0001', 'Clash of Japan', '2019', '4', 'Buen juego, muy divertido. Le doy un 4 sobre 5');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0001', 'Top War', '2019', '4');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion, comentario) VALUES ('0001', 'Music 4everyone', '2019', '5', 'Alucinante!');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc) VALUES ('0002', 'Strata Art', '2021');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0002', 'Strata Design', '2018', '4');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc) VALUES ('0001', 'Family Farm', '2016');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc) VALUES ('0004', 'Family Farm', '2017');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc) VALUES ('0005', 'Family Farm', '2015');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0010', 'Family Farm', '2015', '4');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc) VALUES ('0003', 'Family Farm', '2017');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0004', 'Sea Observer', '2016', '4');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion, comentario) VALUES ('0004', 'Music 4everyone', '2019', '3', 'Nice');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion, comentario) VALUES ('0006', 'Cookie Run', '2016', '3', 'Divertida');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion, comentario) VALUES ('0004', 'Journey to Survive', '2020', '5', 'Awesome!!!');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0007', 'Train with Legends', '2021', '4');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion, comentario) VALUES ('0008', 'Top War', '2020', '5', '5/5 perfecto!!');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0008', 'Journey to Survive', '2019', '5');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0008', 'Music 4everyone', '2020', '3');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion) VALUES ('0009', 'Top War', '2021', '4');
INSERT INTO descarga (idUsuario, nomApp, fechaDesc, valoracion, comentario) VALUES ('0009', 'Clash of Japan', '2021', '2', 'Deben mejorar la jugabilidad :(');

/*Paso 4: Creacion y ejecucion de consultas sobre la base de datos*/

-- Listado de todas las aplicaciones gratuitas ordenadas por codigo de aplicacion ascendente
SELECT DISTINCT nombreApp as 'Aplicacion', codigoApp as 'Codigo Aplicacion', precio as 'Precio €'
FROM appmoviles.aplicacion
WHERE precio = 0
ORDER BY codigoApp ASC;

-- Listado de todas las aplicaciones desarrolladas entre el año 2015 y 2019 
SELECT DISTINCT nombreApp as 'Aplicacion', inicDes as 'Comienzo desarrollo', finDes as 'Final Desarrollo'
FROM appmoviles.aplicacion
WHERE inicDes >= 2015 AND finDes <= 2019
ORDER BY inicDes ASC;

-- Listado de todas las aplicaciones alojadas en la App Store de Apple de pago 
SELECT DISTINCT nomApp as 'Aplicacion', nomTienda as 'Tienda', precio as 'Precio €'
FROM appmoviles.aloja 
INNER JOIN appmoviles.aplicacion
ON nomApp = nombreApp
WHERE nomTienda = 'App Store' AND precio > 0
ORDER BY precio ASC;

-- Listado de la(s) aplicacion que mas espacio ocupa en memoria, la(s) que menos y la media del tamaño ocupado.
SELECT max(tamMB) as 'Tamaño maximo (MB)', min(TamMB) as 'Tamaño minimo (MB)', avg(tamMB) as 'Media del tamaño'
FROM appmoviles.aplicacion;

-- Espacio reservado por cada una de las tiendas para alojar las aplicaciones
SELECT nomTienda as 'Tienda', sum(tamMB) as 'Tamaño total en MB'
FROM appmoviles.aloja 
INNER JOIN appmoviles.aplicacion
ON nomApp = nombreApp
GROUP BY nomTienda;

-- Listado del año y las descargas realizadas
SELECT fechaDesc as 'Año', count(fechaDesc) as 'Descargas realizadas'
FROM appmoviles.descarga
GROUP BY fechaDesc
HAVING count(fechaDesc)
ORDER BY fechaDesc DESC;

-- Numero de descargas de las aplicaciones
SELECT nomApp AS 'Aplicacion', count(*) as 'Veces descargada' 
FROM appmoviles.descarga
GROUP BY nomApp
ORDER BY count(*) DESC;

-- Listado de los usuarios con las aplicaciones descargadas
SELECT DISTINCT numCuenta as 'ID del usuario', nombreUsuario as 'Nombre del usuario', count(idUsuario) as 'Apps descargadas'
FROM appmoviles.usuario
INNER JOIN appmoviles.descarga ON usuario.numCuenta = descarga.idUsuario
GROUP BY idUsuario
ORDER BY count(*) DESC;
 
-- Puntuacion media de las aplocaciones descargadas
SELECT nomApp as 'Aplicacion', avg(valoracion) as 'Valoracion recibida', count(*) as 'Veces descargada'
FROM appmoviles.descarga
GROUP BY nomApp
ORDER BY avg(valoracion) DESC;

-- Listado de los usuarios que poseen un iPhone
SELECT nombreUsuario as 'Nombre del usuario', marca as 'Marca', modelo as 'Modelo', telefono as 'Telefono'
FROM appmoviles.dispositivo 
INNER JOIN appmoviles.usuario 
ON dispositivo.idUsuario = usuario.numCuenta
WHERE modelo LIKE '%iPhone%';

-- Experiencia profesional de los trabajadores con mas de 1 año de experiencia
SELECT DISTINCT nombreEmpleado as 'Nombre Empleado', nomEmpresa as 'Empresa', nomApp as 'Aplicacion', cargo as 'Cargo', finContrato-inicContrato as ' Años de experiencia'
FROM appmoviles.participa 
INNER JOIN appmoviles.empleado ON empleado.dniEmpleado = participa.dniEmp
WHERE finContrato-inicContrato > 1
GROUP BY nombreEmpleado
ORDER BY finContrato-inicContrato DESC;

-- Pais de los usuarios que mas aplicaciones han descargado
SELECT DISTINCT pais as 'Pais', count(pais) as 'Descargas realizadas'
FROM appmoviles.usuario RIGHT JOIN appmoviles.descarga ON 
descarga.idUsuario = usuario.numCuenta
GROUP BY pais
ORDER BY count(pais) DESC
LIMIT 1;

-- Conocer todas las aplicaciones en las que ha participado una empresa y años de desarrollo
CREATE VIEW ViewDeAplicaciones as
(SELECT DISTINCT nombreApp as 'Aplicacion', finDes-inicDes as 'Duracion', desarrolladaPor 'Desarrollada por' 
FROM appmoviles.aplicacion INNER JOIN appmoviles.empresa ON
aplicacion.desarrolladaPor = empresa.nombreEmpresa
WHERE desarrolladaPor = 'Calixto Games'
);
SELECT * FROM ViewDeAplicaciones; 

-- Datos de los clientes que han descargado una aplicacion este año
SELECT nombreUsuario as 'Nombre cliente', cPostal as 'ZIP', calle as 'Calle', numero as 'Numero', pais as 'Pais'
FROM appmoviles.usuario INNER JOIN appmoviles.descarga ON descarga.idUsuario = usuario.numCuenta
WHERE fechaDesc = '2021';

-- Media de valoraciones realizados por el usuario con mas descargas
SELECT nombreUsuario as 'Nombre Usuario', avg(valoracion) as 'Valoraciones'
FROM appmoviles.usuario INNER JOIN appmoviles.descarga
ON usuario.numCuenta = descarga.idUsuario
ORDER BY count(nombreUsuario) ASC
LIMIT 1;


-- set SQL_SAFE_UPDATES = 0; para quitar el modo safe 