SELECT (SELECT CONCAT(p.nombre, ' ', p.apellido)
        FROM persona p
                 JOIN pasajero paj
                      ON paj.nro_documento_persona = p.nro_documento
        WHERE nro_documento_persona = s.nro_documento_pasajero)             AS nombre,

       (SELECT p.nro_documento
        FROM persona p
                 JOIN pasajero paj
                      ON paj.nro_documento_persona = p.nro_documento
        WHERE nro_documento_persona =
              s.nro_documento_pasajero)                                     AS nro_Documento,

       r.codigo                                                             AS nro_reservacion,
       v.nro_vuelo                                                          As nro_vuelo,
       v.fecha_salida,
       v.fecha_llegada,

       (SELECT COUNT(*)
        FROM sub_reserva_equipaje se
        WHERE se.sub_reservacion_id_sub_reservacion =
              s.sub_reservacion_id)                                         AS equipajes,

       pe.nro_asiento_asiento_disponible                                    AS nro_asiento

FROM sub_reservacion s

         JOIN pasajero paj
              ON paj.nro_documento_persona = s.nro_documento_pasajero
         JOIN pertenece pe
              ON s.sub_reservacion_id = pe.sub_reservacion_id_sub_reservacion
         JOIN vuelo v ON pe.nro_vuelo_vuelo = v.nro_vuelo
         JOIN reservacion r ON r.codigo = s.codigo_reservacion

WHERE v.fecha_salida > current_date

  AND EXISTS (SELECT 1
              FROM sub_reserva_equipaje se
              WHERE se.sub_reservacion_id_sub_reservacion =
                    s.sub_reservacion_id)



-- Quiero saber el nombre y el numero de telefono de las personas que perdieron su vuelos
-- que salen de Cartagena hacia al aeropuerto 'Philippa' el 2023-02-01.



select nro_documento_pasajero
FROM (select sub_reservacion_id_sub_reservacion
      FROM (SELECT sub_reservacion_id_sub_reservacion,
                   pertenece.nro_vuelo_vuelo
            FROM pertenece
                     JOIN asiento_disponible
                          ON (pertenece.nro_asiento_asiento_disponible =
                              asiento_disponible.nro_asiento
                              AND pertenece.nro_vuelo_vuelo =
                                  asiento_disponible.nro_vuelo_vuelo)) tabla1
      where tabla1.nro_vuelo_vuelo IN (select nro_vuelo
                                       from vuelo
                                       where fecha_salida > '2023-01-01'
                                         AND codigo_iata_aeropuerto_destino IN
                                             (select codigo_iata
                                              from aeropuerto
                                              where nombre = 'Philippa')
                                         AND codigo_iata_aeropuerto_origen IN
                                             (select codigo_iata
                                              from aeropuerto
                                              where ubicacion = 'Cartagena'))) tabla2
         JOIN sub_reservacion
              ON sub_reservacion_id = sub_reservacion_id_sub_reservacion
where estado_check = FALSE