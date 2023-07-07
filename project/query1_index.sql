-- CREATE INDEX query 1
CREATE INDEX subReservacionNroDocumentoPasajeroIndex ON sub_reservacion USING hash (nro_documento_pasajero); --ok
CREATE INDEX reservacionCodigoFechaIndex ON reservacion USING btree (fecha);
CREATE INDEX subReservaEquipajeSubReservacionIdIndex ON sub_reserva_equipaje USING hash (sub_reservacion_id_sub_reservacion);
CREATE INDEX perteneceSubReservacionIdIndex ON pertenece USING hash (sub_reservacion_id_sub_reservacion);
CREATE INDEX perteneceNroVueloIndex ON pertenece USING hash (nro_vuelo_vuelo);
CREATE INDEX tripulanteAsignadoNroVueloVueloIndex ON tripulante_asignado USING hash (nro_vuelo_vuelo);
CREATE INDEX aeropuertoCapacidadIndex ON aeropuerto USING btree (capacidad); --ok
CREATE INDEX tripulanteCargoIndex ON tripulante USING hash (cargo); --ok--estesss