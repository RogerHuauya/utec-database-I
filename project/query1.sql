set work_mem  = '256MB';

SELECT p.nombre, p.apellido, r.fecha AS fecha_reservacion, r.costo_total + COALESCE(te.costo * sre.cantidad, 0) AS costo_total,
       a.nombre AS nombre_aeropuerto_origen, a2.nombre AS nombre_aeropuerto_destino
FROM
    (
        SELECT p.nro_documento, p.nombre, p.apellido
        FROM persona p
                 JOIN pasajero ps ON p.nro_documento = ps.nro_documento_persona
        WHERE p.nro_documento IN (
            SELECT sr.nro_documento_pasajero
            FROM sub_reservacion sr
                     JOIN pasajero ps ON sr.nro_documento_pasajero = ps.nro_documento_persona
            WHERE sr.codigo_reservacion IN (
                SELECT r.codigo
                FROM reservacion r
                         JOIN sub_reservacion sr ON r.codigo = sr.codigo_reservacion
            )
        )
    ) p
        JOIN sub_reservacion sr ON p.nro_documento = sr.nro_documento_pasajero
        JOIN reservacion r ON sr.codigo_reservacion = r.codigo
        LEFT JOIN sub_reserva_equipaje sre ON sr.sub_reservacion_id = sre.sub_reservacion_id_sub_reservacion
        LEFT JOIN tipo_equipaje te ON sre.codigo_tipo_tipo_equipaje = te.codigo_tipo
        JOIN pertenece pe ON sr.sub_reservacion_id = pe.sub_reservacion_id_sub_reservacion
        JOIN vuelo v ON pe.nro_vuelo_vuelo = v.nro_vuelo
        JOIN tripulante_asignado ta ON v.nro_vuelo = ta.nro_vuelo_vuelo
        JOIN tripulante t ON ta.nro_documento_persona_tripulante = t.nro_documento_persona
        JOIN aeropuerto a ON v.codigo_iata_aeropuerto_origen = a.codigo_iata
        JOIN aeropuerto a2 ON v.codigo_iata_aeropuerto_destino = a2.codigo_iata
WHERE t.nro_documento_persona IN (SELECT tripulante.nro_documento_persona FROM tripulante WHERE tripulante.cargo = 'Azafata')
  AND NOT EXISTS (
    SELECT 1
    FROM persona p2
             JOIN pasajero ps2 ON p2.nro_documento = ps2.nro_documento_persona
             JOIN sub_reservacion sr2 ON ps2.nro_documento_persona = sr2.nro_documento_pasajero
    WHERE p.nombre = p2.nombre AND p.apellido = p2.apellido
      AND (sr.sub_reservacion_id != sr2.sub_reservacion_id OR sr.codigo_reservacion != sr2.codigo_reservacion)
)
GROUP BY p.nombre, p.apellido, r.fecha, r.costo_total, te.costo, sre.cantidad, a.nombre, a2.nombre;