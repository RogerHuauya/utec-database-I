-- TABLE Definition
--2
-- Constrainer

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
    codigo_reserva VARCHAR(10) ,
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
    codigo_reserva VARCHAR(10) ,
    id_reserva_pasajero VARCHAR(15)  ,
    tipo_documento_comprador VARCHAR (15) ,
    nro_documento_comprador VARCHAR(15),
    tipo_documento_pasajero VARCHAR (15) ,
    nro_documento_pasajero VARCHAR(15)

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
    codigo_iata_aeropuerto_origen VARCHAR(15) ,
    codigo_iata_aeropuero_destino VARCHAR(15)

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