-- Muestra el numero de tuplas de cada tabla en un esquema dado
SELECT
    schemaname AS table_schema,
    relname AS table_name,
    n_live_tup AS row_count
FROM
    pg_stat_user_tables
WHERE
    schemaname = 'condorito';


-- Genera datos de prueba para la tabla pertenece
DO $$
DECLARE
    cur_asiento CURSOR FOR SELECT nro_asiento, nro_vuelo_vuelo FROM asiento_disponible;
    cur_subreservacion CURSOR FOR SELECT sub_reservacion_id FROM sub_reservacion;
    asiento_rec RECORD;
    subreservacion_rec RECORD;
    counter INTEGER := 0;
BEGIN
    OPEN cur_asiento;
    OPEN cur_subreservacion;

    LOOP
        FETCH cur_asiento INTO asiento_rec;
        FETCH cur_subreservacion INTO subreservacion_rec;
        EXIT WHEN NOT FOUND;

        INSERT INTO pertenece (nro_asiento_asiento_disponible, nro_vuelo_vuelo, sub_reservacion_id_sub_reservacion)
        VALUES (asiento_rec.nro_asiento, asiento_rec.nro_vuelo_vuelo, subreservacion_rec.sub_reservacion_id);

        counter := counter + 1;
        IF counter >= 10000000 THEN
            EXIT;
        END IF;
    END LOOP;

    CLOSE cur_asiento;
    CLOSE cur_subreservacion;
END $$;
