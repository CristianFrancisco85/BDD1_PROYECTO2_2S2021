USE bdd1;

-- ******************************************************************
-- Carga de Paises
-- ******************************************************************
INSERT INTO Pais(Nombre)
    SELECT DISTINCT Pais FROM CSVTable;
    
-- ******************************************************************
-- Carga de Region
-- ******************************************************************
INSERT INTO Region(idPais,Nombre)
    SELECT DISTINCT (SELECT idPais FROM Pais WHERE Nombre = Pais),Region FROM CSVTable;
    
-- ******************************************************************
-- Carga de Departamento
-- ******************************************************************
INSERT INTO Departamento(idRegion,Nombre)
    SELECT DISTINCT (SELECT idRegion FROM Region WHERE Nombre = Region AND idPais = (SELECT idPais FROM Pais WHERE Nombre = Pais) ),Depto FROM CSVTable;
    
-- ******************************************************************
-- Carga de Municipio
-- ******************************************************************
INSERT INTO Municipio(idDepartamento,Nombre)
    SELECT DISTINCT (
    SELECT idDepartamento FROM Departamento 
    INNER JOIN Region ON Region.idRegion = Departamento.idRegion
    INNER JOIN Pais ON Pais.idPais = Region.idPais
    WHERE Departamento.Nombre = DEPTO
    AND Region.Nombre = REGION
    AND Pais.Nombre = PAIS
    ),Municipio FROM CSVTable;

    
-- ******************************************************************
-- Carga de Puesto
-- ******************************************************************
INSERT INTO Puesto(Nombre)
    SELECT DISTINCT NOMBRE_ELECCION FROM CSVTable;
    
-- ******************************************************************
-- Carga de Eleccion
-- ******************************************************************
INSERT INTO Eleccion(idPuesto,Año)
    SELECT DISTINCT (SELECT idPuesto FROM Puesto WHERE Nombre = NOMBRE_ELECCION),AÑO_ELECCION FROM CSVTable;
    
-- ******************************************************************
-- Carga de Raza
-- ******************************************************************
INSERT INTO Raza(Nombre)
    SELECT DISTINCT RAZA FROM CSVTable;
    
-- ******************************************************************
-- Carga de Partido
-- ******************************************************************
INSERT INTO Partido(Nombre,Abreviatura)
    SELECT DISTINCT NOMBRE_PARTIDO,PARTIDO FROM CSVTable;

-- ******************************************************************
-- Carga de Resultado
-- ******************************************************************    
INSERT INTO Resultado(Analfabetas,Alfabetas,Primaria,Medio,Universitarios,Sexo,idEleccion,idRaza,idPartido,idMunicipio)
	SELECT DISTINCT ANALFABETOS,ALFABETOS,PRIMARIA,MEDIO,UNIVERSITARIOS,SEXO,
    (SELECT idEleccion FROM Eleccion WHERE idPuesto=(SELECT idPuesto FROM Puesto WHERE Nombre=NOMBRE_ELECCION) AND Año=AÑO_ELECCION),
    (SELECT idRaza FROM Raza WHERE Nombre=RAZA) ,
    (SELECT idPartido FROM Partido WHERE Nombre=NOMBRE_PARTIDO AND Abreviatura=PARTIDO),
    (SELECT idMunicipio FROM Municipio
    INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
	INNER JOIN Region ON Region.idRegion = Departamento.idRegion
	INNER JOIN Pais ON Pais.idPais = Region.idPais
    WHERE Municipio.Nombre=Municipio
	AND Departamento.Nombre = DEPTO
	AND Region.Nombre = REGION
	AND Pais.Nombre = PAIS) FROM CSVTable;