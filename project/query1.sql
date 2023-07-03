SELECT p.nombre,
       p.apellido,
       r.fecha                                              AS fecha_reservacion,
       r.costo_total + COALESCE(te.costo * sre.cantidad, 0) AS costo_total,
       a.nombre                                             AS nombre_aeropuerto_origen,
       a2.nombre                                            AS nombre_aeropuerto_destino
FROM condorito.persona p
         JOIN
     condorito.pasajero ps ON p.nro_documento = ps.nro_documento_persona
         JOIN
     condorito.sub_reservacion sr ON ps.nro_documento_persona = sr.nro_documento_pasajero
         JOIN
     condorito.reservacion r ON sr.codigo_reservacion = r.codigo AND r.fecha BETWEEN '2023-01-01' AND '2023-12-31'
         LEFT JOIN
     condorito.sub_reserva_equipaje sre ON sr.sub_reservacion_id = sre.sub_reservacion_id_sub_reservacion
         LEFT JOIN
     condorito.tipo_equipaje te ON sre.codigo_tipo_tipo_equipaje = te.codigo_tipo
         JOIN
     condorito.pertenece pe ON sr.sub_reservacion_id = pe.sub_reservacion_id_sub_reservacion
         JOIN
     condorito.vuelo v ON pe.nro_vuelo_vuelo = v.nro_vuelo
         JOIN
     condorito.tripulante_asignado ta ON v.nro_vuelo = ta.nro_vuelo_vuelo
         JOIN
     condorito.tripulante t ON ta.nro_documento_persona_tripulante = t.nro_documento_persona
         JOIN
     condorito.aeropuerto a ON v.codigo_iata_aeropuerto_origen = a.codigo_iata AND a.capacidad > 5000
         JOIN
     condorito.aeropuerto a2 ON v.codigo_iata_aeropuerto_destino = a2.codigo_iata AND a2.capacidad > 5000
WHERE t.nro_documento_persona IN (select tripulante.nro_documento_persona from tripulante where tripulante.cargo= 'Actor')
GROUP BY p.nombre,
         p.apellido,
         r.fecha,
         r.costo_total,
         te.costo,
         sre.cantidad,
         a.nombre,
         a2.nombre;


