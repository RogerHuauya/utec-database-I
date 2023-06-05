set search_path = "estacion";

CREATE or replace function get_venta_per_month_year(p_month integer, p_year integer)
returns table(dia numeric, total double precision, cantida double precision)
as
    $$
        begin return query
            select  extract(day from fecha) as dia,
                    sum(cantidad*venta.preciounitario) as total,
                    sum(cantidad) as cantida
                    from venta
                    where extract(month from fecha) = p_month and
                          extract(year from fecha) = p_year
            group by dia;
        end;
    $$ language plpgsql;

SELECT * FROM get_venta_per_month_year(5, 2023);


create or replace function update_stock() returns trigger
as $$
    BEGIN
        if exists(
            select id from surtidor S inner join deposito D
            on S.depositoid = D.id
            where S.nroserie = new.nroserie and
                S.lado = new.lado
        )
        then
            UPDATE deposito
            SET abastecido = abastecido - new.cantidad
            where id = (
                select id from surtidor S inner join deposito D
                on S.depositoid = D.id
                where S.nroserie = new.nroserie and
                    S.lado = new.lado
                );
        end if;
        return new;
    end;
$$ LANGUAGE plpgsql;


create trigger t_update_stock
    after insert on venta
    for each row execute procedure update_stock();

INSERT INTO venta VALUES (11,'000001', '4214154','S001','A', '01/02/2023', 10, 12, 120);



create or replace function update_stock_abastecido() returns trigger
as $$
    BEGIN
        UPDATE deposito
        SET abastecido = abastecido + new.cantidad
        where id = new.depositoid;
        return new;
    end;
$$ LANGUAGE plpgsql;

create trigger t_update_stock_abastecido
    after insert on abastecimiento
    for each row execute procedure update_stock_abastecido();

INSERT INTO abastecimiento VALUES (8,(SELECT now()),'1','ABC123','12345678',100, 12);


create or replace procedure sp_i_venta(
	p_nrodocumentocli VARCHAR(8),
	p_nrodocumentodes VARCHAR(8),
	p_nroserie VARCHAR(12),
	p_lado VARCHAR(1),
	p_cantidad DOUBLE PRECISION,
	p_preciounitario DOUBLE PRECISION,
	p_montototal DOUBLE PRECISION
)
language plpgsql as
$$
declare v_nro bigint;
BEGIN
    v_nro := (select max(nro) from venta) + 1;
    insert into venta(nro, nrodocumentocli, nrodocumentodes, nroserie, lado, fecha, cantidad, preciounitario, montototal)
    values (v_nro, p_nrodocumentocli, p_nrodocumentodes, p_nroserie, p_lado, (select now()), p_cantidad, p_preciounitario, p_montototal);
end;
    $$;


call sp_i_venta('000001', '4214154','S001','A', 10, 12, 120);