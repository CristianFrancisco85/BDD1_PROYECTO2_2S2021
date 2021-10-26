SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
USE bdd1;
-- ******************************************************************
-- Consulta 1
-- ******************************************************************
SELECT Partido,PuestoEleccion,Año,Pais,MAX(Total)*100/SUM(TOTAL) AS Porcentaje FROM(
SELECT 
	(SELECT Nombre FROM Partido WHERE Partido.idPartido=Resultado.idPartido)AS Partido,
    (SELECT Nombre FROM Puesto WHERE Puesto.idPuesto = Eleccion.idPuesto)AS PuestoEleccion,
    (SELECT Nombre FROM Pais WHERE Pais.idPais = Region.idPais)AS Pais,
    Año,
    SUM(Analfabetas+Alfabetas) AS Total FROM Resultado
INNER JOIN Eleccion ON Eleccion.idEleccion = Resultado.idEleccion
INNER JOIN Puesto ON Puesto.idPuesto = Eleccion.idPuesto
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
GROUP BY Partido,PuestoEleccion,Pais
ORDER BY Total DESC) AS T1
GROUP BY PuestoEleccion,Pais;

-- ******************************************************************
-- Consulta 2
-- ******************************************************************
SELECT Pais,Departamento,Total,
Total*100/(
SELECT 
    SUM(Analfabetas+Alfabetas) AS Total FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
WHERE Sexo='mujeres'
AND Pais.Nombre = T1.pais) AS Porcentaje FROM(

SELECT 
    (SELECT Nombre FROM Pais WHERE Pais.idPais = Region.idPais)AS Pais,
    (SELECT Nombre FROM Departamento WHERE Departamento.idDepartamento = Municipio.idDepartamento)AS Departamento,
    SUM(Analfabetas+Alfabetas) AS Total FROM Resultado
    
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
WHERE Sexo='mujeres'
GROUP BY Pais,Departamento
ORDER BY Total DESC

) AS T1
ORDER BY Pais,Departamento;

-- ******************************************************************
-- Consulta 3 FALTA
-- ******************************************************************
SELECT T1.Pais,T1.Partido
FROM(
SELECT 
    Pais.Nombre AS Pais,Resultado.idPartido AS Partido,SUM(Analfabetas+Alfabetas+Primaria+Medio+Universitarios) AS Total FROM Resultado
INNER JOIN Eleccion ON Eleccion.idEleccion = Resultado.idEleccion
INNER JOIN Puesto ON Puesto.idPuesto = Eleccion.idPuesto
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
WHERE Puesto.Nombre = 'Elecciones Municipales'
GROUP BY Pais,Partido
ORDER BY Total DESC) AS T1
GROUP BY Pais;

-- ******************************************************************
-- Consulta 4
-- ******************************************************************
SELECT Pais,Region,Raza,MAX(Total) AS Total FROM 
(SELECT Pais.Nombre AS Pais,Region.Nombre AS Region,Raza.Nombre AS Raza,SUM(Analfabetas+Alfabetas) AS Total FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
GROUP BY Pais.Nombre,Region.Nombre,Raza.Nombre
ORDER BY Total DESC) AS T1
GROUP BY Pais,Region
HAVING Raza='INDIGENAS';

-- ******************************************************************
-- Consulta 5
-- ******************************************************************

-- ******************************************************************
-- Consulta 6
-- ******************************************************************
SELECT Pais.Nombre AS Pais,Departamento.Nombre AS Departamento,Municipio.Nombre AS Municipio,SUM(Universitarios) AS Total FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
GROUP BY Pais,Departamento,Municipio
HAVING Total>SUM(Primaria)*0.25 AND Total<SUM(Medio)*0.30
ORDER BY Total DESC;

-- ******************************************************************
-- Consulta 7
-- ******************************************************************
SELECT Pais.Nombre AS Pais,Region.Nombre AS Region,SUM(Analfabetas+Alfabetas)/(SELECT COUNT(*) FROM Departamento WHERE Departamento.idRegion = Region.idRegion) AS Promedio FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
GROUP BY Pais,Region;

-- ******************************************************************
-- Consulta 8
-- ******************************************************************
SELECT Pais.Nombre AS Pais,SUM(Analfabetas) AS Analfabetas,SUM(Alfabetas) AS Alfabetas,SUM(Primaria) AS Primaria,SUM(Medio) AS Medio,SUM(Universitarios) AS Universitarios FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
GROUP BY Pais;

