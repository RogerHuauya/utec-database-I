-- Participacion
    -- Roger Huauya (100%)
    -- Melisa Rivera (100%)
    -- Diana (50%)
    -- Rodrigo (50%)
    -- Manuel (85%)


-- Modelo Relacional

-- Deposito(id, dimensión, capacidad_galones, abastecido_galones, Combustible.tipo)

-- Combustible (tipo)

-- Abastecimiento(nro, fecha, cantidad_galones, precio, Deposito.id, Provedor.Nro_licencia, Provedor.placa_camion)

-- Provedor(nro_licencia, placa_camión)

-- Persona_natural(nro_documento)

-- Despachador_Combustible (nro_documento, sueldo)

-- Cliente(nro _documento)

-- Venta(nro, fecha, monto_total, cantidad_galones, precio_unitario, SurtidorC.nroserie, Surtidor.lado, DespachadorC.nro_documento, Cliente.nro_documento)

-- SurtidorCombustible(nroserie, lado, marca, deposito.id)


create schema petrogas7;
set search_path to petrogas7;

-- Acapite a

CREATE TABLE deposito (
    id INTEGER,
    dimension VARCHAR(100),
    capacidad_galones INTEGER,
    abastecido_galones INTEGER,
    tipo VARCHAR(50)
);

CREATE TABLE combustible (
    tipo VARCHAR(50)
);

CREATE TABLE abastecimiento (
    nro INTEGER,
    fecha DATE,
    cantidad_galones FLOAT,
    precio FLOAT,
    id INTEGER,
    nro_licencia VARCHAR(15),
    placa_camion VARCHAR(15)
);

CREATE TABLE proveedor (
    placa_camion VARCHAR(15),
    nro_licencia VARCHAR(15)
);


create table venta (
    nro INTEGER,
    fecha DATE,
    monto_total FLOAT,
    cantidad_galones INTEGER,
    precio_unitario FLOAT,
    nroserie VARCHAR(25),
    lado VARCHAR(10),
    nro_documento_Despachador VARCHAR(20),
    nro_documento_Cliente VARCHAR(20)
);


CREATE TABLE personal_natural (
    nro_documento VARCHAR(100)
);

CREATE TABLE cliente (
    nro_documento VARCHAR(20)
);

CREATE TABLE Despachador_Combustible (
    nro_documento VARCHAR(20),
    sueldo float
);

CREATE TABLE surtidor_combustible (
    nroserie VARCHAR(25),
    lado VARCHAR(10),
    marca VARCHAR(30),
    id INTEGER
);

-- Acapite b

-- Restricciones Primarias
ALTER TABLE deposito ADD constraint deposito_pk_id primary key (id);
ALTER TABLE combustible add constraint combustible_tipo primary key (tipo);
ALTER TABLE abastecimiento add constraint abastecimiento_pk_nro primary key (nro);
ALTER TABLE proveedor ADD constraint proveedor_pk_placa_camion_nro_licencia primary key(placa_camion, nro_licencia)
ALTER TABLE venta ADD constraint venta_pk_nro primary key (nro);
ALTER TABLE personal_natural ADD constraint personal_natural_pk_nro_documento primary key (nro_documento);
ALTER TABLE cliente ADD constraint cliente_pk_nro_documento primary key (nro_documento);
ALTER table surtidor_combustible add constraint surtidor_combustible_pk_nroserie_lado primary key (nroserie, lado);
ALTER TABLE despachador_combustible add constraint despachador_combustible_pk_nro_documento primary key(nro_documento);


-- Restricciones Foraneas
ALTER TABLE deposito ADD CONSTRAINT deposito_tipo FOREIGN KEY (tipo) REFERENCES combustible (tipo);
ALTER TABLE abastecimiento ADD CONSTRAINT prov_lic FOREIGN KEY (placa_camion, nro_licencia) REFERENCES proveedor (placa_camion, nro_licencia);
ALTER TABLE abastecimiento ADD CONSTRAINT llave_deposito FOREIGN KEY (id) REFERENCES deposito (id);
ALTER TABLE venta ADD CONSTRAINT surt_key FOREIGN KEY (nroserie, lado) REFERENCES surtidor_combustible (nroserie, lado);
ALTER TABLE venta ADD CONSTRAINT despachador_key FOREIGN KEY (nro_documento_Despachador) REFERENCES despachador_combustible (nro_documento);
ALTER TABLE venta ADD CONSTRAINT cliente_key FOREIGN KEY (nro_documento_Cliente) REFERENCES cliente (nro_documento) ;
ALTER TABLE surtidor_combustible ADD CONSTRAINT deposito_fk_id FOREIGN KEY (id) REFERENCES deposito (id);


