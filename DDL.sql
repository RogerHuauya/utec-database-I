-- TABLE Definition

CREATE TABLE persona (

    fecha_nacimiento DATE ,
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipo_documento VARCHAR (15) ,
    nro_documento VARCHAR(15)
) ;

CREATE TABLE tripulante (

    cargo VARCHAR(20) ,
    salario FLOAT ,
    fecha_nacimiento DATE ,
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipo_documento_persona VARCHAR (15) ,
    nro_documento_persona VARCHAR(15)
);

CREATE TABLE comprador (

    correo_electronico VARCHAR(40) ,
    contasena VARCHAR(30) ,
    fecha_nacimiento DATE ,
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipo_documento_persona VARCHAR (15) ,
    nro_documento_persona VARCHAR(15)
);

CREATE TABLE pasajero (

    fecha_nacimiento DATE ,
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipo_documento_persona VARCHAR (15) ,
    nro_documento_persona VARCHAR(15)
) ;

CREATE TABLE reserva (

    fecha DATE ,
    costo_total FLOAT,
    codigo VARCHAR(10),
    tipo_documento_comprador VARCHAR (15) ,
    nro_documento_comprador VARCHAR(15)
) ;

CREATE TABLE reserva_pasajero(

    id VARCHAR(15) ,
    estado_check BIT ,
    codigo VARCHAR(10) ,
    tipo_documento_comprador VARCHAR (15) ,
    nro_documento_comprador VARCHAR(15),
    tipo_documento_pasajero VARCHAR (15) ,
    nro_documento_pasajero VARCHAR(15)
);

CREATE TABLE poliza_de_seguro (

    costo FLOAT ,
    nro_poliza VARCHAR(12) ,
    monto_cobertura FLOAT ,
    fecha_inicial DATE ,
    fecha_final DATE ,
    id_reserva_pasajero VARCHAR(15)
) ;

CREATE TABLE equipaje (

    peso_real FLOAT ,
    tipo VARCHAR(15) ,
    peso_maximo FLOAT ,
    id  VARCHAR(15) ,
    costo FLOAT ,
    id_reserva_pasajero VARCHAR(15) ,
    codigo_reserva VARCHAR(10) ,
    tipo_documento_pasajero VARCHAR (15) ,
    nro_documento_pasajero VARCHAR(15) ,
    tipo_documento_comprador VARCHAR (15) ,
    nro_documento_comprador VARCHAR(15)
);

CREATE TABLE asiento (

    nro_asiento VARCHAR(15) ,
    nro_matricula_avion VARCHAR(15)
);

CREATE TABLE vuelo (

    fecha_salida DATE ,
    fecha_llegada DATE ,
    nro_vuelo VARCHAR(10) ,
    codigo_iata_aeropuerto VARCHAR(15)
);

CREATE TABLE avion (

    nro_matricula VARCHAR(15) ,
    capacidad INTEGER ,
    nro_vuelo_vuelo VARCHAR(10)
);

CREATE TABLE aeropuerto (

    nombre VARCHAR(25),
    ubicacion VARCHAR(50) ,
    capacidad INTEGER ,
    codigo_iata VARCHAR(15)
);

CREATE TABLE tripulante_asignado (
    tipo_documento_persona_tripulante VARCHAR (15) ,
    nro_documento_persona_tripulante VARCHAR(15) ,
    nro_vuelo_vuelo VARCHAR(10)
);

CREATE TABLE incluye (

    tipo_documento_pasajero VARCHAR (15) ,
    nro_documento_pasajero VARCHAR(15) ,
    tipo_documento_comprador VARCHAR (15) ,
    nro_documento_comprador VARCHAR(15) ,
    codigo_reserva VARCHAR(10) ,
    id_reserva_pasajero VARCHAR(15) ,
    nro_vuelo_vuelo VARCHAR(10)
) ;

CREATE TABLE asiento_ocupa(

    id_reserva_pasajero VARCHAR(15) ,
    nro_matricula_avion VARCHAR(15) ,
    nro_asiento_asiento VARCHAR(15) ,
    tipo_documento_pasajero VARCHAR (15) ,
    nro_documento_pasajero VARCHAR(15) ,
    codigo_reserva VARCHAR(10) ,
    tipo_documento_comprador VARCHAR (15) ,
    nro_documento_comprador VARCHAR(15) ,
) ;



-- Constrainer

--Persona
ALTER TABLE persona
ADD CONSTRAINT pk_persona
PRIMARY KEY (tipo_documento, nro_documento);

--tripulante
ALTER TABLE tripulante
ADD CONSTRAINT fk_tripulante_persona
FOREIGN KEY (tipo_documento_persona,nro_documento_persona) REFERENCES persona (tipo_documento, nro_documento);

ALTER TABLE tripulante
ADD CONSTRAINT pk_tripulante
PRIMARY KEY (tipo_documento_persona, nro_documento_persona);

--comprador
Alter TABLE comprador
ADD CONSTRAINT fk_comprador_persona
FOREIGN KEY (tipo_documento_persona,nro_documento_persona) REFERENCES persona(tipo_documento, nro_documento);

ALTER TABLE comprador
ADD CONSTRAINT pk_comprador
PRIMARY KEY (tipo_documento_persona, nro_documento_persona);

--pasajero
Alter TABLE pasajero
ADD CONSTRAINT fk_pasajero_persona
FOREIGN KEY (tipo_documento_persona, nro_documento_persona) REFERENCES persona(tipo_documento, nro_documento);

ALTER TABLE pasajero
ADD CONSTRAINT pk_pasajero
PRIMARY KEY (tipo_documento_persona, nro_documento_persona);

