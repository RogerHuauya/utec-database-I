create schema estacion;

set search_path to estacion;

create table cliente(
    dni varchar(8),
    nombre varchar(50),
    apellido varchar(50)
);

create table suministro(
    nro_suministro varchar(10),
    tarifa decimal,
    medidor varchar(10),
    potencia decimal,
    conexion varchar(10),
    nivel_tension varchar(10),
    cliente_dni varchar(8)
);


create table recibo(
    nro_recibo varchar(10),
    mes varchar(10),
    anio varchar(10),
    fecha_vencimiento date,
    fecha_emision date,
    lectura_anterior decimal,
    lectura_actual decimal,
    diferencia decimal,
    factor varchar(10),
    codigo_barra varchar(10),
    consumo_facturar varchar(10),
    monto_total decimal,
    mensajes varchar(255),
    suministro_nro_suministro varchar(10)
);


create table cargo(
    nro_cargo varchar(255)
);


create table recibo_cargo(
    recibo_nro_recibo varchar(10),
    cargo_nro_cargo varchar(255),
    precio_unit decimal,
    importe decimal
);



alter table cliente add constraint pk_cliente primary key (dni);
alter table suministro add constraint pk_suministro primary key (nro_suministro);
alter table suministro add constraint fk_suministro_cliente foreign key (cliente_dni) references cliente(dni);
alter table recibo add constraint pk_recibo primary key (nro_recibo);
alter table recibo add constraint fk_recibo_suministro foreign key (suministro_nro_suministro) references suministro(nro_suministro);
alter table cargo add constraint pk_cargo primary key (nro_cargo);

alter table recibo_cargo add constraint fk_recibo_cargo_recibo foreign key (recibo_nro_recibo) references recibo(nro_recibo);
alter table recibo_cargo add constraint fk_recibo_cargo_cargo foreign key (cargo_nro_cargo) references cargo(nro_cargo);
alter table recibo_cargo add constraint pk_recibo_cargo primary key (recibo_nro_recibo, cargo_nro_cargo);


insert into cliente values ('12345678', 'Juan', 'Perez');
insert into cliente values ('87654321', 'Maria', 'Gomez');

insert into suministro values ('1234567890', 1.0, '1234567890', 1.0, '1', '1', '12345678');
insert into suministro values ('0987654321', 1.0, '0987654321', 1.0, '1', '1', '87654321');

insert into recibo values ('000001', 'Enero', '2019', '2019-01-31', '2019-01-01', 0.0, 100.0, 100.0, '1.0', '1234567890', '100.0', 160.0, 'mensaje', '1234567890');
insert into recibo values ('000002', 'Febrero', '2019', '2019-01-31', '2019-01-01', 0.0, 100.0, 100.0, '1.0', '1234567890', '100.0', 140.0, 'mensaje', '1234567890');
insert into recibo values ('000003', 'Enero', '2019', '2019-01-31', '2019-01-01', 0.0, 100.0, 100.0, '1.0', '0987654321', '100.0', 200.0, 'mensaje', '0987654321');
insert into recibo values ('000004', 'Febrero', '2019', '2019-01-31', '2019-01-01', 0.0, 100.0, 100.0, '1.0', '0987654321', '100.0', 50.0, 'mensaje', '0987654321');
insert into recibo values ('000005', 'Junio', '2023', '2019-01-31', '2019-01-01', 0.0, 100.0, 100.0, '1.0', '1234567890', '100.0', 150.0, 'mensaje', '1234567890');
insert into recibo values ('000006', 'Julio', '2023', '2019-01-31', '2019-01-01', 0.0, 100.0, 100.0, '1.0', '1234567890', '100.0', 150.0, 'mensaje', '1234567890');


insert into cargo values ('Cargo fijo');
insert into cargo values ('Mantenimiento');
insert into cargo values ('Cargo Preferencial');


insert into recibo_cargo values ('000001', 'Cargo fijo', 1.0, 10.0);
insert into recibo_cargo values ('000001', 'Mantenimiento', 2.0, 20.0);
insert into recibo_cargo values ('000002', 'Cargo fijo', 3.0, 30.0);
insert into recibo_cargo values ('000002', 'Mantenimiento', 4.0, 40.0);
insert into recibo_cargo values ('000002', 'Cargo Preferencial', 5.0, 50.0);

insert into recibo_cargo values ('000003', 'Cargo fijo', 1.0, 10.0);
insert into recibo_cargo values ('000003', 'Mantenimiento', 2.0, 20.0);
insert into recibo_cargo values ('000004', 'Cargo fijo', 3.0, 30.0);
insert into recibo_cargo values ('000004', 'Mantenimiento', 4.0, 40.0);
insert into recibo_cargo values ('000004', 'Cargo Preferencial', 5.0, 50.0);



select sum.nro_suministro, cli.nombre, rec.mes, rec.anio, rec.monto_total
from cliente cli
         join suministro sum on cli.dni = sum.cliente_dni
         join recibo rec
              on sum.nro_suministro = rec.suministro_nro_suministro
where rec.monto_total = 150.0
  and ((rec.mes = 'Junio' and rec.anio = '2023') or
       (rec.mes = 'Julio' and rec.anio = '2023'));