--- Acapite c
ALTER TABLE personal_natural ADD nombre  VARCHAR(40);
ALTER TABLE personal_natural ADD apellido VARCHAR(40);
ALTER TABLE personal_natural ADD fecha_nacimiento DATE;
ALTER TABLE personal_natural ADD email VARCHAR(60);
ALTER TABLE personal_natural ADD ciudad VARCHAR(60);

ALTER TABLE personal_natural ADD CONSTRAINT email UNIQUE (email);

ALTER TABLE personal_natural ADD COLUMN  edad INTEGER CHECK (edad >= 12  AND edad <= 85) ;

ALTER TABLE proveedor ADD CONSTRAINT nro_licencia CHECK (nro_licencia ~* '^P');

ALTER TABLE abastecimiento ADD COLUMN hora TIME CHECK (hora >= '23:00:00' AND hora <= '23:59:00') ;

ALTER TABLE proveedor ADD CONSTRAINT placa_camion CHECK(placa_camion ~ '^[A-Za-z0-9]{6}$') ;

ALTER TABLE deposito ADD CONSTRAINT  abastecido_galones CHECK (abastecido_galones <= capacidad_galones ) ;

ALTER TABLE deposito ADD CONSTRAINT capacidad_galones CHECK (capacidad_galones >= 0 ) ;

ALTER TABLE deposito ALTER COLUMN id SET NOT NULL, ALTER COLUMN dimension SET NOT NULL, ALTER COLUMN capacidad_galones SET NOT NULL,ALTER COLUMN abastecido_galones SET NOT NULL,ALTER COLUMN tipo SET NOT NULL;
ALTER TABLE combustible ALTER COLUMN tipo SET NOT NULL;
ALTER TABLE abastecimiento ALTER COLUMN nro SET NOT NULL, ALTER COLUMN fecha SET NOT NULL, ALTER COLUMN cantidad_galones SET NOT NULL, ALTER COLUMN precio SET NOT NULL, ALTER COLUMN id SET NOT NULL, ALTER COLUMN nro_licencia SET NOT NULL, ALTER COLUMN placa_camion SET NOT NULL;
ALTER TABLE proveedor ALTER COLUMN placa_camion SET NOT NULL, ALTER COLUMN nro_licencia SET NOT NULL;
ALTER TABLE venta ALTER COLUMN nro SET NOT NULL, ALTER COLUMN fecha SET NOT NULL, ALTER COLUMN monto_total SET NOT NULL, ALTER COLUMN cantidad_galones SET NOT NULL, ALTER COLUMN precio_unitario SET NOT NULL, ALTER COLUMN nroserie SET NOT NULL, ALTER COLUMN lado SET NOT NULL , ALTER COLUMN nro_documento_Despachador SET NOT NULL, ALTER COLUMN nro_documento_Cliente SET NOT NULL;
ALTER TABLE personal_natural ALTER COLUMN nro_documento SET NOT NULL;
ALTER TABLE cliente ALTER COLUMN nro_documento SET NOT NULL;
ALTER TABLE despachador_combustible ALTER COLUMN nro_documento SET NOT NULL, ALTER COLUMN sueldo SET NOT NULL;
ALTER TABLE surtidor_combustible ALTER COLUMN nroserie SET NOT NULL, ALTER COLUMN lado SET NOT NULL, ALTER COLUMN marca SET NOT NULL, ALTER COLUMN id SET NOT NULL;

ALTER TABLE personal_natural ADD COLUMN nro_celular VARCHAR(9) CHECK (nro_celular LIKE '9%' AND length(nro_celular) = 9);

CREATE SEQUENCE venta_nro_seq
    START 100
    INCREMENT BY 5;

ALTER TABLE venta ALTER COLUMN nro SET DEFAULT nextval('venta_nro_seq');
ALTER TABLE deposito ALTER COLUMN dimension SET DEFAULT '10x10x10';
ALTER TABLE abastecimiento ALTER COLUMN fecha SET DEFAULT current_date;
ALTER TABLE abastecimiento ALTER COLUMN precio SET DEFAULT 0;
ALTER TABLE venta ALTER COLUMN fecha SET DEFAULT current_date;
ALTER TABLE Despachador_Combustible ALTER COLUMN sueldo SET DEFAULT 1025;

-- Acapite d Insertando Datos

INSERT INTO combustible (tipo)
VALUES ('Diesel'), ('Gasolina');

