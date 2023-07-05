-- Muestra el numero de tuplas de cada tabla en un esquema dado
SELECT
    schemaname AS table_schema,
    relname AS table_name,
    n_live_tup AS row_count
FROM
    pg_stat_user_tables
WHERE
    schemaname = 'condorito';

-- Generar vuelos

DO
$do$
DECLARE
  aeropuerto_origen  VARCHAR(15);
  aeropuerto_destino VARCHAR(15);
  avion_matricula VARCHAR(15);
BEGIN
  FOR i IN 1..4000 LOOP
    -- Obteniendo un aeropuerto de origen aleatorio
    SELECT codigo_iata INTO aeropuerto_origen
    FROM aeropuerto
    ORDER BY random()
    LIMIT 1;

    -- Obteniendo un aeropuerto de destino aleatorio que sea diferente del origen
    SELECT codigo_iata INTO aeropuerto_destino
    FROM aeropuerto
    WHERE codigo_iata <> aeropuerto_origen
    ORDER BY random()
    LIMIT 1;

    -- Obteniendo un avión aleatorio
    SELECT nro_matricula INTO avion_matricula
    FROM avion
    ORDER BY random()
    LIMIT 1;

    -- Insertando el registro de vuelo con datos aleatorios
    INSERT INTO vuelo (fecha_salida, fecha_llegada, nro_vuelo, codigo_iata_aeropuerto_origen, codigo_iata_aeropuerto_destino, nro_matricula_avion)
    VALUES (
      current_date + (random() * (365*3))::integer,  -- Fecha aleatoria en los próximos 3 años
      current_date + (random() * (365*3 + 1))::integer,  -- Fecha de llegada aleatoria posterior a la fecha de salida
      'VUELO' || LPAD(i::text, 5, '0'),  -- Generación de un número de vuelo secuencial
      aeropuerto_origen,
      aeropuerto_destino,
      avion_matricula
    );
  END LOOP;
END
$do$;

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
        IF counter >= 96000 THEN
            EXIT;
        END IF;
    END LOOP;

    CLOSE cur_asiento;
    CLOSE cur_subreservacion;
END $$;


-- Subreserva equipaje

DO $$
DECLARE
    subreservacion_rec RECORD;
    equipaje_rec RECORD;
    equipaje_array text[];
    cantidad INTEGER;
    n_equipaje INTEGER;
BEGIN
    -- Create an array of all tipo_equipaje codes
    SELECT INTO equipaje_array array_agg(codigo_tipo)
    FROM tipo_equipaje;

    -- Loop over each record from the sub_reservacion table
    FOR subreservacion_rec IN (SELECT sub_reservacion_id FROM sub_reservacion)
    LOOP
        -- Shuffle the equipaje_array
        equipaje_array := ARRAY(SELECT unnest(equipaje_array) ORDER BY random());

        -- Decide if 1 or 2 luggage types will be assigned
        n_equipaje := 1 + floor(random() * 2)::INT;

        -- Loop over the first n_equipaje elements of equipaje_array
        FOR i IN 1..n_equipaje
        LOOP
            -- Select a luggage type from the array
            SELECT INTO equipaje_rec *
            FROM tipo_equipaje
            WHERE codigo_tipo = equipaje_array[i];

            -- Select a random quantity (1 to 3)
            cantidad := 1 + floor(random() * 3)::INT;

            -- Insert the record into the sub_reserva_equipaje table
            INSERT INTO sub_reserva_equipaje (codigo_tipo_tipo_equipaje, cantidad, sub_reservacion_id_sub_reservacion)
            VALUES (equipaje_rec.codigo_tipo, cantidad, subreservacion_rec.sub_reservacion_id);
        END LOOP;
    END LOOP;
END $$;


WITH seat_letters AS (
    SELECT unnest(ARRAY['A', 'B', 'C', 'D', 'E', 'F']) AS seat_letter
),
seat_numbers AS (
    SELECT LPAD(generate_series::text, 2, '0') AS seat_number
    FROM generate_series(1, 50)
),
all_seats AS (
    SELECT seat_letter || seat_number AS seat
    FROM seat_letters, seat_numbers
),
all_flights AS (
    SELECT nro_vuelo FROM vuelo
)
INSERT INTO asiento_disponible (nro_asiento, nro_vuelo_vuelo)
SELECT seat, nro_vuelo
FROM all_seats CROSS JOIN all_flights;



-- Tripulante asignado
DO $$
DECLARE
    vuelo_rec RECORD;
    tripulante_id varchar(15);
    tripulante_count INTEGER;
    tripulante_offset INTEGER;
BEGIN
    SELECT count(*) INTO tripulante_count FROM tripulante;

    -- Loop through each vuelo
    FOR vuelo_rec IN SELECT * FROM vuelo
    LOOP
        -- Assign 38 tripulantes to each vuelo
        tripulante_offset := random() * (tripulante_count - 38)::INTEGER;
        FOR i IN 1..38 LOOP
            BEGIN
                -- Get tripulante_id randomly
                SELECT nro_documento_persona INTO tripulante_id FROM tripulante OFFSET floor(tripulante_offset + i) LIMIT 1;

                -- Insert the record into the tripulante_asignado table
                INSERT INTO tripulante_asignado (nro_documento_persona_tripulante, nro_vuelo_vuelo)
                VALUES (tripulante_id, vuelo_rec.nro_vuelo);
            END;
        END LOOP;
    END LOOP;
END $$;
