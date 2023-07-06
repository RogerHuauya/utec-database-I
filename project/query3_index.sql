CREATE INDEX subIdIndex ON sub_reserva_equipaje USING hash (sub_reservacion_id_sub_reservacion);
CREATE INDEX subReservacionIdIndex ON sub_reservacion USING hash (sub_reservacion_id) ;
CREATE INDEX vueloFsIndex ON vuelo USING  hash (fecha_salida) ;
CREATE INDEX pasajeroNrDocIndex ON pasajero USING hash (nro_documento_persona) ;