INSERT INTO deposito (id, dimension, capacidad_galones, abastecido_galones, tipo)
VALUES (1, '10x10x10', 5000, 3000, 'Diesel'),
       (2, '15x15x15', 10000, 5000, 'Gasolina');

INSERT INTO proveedor (placa_camion, nro_licencia)
VALUES ('ABC123', 'P123456'), ('DEF456', 'P654321');

INSERT INTO personal_natural (nro_documento, nombre, apellido, fecha_nacimiento, email, ciudad, edad, nro_celular)
VALUES ('12345678', 'Juan', 'Perez', '1980-01-01', 'juan.perez@example.com', 'Lima', 43, '912345678'),
       ('87654321', 'Maria', 'Gomez', '1985-05-15', 'maria.gomez@example.com', 'Arequipa', 38, '987654321');

INSERT INTO cliente (nro_documento)
VALUES ('12345678'), ('87654321');

INSERT INTO despachador_combustible (nro_documento, sueldo)
VALUES ('12345678', 1025), ('87654321', 1025);

INSERT INTO surtidor_combustible (nroserie, lado, marca, id)
VALUES ('S123', 'A', 'XYZ', 1), ('S456', 'B', 'XYZ', 2);


INSERT INTO venta (fecha, monto_total, cantidad_galones, precio_unitario, nroserie, lado, nro_documento_Despachador, nro_documento_Cliente)
VALUES (current_date, 500.00, 100, 5.00, 'S123', 'A', '12345678', '12345678'),
       (current_date, 750.00, 150, 5.00, 'S123', 'A', '12345678', '87654321'),
       (current_date, 500.00, 100, 5.00, 'S456', 'B', '87654321', '12345678'),
       (current_date, 750.00, 150, 5.00, 'S456', 'B', '87654321', '87654321');

INSERT INTO abastecimiento (nro, fecha, cantidad_galones, precio, id, nro_licencia, placa_camion, hora)
VALUES (1, current_date, 1000, 3.00, 1, 'P123456', 'ABC123', '23:30:00'),
       (2, current_date, 2000, 3.00, 2, 'P654321', 'DEF456', '23:45:00');


-- Acapite e: Crear tres usuarios que tengan acceso a lectura o escritura

CREATE USER usr_Roger1 WITH password 'holabola';
GRANT USAGE ON schema petrogas7 TO user1;
GRANT SELECT ON venta TO user1;

CREATE USER usr_Melisa2 WITH password 'rogerChinchose';
GRANT SELECT, UPDATE, INSERT, DELETE ON venta TO user2;

CREATE USER usr_Diana3 WITH password 'arturite';
CREATE USER usr_Rodrigo WITH password 'milito';

-- Acapite f
ALTER TABLE venta ADD COLUMN igv FLOAT GENERATED ALWAYS AS (monto_total * 0.18) STORED;


create table logged_actions (
    schema_name text not null,
    table_name text not null,
    user_name text,
    action_tstamp timestamp with time zone not null default current_timestamp,
    action TEXT NOT NULL check (action in ('I','D','U')),
    original_data text,
    new_data text,
    query text
) ;

CREATE OR REPLACE FUNCTION func_auditoria() RETURNS trigger AS $body$
DECLARE
    v_old_data TEXT;
    v_new_data TEXT;
BEGIN

    if (TG_OP = 'UPDATE') then
        v_old_data := ROW(OLD.*);
        v_new_data := ROW(NEW.*);
        insert into logged_actions (schema_name,table_name,user_name,action,original_data,new_data,query)
        values (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query());
        RETURN NEW;
    elsif (TG_OP = 'DELETE') then
        v_old_data := ROW(OLD.*);
        insert into logged_actions (schema_name,table_name,user_name,action,original_data,query)
        values (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query());
        RETURN OLD;
    elsif (TG_OP = 'INSERT') then
        v_new_data := ROW(NEW.*);
        insert into logged_actions (schema_name,table_name,user_name,action,new_data,query)
        values (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query());
        RETURN NEW;
    else
        RAISE WARNING '[IF_MODIFIED_FUNC] - Other action occurred: %, at %',TG_OP,now();
        RETURN NULL;
    end if;

EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN others THEN
        RAISE WARNING '[IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql;

INSERT INTO venta VALUES (8,'000001', '4214154','S001','A',(SELECT now()),1,12,12);
delete from venta;
 SELECT * FROM logged_actions;

CREATE TRIGGER auditoria_venta
 AFTER INSERT OR UPDATE OR DELETE ON venta
 FOR EACH ROW EXECUTE PROCEDURE func_auditoria();

CREATE TABLE emp (
    empname           text PRIMARY KEY,
    salary            integer
);