create schema condorito;
set search_path = condorito;
-- TABLE Definition

CREATE TABLE persona (

    fecha_nacimiento DATE ,
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipo_documento VARCHAR (15) ,
    nro_documento VARCHAR(15)
);

CREATE TABLE tripulante (

    cargo VARCHAR(20) ,
    salario FLOAT ,
    tipo_documento_persona VARCHAR (15) ,
    nro_documento_persona VARCHAR(15)
);

CREATE TABLE comprador (

    correo_electronico VARCHAR(40) , 
    contrasena VARCHAR(30) ,
    tipo_documento_persona VARCHAR (15) ,
    nro_documento_persona VARCHAR(15)
);

CREATE TABLE pasajero (
    
    nro_telefono VARCHAR (20) ,
    tipo_documento_persona VARCHAR (15) ,
    nro_documento_persona VARCHAR(15)
);


CREATE TABLE reservacion (

    fecha DATE ,
    costo_total FLOAT,
    codigo VARCHAR(10),
    tipo_documento_comprador VARCHAR (15) ,
    nro_documento_comprador VARCHAR(15)
); 

CREATE TABLE sub_reservacion(

    sub_reservacion_id VARCHAR(15) , 
    estado_check BOOLEAN ,
    codigo_reservacion VARCHAR(10) ,
    tipo_documento_pasajero VARCHAR (15) ,
    nro_documento_pasajero VARCHAR(15)
);


CREATE TABLE sub_reserva_equipaje (

    codigo_tipo_tipo_equipaje VARCHAR(15) ,
    cantidad INTEGER ,
    sub_reservacion_id_sub_reservacion VARCHAR(15) 
);

CREATE TABLE tipo_equipaje (

    peso_maximo FLOAT ,
    codigo_tipo VARCHAR(15) , 
    costo FLOAT 
);


CREATE TABLE tripulante_asignado (
    tipo_documento_persona_tripulante VARCHAR (15) ,
    nro_documento_persona_tripulante VARCHAR(15) ,
    nro_vuelo_vuelo VARCHAR(10)
);


CREATE TABLE vuelo (

    fecha_salida DATE ,
    fecha_llegada DATE ,
    nro_vuelo VARCHAR(10) ,
    codigo_iata_aeropuerto_origen VARCHAR(15) ,
    codigo_iata_aeropuero_destino VARCHAR(15) ,
    nro_matricula_avion VARCHAR(15)
);


CREATE TABLE aeropuerto (

    nombre VARCHAR(255),
    ubicacion VARCHAR(255) , 
    capacidad INTEGER ,
    codigo_iata VARCHAR(15) 
);

CREATE TABLE avion (

    nro_matricula VARCHAR(15) ,
    capacidad INTEGER , 
    modelo VARCHAR(20) 
);

CREATE TABLE asiento_disponible (

    nro_asiento VARCHAR(15) ,
    nro_vuelo_vuelo VARCHAR(10)
);

CREATE TABLE pertenece (

    sub_reservacion_id_sub_reservacion VARCHAR(15) ,
    nro_asiento_asiento_disponible VARCHAR(15) ,
    nro_vuelo_vuelo VARCHAR(10)
);


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
PRIMARY KEY (tipo_documento, nro_documento);

--comprador
Alter TABLE comprador
ADD CONSTRAINT fk_comprador_persona
FOREIGN KEY (tipo_documento_persona,nro_documento_persona) REFERENCES persona(tipo_documento, nro_documento);

ALTER TABLE comprador
ADD CONSTRAINT pk_comprador
PRIMARY KEY (tipo_documento, nro_documento);

--pasajero
Alter TABLE pasajero
ADD CONSTRAINT fk_pasajero_persona
FOREIGN KEY (tipo_documento_persona, nro_documento_persona) REFERENCES persona(tipo_documento, nro_documento);

ALTER TABLE pasajero
ADD CONSTRAINT pk_pasajero
PRIMARY KEY (tipo_documento, nro_documento);

--reservacion
ALTER TABLE reservacion
ADD CONSTRAINT pk_reservacion
PRIMARY KEY (codigo);

ALTER TABLE reservacion 
ADD CONSTRAINT fk_reservacion_comprador
FOREIGN KEY (tipo_documento_comprador, nro_documento_comprador) REFERENCES comprador (tipo_documento, nro_documento)

--subreservacion