--reserva

ALTER TABLE reserva
ADD CONSTRAINT fk_reserva_comprador
FOREIGN KEY (tipo_documento_comprador,nro_documento_comprador) REFERENCES comprador (tipo_documento_persona, nro_documento_persona);

ALTER TABLE reserva
ADD CONSTRAINT pk_reserva
PRIMARY KEY (tipo_documento_comprador, nro_documento_comprador, codigo);

--reserrvapasajero
ALTER TABLE reserva_pasajero
ADD CONSTRAINT fk_reserva_pasajero
FOREIGN KEY (tipo_documento_pasajero,nro_documento_pasajero) REFERENCES pasajero
(tipo_documento_persona, nro_documento_persona);

ALTER TABLE reserva_pasajero
ADD CONSTRAINT fk_reserva_pasajero
FOREIGN KEY (tipo_documento_comprador,nro_documento_comprador ) REFERENCES comprador
(tipo_documento_persona, nro_documento_persona);

ALTER TABLE reserva_pasajero
ADD CONSTRAINT fk_reserva_pasajero
FOREIGN KEY (codigo) REFERENCES reserva(codigo);

ALTER TABLE reserva_pasajero
ADD CONSTRAINT pk_reserva_pasajero
PRIMARY KEY (tipo_documento_pasajero,nro_documento_pasajero,tipo_documento_comprador,nro_documento_comprador,codigo,id);

--vuelo

ALTER TABLE vuelo
ADD CONSTRAINT pk_vuelo
PRIMARY KEY (nro_vuelo);

--tripulanteasignado

ALTER TABLE tripulante_asignado
ADD CONSTRAINT fk_tripulante_asignado
FOREIGN KEY (tipo_documento_persona_tripulante,nro_documento_persona_tripulante)
REFERENCES tripulante (tipo_documento_persona,nro_documento_persona);

ALTER TABLE tripulante_asignado
ADD CONSTRAINT fk_tripulante_asignado
FOREIGN KEY (nro_vuelo_vuelo)
REFERENCES vuelo(nro_vuelo);

ALTER TABLE tripulante_asignado
ADD CONSTRAINT pk_tripulante_asignado
PRIMARY KEY (tipo_documento_persona_tripulante,nro_documento_persona_tripulante,nro_vuelo_vuelo);

--aeropuerto

ALTER TABLE aeropuerto
ADD CONSTRAINT pk_aeropuerto
PRIMARY KEY (codigo_iata);

--avion

ALTER TABLE avion
ADD CONSTRAINT pk_avion
PRIMARY KEY (nro_matricula);

--polizaseguro

ALTER TABLE poliza_seguro
ADD CONSTRAINT pk_poliza_seguro
PRIMARY KEY (nro_poliza);

--equipaje

ALTER TABLE equipaje
ADD CONSTRAINT fk_equipaje
FOREIGN KEY (tipo_documento_pasajero, nro_documento_pasajero)
REFERENCES pasajero (tipo_documento_persona,nro_documento_persona);

ALTER TABLE equipaje
ADD CONSTRAINT fk_equipaje
FOREIGN KEY (codigo_reserva)
REFERENCES reserva(codigo);

ALTER TABLE equipaje
ADD CONSTRAINT fk_equipaje
FOREIGN KEY (tipo_documento_comprador,nro_documento_comprador)
REFERENCES comprador(tipo_documento_persona,nro_documento_persona);

ALTER TABLE equipaje
ADD CONSTRAINT pk_equipaje PRIMARY KEY(tipo_documento_pasajero, nro_documento_pasajero,codigo_reserva,tipo_documento_comprador,nro_documento_comprador,id);

--asiento
ALTER TABLE asiento
ADD CONSTRAINT pk_asiento PRIMARY KEY(nro_asiento, nro_matricula_avion);

--asiento ocupa
ALTER TABLE asiento_ocupa
ADD CONSTRAINT fk_asiento_ocupa
FOREIGN KEY (nro_matricula_avion, nro_asiento_asiento)
REFERENCES avion (nro_matricula, nro_vuelo_vuelo);

ALTER TABLE asiento_ocupa
ADD CONSTRAINT fk_equipaje
FOREIGN KEY (tipo_documento_pasajero, nro_documento_pasajero)
REFERENCES pasajero (tipo_documento_persona,nro_documento_persona);

ALTER TABLE asiento_ocupa
ADD CONSTRAINT fk_equipaje
FOREIGN KEY (tipo_documento_comprador,nro_documento_comprador)
REFERENCES comprador(tipo_documento_persona,nro_documento_persona);

ALTER TABLE asiento_ocupa
ADD CONSTRAINT pk_asiento_ocupa
PRIMARY KEY (nro_matricula_avion, nro_asiento_asiento,tipo_documento_pasajero, nro_documento_pasajero,tipo_documento_comprador,nro_documento_comprador);

--incluye
ALTER TABLE incluye
ADD CONSTRAINT fk_equipaje
FOREIGN KEY (tipo_documento_pasajero, nro_documento_pasajero)
REFERENCES pasajero (tipo_documento_persona,nro_documento_persona);

ALTER TABLE incluye
ADD CONSTRAINT fk_equipaje
FOREIGN KEY (tipo_documento_comprador,nro_documento_comprador)
REFERENCES comprador(tipo_documento_persona,nro_documento_persona);

ALTER TABLE incluye
ADD CONSTRAINT pk_incluye PRIMARY KEY(tipo_documento_pasajero, nro_documento_pasajero,tipo_documento_comprador,nro_documento_comprador,id_reserva_pasajero);
