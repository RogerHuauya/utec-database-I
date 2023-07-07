drop index vueloFechaSalidaIndex ;
drop index reservacionCostoIndex ;
drop index subreservaEquipaje ;
drop index subresevacionNroDocumento ;
drop index subreservacionCodigoReservacion ;
drop index pertencesubReservacionIndex ;
drop index pertenceVueloiIndex ;



CREATE INDEX vueloFechaSalidaIndex ON vuelo USING  btree (fecha_salida) ;
CREATE INDEX reservacionCostoIndex ON reservacion USING  btree(costo_total);
CREATE INDEX subreservaEquipaje ON sub_reserva_equipaje USING hash (sub_reservacion_id_sub_reservacion);
CREATE INDEX subresevacionNroDocumento ON sub_reservacion USING hash (nro_documento_pasajero);
CREATE INDEX subreservacionCodigoReservacion ON sub_reservacion USING hash (codigo_reservacion);
CREATE INDEX pertencesubReservacionIndex ON pertenece USING hash (sub_reservacion_id_sub_reservacion) ;
CREATE INDEX pertenceVueloiIndex ON pertenece USING hash (nro_vuelo_vuelo) ;

--esteasds