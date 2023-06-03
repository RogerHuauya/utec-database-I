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


CREATE TABLE reserva_equipaje (

    codigo_tipo_tipo_pasajero VARCHAR(15) ,
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

    nombre VARCHAR(25),
    ubicacion VARCHAR(50) , 
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
    nro_vuelo_vuelo VARCHAR(10) ,
);

CREATE TABLE pertenece (

    sub_reservacion_id_sub_reservacion VARCHAR(15) ,
    nro_asiento_asiento_disponible VARCHAR(15) ,
    nro_vuelo_vuelo VARCHAR(10) ,
);




