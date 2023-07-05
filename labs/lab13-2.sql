--drop table votos2;
START TRANSACTION;
--creando table votos2
CREATE TABLE votos1(
	candidato varchar(120),
	centro varchar(6) NOT NULL,
	HoraReporte timestamp without time zone ,
	votos int
);

--CREANDO votos1
INSERT INTO votos1 (
					SELECT NOMBRE, ID, (select now()), (floor(random() * (10 - 0 + 1)) + 0)
					FROM Distrito D, Candidato C
					);

--actualizando votos por centro con votos1
UPDATE VotosPorCentro
	SET ultimareporte = votos1.horareporte, votos =  votos1.votos
	FROM votos1
	WHERE VotosPorCentro.candidato = votos1.candidato
		AND VotosPorCentro.centro = votos1.centro;

--actualizando reportado de SedeProvincial con votos1
UPDATE SedeProvincial SET reportado = P.votos
FROM (
	 SELECT SUM(votos) AS votos, provinciaid
	 FROM votos1 v1 INNER JOIN distrito d ON v1.centro = d.id
	 GROUP BY provinciaid
		) P
WHERE codigo = P.provinciaid;

--actualizando reportado de SedeDepartamental con votos1
UPDATE SedeDepartamental SET reportado = D.votos
FROM (
	 SELECT SUM(votos) AS votos, departamentoid
	 FROM votos1 v1 INNER JOIN distrito d ON v1.centro = d.id
	 GROUP BY departamentoid
	 ) D
WHERE codigo = D.departamentoid;

--actualizando reportado de CentroVotacion con votos1
UPDATE CentroVotacion SET reportado = CV.votos
FROM (
		SELECT SUM(votos) AS votos, centro
		FROM votos1
		GROUP BY centro
	) CV
WHERE codigo = CV.centro;


--actualizando totalvotos de candidato con votos1
UPDATE Candidato SET totalvotos = C.votos
FROM (
		SELECT SUM(votos) AS votos, candidato
		FROM votos1
		GROUP BY candidato
	) C
WHERE nombre = C.candidato;

COMMIT;



START TRANSACTION;
--creando table votos2
CREATE TABLE Votos2(
	candidato varchar(120),
	centro varchar(6) NOT NULL,
	HoraReporte timestamp without time zone ,
	votos int
);

Insert into Votos2 (select * from votos1);
--CREANDO votos2
INSERT INTO Votos2 (
					SELECT NOMBRE, ID, (select now()), (floor(random() * (10 - 0 + 1)) + 0)
					FROM Distrito D, Candidato C
					);

--actualizando votos por centro con votos2
UPDATE VotosPorCentro
	SET ultimareporte = votos2.horareporte, votos =  votos2.votos
	FROM votos2
	WHERE VotosPorCentro.candidato = votos2.candidato
		AND VotosPorCentro.centro = votos2.centro;

--actualizando reportado de SedeProvincial con votos2
UPDATE SedeProvincial SET reportado = P.votos
FROM (
	 SELECT SUM(votos) AS votos, provinciaid
	 FROM votos2 v1 INNER JOIN distrito d ON v1.centro = d.id
	 GROUP BY provinciaid
		) P
WHERE codigo = P.provinciaid;

--actualizando reportado de SedeDepartamental con votos2
UPDATE SedeDepartamental SET reportado = D.votos
FROM (
	 SELECT SUM(votos) AS votos, departamentoid
	 FROM votos2 v1 INNER JOIN distrito d ON v1.centro = d.id
	 GROUP BY departamentoid
	 ) D
WHERE codigo = D.departamentoid;

--actualizando reportado de CentroVotacion con votos2
UPDATE CentroVotacion SET reportado = CV.votos
FROM (
		SELECT SUM(votos) AS votos, centro
		FROM votos2
		GROUP BY centro
	) CV
WHERE codigo = CV.centro;


--actualizando totalvotos de candidato con votos2
UPDATE Candidato SET totalvotos = C.votos
FROM (
		SELECT SUM(votos) AS votos, candidato
		FROM votos2
		GROUP BY candidato
	) C
WHERE nombre = C.candidato;

COMMIT;