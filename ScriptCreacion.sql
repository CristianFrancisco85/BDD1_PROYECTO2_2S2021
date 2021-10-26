use bdd1;

DROP TABLE IF EXISTS Resultado;
DROP TABLE IF EXISTS Eleccion;
DROP TABLE IF EXISTS Partido;
DROP TABLE IF EXISTS Raza;
DROP TABLE IF EXISTS Eleccion;
DROP TABLE IF EXISTS Puesto;
DROP TABLE IF EXISTS Municipio;
DROP TABLE IF EXISTS Departamento;
DROP TABLE IF EXISTS Region;
DROP TABLE IF EXISTS Pais;

CREATE TABLE Pais(
	idPais INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Region(
	idRegion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
	idPais INT NOT NULL,
    INDEX Pais_Region(idPais),
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

CREATE TABLE Departamento(
	idDepartamento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
	idRegion INT NOT NULL,
    INDEX Region_Departamento(idRegion),
    FOREIGN KEY (idRegion) REFERENCES Region(idRegion)
);

CREATE TABLE Municipio(
	idMunicipio INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
	idDepartamento INT NOT NULL,
    INDEX Departamento_Municipio(idDepartamento),
    FOREIGN KEY (idDepartamento) REFERENCES Departamento(idDepartamento)
);

CREATE TABLE Puesto(
	idPuesto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Eleccion(
	idEleccion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Año INT NOT NULL,
	idPuesto INT NOT NULL,
    INDEX Puesto_Eleccion(idPuesto),
    FOREIGN KEY (idPuesto) REFERENCES Puesto(idPuesto)
);

CREATE TABLE Raza(
	idRaza INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(15) NOT NULL
);

CREATE TABLE Partido(
	idPartido INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Abreviatura VARCHAR(15) NOT NULL
);

CREATE TABLE Resultado(
	idResultado INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Analfabetas INT NOT NULL,
    Alfabetas INT NOT NULL,
    Primaria INT NOT NULL,
    Medio INT NOT NULL,
    Universitarios INT NOT NULL,
    Sexo VARCHAR(15) NOT NULL,
    
    idEleccion INT NOT NULL,
    INDEX Eleccion_Resultado(idEleccion),
    FOREIGN KEY (idEleccion) REFERENCES Eleccion(idEleccion),
    
    idRaza INT NOT NULL,
    INDEX Raza_Resultado(idRaza),
    FOREIGN KEY (idRaza) REFERENCES Raza(idRaza),
    
    idPartido INT NOT NULL,
    INDEX Partido_Resultado(idPartido),
    FOREIGN KEY (idPartido) REFERENCES Partido(idPartido),
    
    idMunicipio INT NOT NULL,
    INDEX Municipio_Resultado(idMunicipio),
    FOREIGN KEY (idMunicipio) REFERENCES Municipio(idMunicipio)
);