-- ******************************************************************
-- Consulta 9
-- ******************************************************************
SELECT Pais.Nombre AS Pais,Raza.Nombre,SUM(Analfabetas+Alfabetas)/
(
	SELECT SUM(Analfabetas+Alfabetas) FROM Resultado
    INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
	INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
	INNER JOIN Region On Region.idRegion = Departamento.idRegion
	INNER JOIN Pais ON Pais.idPais = Region.idPais
	INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
	WHERE Pais.Nombre = Pais
)*100 AS Porcentaje FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
WHERE Raza.Nombre='INDIGENAS'
GROUP BY Pais
UNION
SELECT Pais.Nombre AS Pais,Raza.Nombre,SUM(Analfabetas+Alfabetas)/
(
	SELECT SUM(Analfabetas+Alfabetas) FROM Resultado
    INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
	INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
	INNER JOIN Region On Region.idRegion = Departamento.idRegion
	INNER JOIN Pais ON Pais.idPais = Region.idPais
	INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
	WHERE Pais.Nombre = Pais
)*100 AS Porcentaje FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
WHERE Raza.Nombre='LADINOS'
GROUP BY Pais
UNION
SELECT Pais.Nombre AS Pais,Raza.Nombre,SUM(Analfabetas+Alfabetas)/
(
	SELECT SUM(Analfabetas+Alfabetas) FROM Resultado
    INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
	INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
	INNER JOIN Region On Region.idRegion = Departamento.idRegion
	INNER JOIN Pais ON Pais.idPais = Region.idPais
	INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
	WHERE Pais.Nombre = Pais
)*100 AS Porcentaje FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
WHERE Raza.Nombre='GARIFUNAS'
GROUP BY Pais
ORDER BY Pais;

-- ******************************************************************
-- Consulta 10
-- ******************************************************************
SELECT pais, (Mas-Menos) AS Diferencia FROM
(SELECT p1.nombre pais,
(SELECT SUM(alfabetas+analfabetas) AS Total FROM Resultado 
INNER JOIN Partido ON Partido.idPartido = Resultado.idPartido
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
WHERE Pais.idPais = p1.idPais
GROUP BY Partido.Nombre
ORDER BY total DESC
LIMIT 1) AS Mas,
(SELECT SUM(alfabetas+analfabetas) AS Total FROM Resultado 
INNER JOIN Partido ON Partido.idPartido = Resultado.idPartido
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
WHERE Pais.idPais = p1.idPais
GROUP BY Partido.Nombre
ORDER BY total ASC
LIMIT 1) AS Menos
FROM Pais p1)datos
LIMIT 1;

-- ******************************************************************
-- Consulta 11
-- ******************************************************************
SELECT Pais.Nombre AS Pais,SUM(Alfabetas) AS Total,SUM(Alfabetas)/(
SELECT SUM(Analfabetas+Alfabetas) AS Total FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
WHERE Pais.Nombre = Pais
)*100  AS Porcentaje FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
WHERE Raza.Nombre='INDIGENAS' AND Sexo='mujeres'
GROUP BY Pais.Nombre;

-- ******************************************************************
-- Consulta 12
-- ******************************************************************
SELECT Pais.Nombre AS Pais,SUM(Analfabetas)/
(
	SELECT SUM(Analfabetas+Alfabetas) FROM Resultado
    INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
	INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
	INNER JOIN Region On Region.idRegion = Departamento.idRegion
	INNER JOIN Pais ON Pais.idPais = Region.idPais
	WHERE Pais.Nombre = Pais
)*100 AS Porcentaje FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
GROUP BY Pais
ORDER BY Porcentaje DESC LIMIT 1;

-- ******************************************************************
-- Consulta 13
-- ******************************************************************
SELECT Pais.Nombre AS Pais,Departamento.Nombre AS Departamento,SUM(Alfabetas+Analfabetas) AS Total FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
WHERE Pais.Nombre='GUATEMALA'
GROUP BY Pais.Nombre,Departamento.Nombre
HAVING Total>(
SELECT SUM(Alfabetas+Analfabetas) AS Total FROM Resultado
INNER JOIN Municipio ON Municipio.idMunicipio = Resultado.idMunicipio
INNER JOIN Departamento ON Departamento.idDepartamento = Municipio.idDepartamento
INNER JOIN Region On Region.idRegion = Departamento.idRegion
INNER JOIN Pais ON Pais.idPais = Region.idPais
INNER JOIN Raza ON Raza.idRaza= Resultado.idRaza
WHERE Pais.Nombre='GUATEMALA' AND Departamento.Nombre='Guatemala'
);