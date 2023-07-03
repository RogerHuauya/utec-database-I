SELECT a.nombre                                 AS airport_name,
       v.fecha_salida                           AS flight_date,
       COUNT(DISTINCT ps.nro_documento_persona) AS number_of_passengers,
       AVG(r.costo_total)                       AS average_reservation_cost,
       AVG(sre.cantidad * te.costo)             AS average_baggage_cost
FROM condorito.aeropuerto a
         JOIN
     condorito.vuelo v ON a.codigo_iata = v.codigo_iata_aeropuerto_origen
         JOIN
     condorito.pertenece pe ON v.nro_vuelo = pe.nro_vuelo_vuelo
         JOIN
     condorito.sub_reservacion sr ON pe.sub_reservacion_id_sub_reservacion = sr.sub_reservacion_id
         JOIN
     condorito.reservacion r ON sr.codigo_reservacion = r.codigo
         JOIN
     condorito.pasajero ps ON sr.nro_documento_pasajero = ps.nro_documento_persona
         LEFT JOIN
     condorito.sub_reserva_equipaje sre ON sr.sub_reservacion_id = sre.sub_reservacion_id_sub_reservacion
         LEFT JOIN
     condorito.tipo_equipaje te ON sre.codigo_tipo_tipo_equipaje = te.codigo_tipo
WHERE a.capacidad > 10000
  AND v.fecha_salida BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY airport_name,
         flight_date
ORDER BY flight_date,
         airport_name;
