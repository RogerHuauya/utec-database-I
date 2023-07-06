-- CREATE INDEX query 1
CREATE INDEX personaNroDocumentoIndex ON persona USING hash (nro_documento);
CREATE INDEX pasajeroNroDocumentoPersonaIndex ON pasajero USING hash (nro_documento_persona);
CREATE INDEX subReservacionNroDocumentoPasajeroIndex ON sub_reservacion USING hash (nro_documento_pasajero);
CREATE INDEX reservacionCodigoFechaIndex ON reservacion USING btree (codigo, fecha);
CREATE INDEX subReservaEquipajeSubReservacionIdIndex ON sub_reserva_equipaje USING hash (sub_reservacion_id_sub_reservacion);
CREATE INDEX tipoEquipajeCodigoTipoIndex ON tipo_equipaje USING hash (codigo_tipo);
CREATE INDEX perteneceSubReservacionIdIndex ON pertenece USING hash (sub_reservacion_id_sub_reservacion);
CREATE INDEX vueloNroVueloIndex ON vuelo USING hash (nro_vuelo);
CREATE INDEX tripulanteAsignadoNroVueloVueloIndex ON tripulante_asignado USING hash (nro_vuelo_vuelo);
CREATE INDEX tripulanteNroDocumentoPersonaIndex ON tripulante USING hash (nro_documento_persona);
CREATE INDEX aeropuertoCodigoIataIndex ON aeropuerto USING hash (codigo_iata);
CREATE INDEX aeropuertoCapacidadIndex ON aeropuerto USING btree (capacidad);