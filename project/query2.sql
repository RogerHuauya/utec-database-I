SELECT
    avion_matricula,
    passenger_count_avion,
    total_revenue,
    first_flight_date,
    last_flight_date,
    ranking
FROM (
    SELECT
        av.nro_matricula AS avion_matricula,
        COUNT(DISTINCT sr.nro_documento_pasajero) AS passenger_count_avion,
        SUM(r.costo_total) AS total_revenue,
        MIN(v.fecha_salida) AS first_flight_date,
        MAX(v.fecha_salida) AS last_flight_date,
        RANK() OVER (ORDER BY COUNT(DISTINCT sr.nro_documento_pasajero) DESC) as ranking
    FROM
        avion av
    JOIN
        vuelo v ON v.nro_matricula_avion = av.nro_matricula
    JOIN
        asiento_disponible ad ON ad.nro_vuelo_vuelo = v.nro_vuelo
    JOIN
        pertenece p ON p.nro_asiento_asiento_disponible = ad.nro_asiento
                           AND p.nro_vuelo_vuelo = ad.nro_vuelo_vuelo
    JOIN
        sub_reservacion sr ON sr.sub_reservacion_id = p.sub_reservacion_id_sub_reservacion
    JOIN
        reservacion r ON r.codigo = sr.codigo_reservacion
    WHERE
        v.fecha_salida BETWEEN '2023-01-12' AND '2024-01-12'
    GROUP BY
        av.nro_matricula
) AS main_query
WHERE ranking <= 5;