ALTER TABLE sub_reservacion
ADD CONSTRAINT pk_sub_reservacion
PRIMARY KEY(sub_reservacion_id);

ALTER TABLE sub_reservacion
ADD CONSTRAINT fk_sub_reservacion_pasajero
FOREIGN KEY (tipo_documento_pasajero, nro_documento_pasajero) REFERENCES pasajero (tipo_documento, nro_documento);

ALTER TABLE sub_reservacion 
ADD CONSTRAINT fk_sub_reservacion_reservacion
FOREIGN KEY (codigo_reservacion) REFERENCES reservacion (codigo);

--sub_reserva_equipaje
ALTER TABLE sub_reserva_equipaje
add CONSTRAINT pk_sub_reserva_equipaje
PRIMARY KEY (codigo_tipo_tipo_equipaje, sub_reservacion_id_sub_reservacion);

Alter table sub_reserva_equipaje
ADD CONSTRAINT fk_id_sub_reserva
FOREIGN KEY(sub_reservacion_id_sub_reservacion)
REFERENCES sub_reservacion(sub_reservacion_id);

ALTER TABLE sub_reserva_equipaje
ADD CONSTRAINT fk_sub_reserva_equipaje
FOREIGN KEY (codigo_tipo_tipo_equipaje) REFERENCES tipo_equipaje (codigo_tipo);

--tipo_equipaje
ALTER TABLE tipo_equipaje
ADD CONSTRAINT pk_tipo_equipaje
PRIMARY KEY(codigo_tipo);

--vuelo
ALTER TABLE vuelo
ADD CONSTRAINT pk_vuelo
PRIMARY KEY (nro_vuelo);

ALTER TABLE vuelo
ADD CONSTRAINT fk_avion
FOREIGN KEY (nro_matricula_avion)
REFERENCES avion(nro_matricula)

ALTER TABLE vuelo
ADD CONSTRAINT fk_aeropuerto_origen
FOREIGN KEY(codigo_iata_aeropuerto_origen)
REFERENCES aeropuerto(codigo_iata)

ALTER TABLE vuelo
ADD CONSTRAINT fk_aeropuerto_destino
FOREIGN KEY(codigo_iata_aeropuerto_destino)
REFERENCES aeropuerto(codigo_iata)

--tripulante_asignado
ALTER TABLE tripulante_asignado
ADD CONSTRAINT fk_tripulante_asignado
FOREIGN KEY (tipo_documento_persona_tripulante, nro_documento_persona_tripulante)
REFERENCES tripulante(tipo_documento_persona, nro_documento_persona)

ALTER TABLE tripulante_asignado
ADD CONSTRAINT fk_tripulante_asignado_vuelo
FOREIGN KEY (nro_vuelo_vuelo)
REFERENCES vuelo(nro_vuelo);

ALTER TABLE tripulante_asignado
ADD CONSTRAINT pk_tripulante_asignado
PRIMARY KEY (tipo_documento_persona_tripulante, nro_documento_persona_tripulante, nro_vuelo_vuelo);

--aeropuerto
ALTER TABLE aeropuerto
ADD CONSTRAINT pk_aeropuerto
PRIMARY KEY (codigo_iata);

--avion
ALTER TABLE avion
ADD CONSTRAINT pk_avion
PRIMARY KEY (nro_matricula);

--asiento_disponible
ADD CONSTRAINT fk_asiento_disponible
FOREIGN KEY (nro_vuelo_vuelo)
REFERENCES vuelo(nro_vuelo);

ALTER TABLE asiento_disponible
ADD CONSTRAINT pk_asiento
PRIMARY KEY (nro_asiento, nro_vuelo_vuelo);

--pertenece
ALTER TABLE pertenece
ADD CONSTRAINT fk_pertenece_asientodis
FOREIGN KEY (nro_asiento_asiento_disponible)
REFERENCES asiento_disponible(nro_asiento);

ALTER TABLE pertenece
ADD CONSTRAINT fk_pertenece_vuelo
FOREIGN KEY (nro_vuelo_vuelo)
REFERENCES vuelo (nro_vuelo);

ALTER TABLE pertenece
ADD CONSTRAINT fk_pertenece_subreserva
FOREIGN KEY (sub_reservacion_id_sub_reservacion)
REFERENCES sub_reservacion(sub_reservacion_id);

ALTER TABLE pertenece
ADD CONSTRAINT pk_pertenece
PRIMARY KEY (nro_asiento_asiento_disponible, nro_vuelo_vuelo);

