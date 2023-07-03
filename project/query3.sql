SELECT
    avion_model,
    avg_salario_model,
    avg_salario_overall,
    ranking,
    CASE
        WHEN avg_salario_model > avg_salario_overall THEN 'Above average'
        ELSE 'Below average'
    END AS comparison_with_average
FROM (
    SELECT
        avion_model,
        avg_salario_model,
        avg_salario_overall,
        RANK() OVER (ORDER BY avg_salario_model DESC) as ranking
    FROM (
        SELECT
            av.modelo AS avion_model,
            AVG(tr.salario) OVER (PARTITION BY av.modelo) AS avg_salario_model,
            AVG(tr.salario) OVER () AS avg_salario_overall
        FROM
            condorito.avion av
        JOIN
            condorito.vuelo v ON v.nro_matricula_avion = av.nro_matricula
        JOIN
            condorito.tripulante_asignado ta ON ta.nro_vuelo_vuelo = v.nro_vuelo
        JOIN
            condorito.tripulante tr ON tr.nro_documento_persona = ta.nro_documento_persona_tripulante
        GROUP BY
            av.modelo,
            tr.salario
    ) AS derived_table
) AS main_query
WHERE ranking <= 10;