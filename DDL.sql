-- TABLE Definition

--122
-- Constrainer

CREATE TABLE persona (

    fecha_nacimiento DATE , 
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipoDoc VARCHAR (15) ,
    nrDoc VARCHAR(15)
) ;

CREATE TABLE tripulante (

    cargo VARCHAR(20) , 
    salario FLOAT ,
    fecha_nacimiento DATE , 
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipoDoc_persona VARCHAR (15) ,
    nrDoc_persona VARCHAR(15)
);

CREATE TABLE comprador (

    correo_electronico VARCHAR(40) , 
    contasena VARCHAR(30) ,
    fecha_nacimiento DATE , 
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipoDoc_persona VARCHAR (15) ,
    nrDoc_persona VARCHAR(15)    
);

CREATE TABLE pasajero (

    fecha_nacimiento DATE , 
    apellido VARCHAR(25) ,
    nombre  VARCHAR(25) ,
    tipoDoc_persona VARCHAR (15) ,
    nrDoc_persona VARCHAR(15)
) ;

CREATE TABLE reserva (

    fecha DATE ,
    costo_total FLOAT,
    codigo VARCHAR(10), 
    tipoDoc_comprador VARCHAR (15) ,
    nrDoc_comprador VARCHAR(15)
) ; 

CREATE TABLE reservaPasajero(

    id VARCHAR(15) , 
    estado_check BIT ,
    codigo VARCHAR(10) ,
    tipoDoc_comprador VARCHAR (15) ,
    nrDoc_comprador VARCHAR(15),
    tipoDoc_pasajero VARCHAR (15) ,
    nrDoc_pasajero VARCHAR(15)
);

CREATE TABLE polizaDeSeguro (

    costo FLOAT ,
    nroPoliza VARCHAR(12) ,
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
    tipoDoc_pasajero VARCHAR (15) ,
    nrDoc_pasajero VARCHAR(15) ,
    tipoDoc_comprador VARCHAR (15) ,
    nrDoc_comprador VARCHAR(15)
);

CREATE TABLE asiento (

    nroAsiento VARCHAR(15) ,
    nroMatricula_avion VARCHAR(15)
);

CREATE TABLE avion (

    nroMatricula VARCHAR(15) ,
    capacidad INTEGER , 
    nroVuelo_vuelo VARCHAR(10) 
);

CREATE TABLE vuelo (

    fecha_salida DATE ,
    fecha_llegada DATE ,
    nroVuelo VARCHAR(10) ,
    codigoIata_aeropuerto VARCHAR(15)
);

CREATE TABLE aeropuerto (

    nombre VARCHAR(25),
    ubicacion VARCHAR(50) , 
    capacidad INTEGER ,
    codigoIata VARCHAR(15) 
);

CREATE TABLE tripulanteAsignado (
    tipoDoc_persona_tripulante VARCHAR (15) ,
    nrDoc_persona_tripulante VARCHAR(15) ,
    nroVuelo_vuelo VARCHAR(10) 
);

CREATE TABLE incluye (

    tipoDoc_pasajero VARCHAR (15) ,
    nrDoc_pasajero VARCHAR(15) ,
    tipoDoc_comprador VARCHAR (15) ,
    nrDoc_comprador VARCHAR(15) ,
    codigo_reserva VARCHAR(10) , 
    id_reserva_pasajero VARCHAR(15) , 
    nroVuelo_vuelo VARCHAR(10) 
)

CREATE TABLE asientoOcupa(

    id_reserva_pasajero VARCHAR(15) , 
    nroMatricula_avion VARCHAR(15) , 
    nroAsiento_asiento VARCHAR(15) ,
    tipoDoc_pasajero VARCHAR (15) ,
    nrDoc_pasajero VARCHAR(15) ,
    codigo_reserva VARCHAR(10) , 
    tipoDoc_comprador VARCHAR (15) ,
    nrDoc_comprador VARCHAR(15) ,
)