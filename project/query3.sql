set work_mem  = '256MB' ;

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
       v.fecha_salida,

       (SELECT COUNT(*)
        FROM sub_reserva_equipaje se
        WHERE se.sub_reservacion_id_sub_reservacion =
              s.sub_reservacion_id)                                         AS equipajes,

       r.costo_total                                   AS reservacion_costo

FROM sub_reservacion s

         JOIN pasajero paj
              ON paj.nro_documento_persona = s.nro_documento_pasajero
         JOIN pertenece pe
              ON s.sub_reservacion_id = pe.sub_reservacion_id_sub_reservacion
         JOIN vuelo v ON pe.nro_vuelo_vuelo = v.nro_vuelo
         JOIN reservacion r ON r.codigo = s.codigo_reservacion

WHERE v.fecha_salida BETWEEN '2023-01-12' AND '2025-01-12'
  AND EXISTS (SELECT 1
              FROM sub_reserva_equipaje se
              WHERE se.sub_reservacion_id_sub_reservacion =
                    s.sub_reservacion_id)
  AND (SELECT COUNT(*)
       FROM sub_reserva_equipaje se
       WHERE se.sub_reservacion_id_sub_reservacion = s.sub_reservacion_id) = 1
  AND r.costo_total > (SELECT AVG(costo_total) FROM reservacion)

ORDER BY r.costo_total DESC
LIMIT 50;


-- CREATE INDEX
CREATE INDEX subIdIndex ON sub_reserva_equipaje USING hash (sub_reservacion_id_sub_reservacion);
CREATE INDEX subReservacionIdIndex ON sub_reservacion USING hash (sub_reservacion_id) ;
CREATE INDEX vueloFsIndex ON vuelo USING  hash (fecha_salida) ;
CREATE INDEX pasajeroNrDocIndex ON pasajero USING hash (nro_documento_persona) ;
CREATE INDEX reservacionIndex ON reservacion USING  hash(codigo) ;
CREATE INDEX reservacionCostoIndex ON reservacion USING  hash(costo_total);




