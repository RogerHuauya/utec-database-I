-- CREATE INDEX
CREATE INDEX avionNroMatriculaIndex ON avion USING hash (nro_matricula);
CREATE INDEX vueloNroMatriculaAvionIndex ON vuelo USING hash (nro_matricula_avion);
CREATE INDEX asientoDisponibleNroVueloVueloIndex ON asiento_disponible USING hash (nro_vuelo_vuelo);
CREATE INDEX perteneceIndex ON pertenece USING hash (nro_asiento_asiento_disponible, nro_vuelo_vuelo);
CREATE INDEX subReservacionIndex ON sub_reservacion USING hash (sub_reservacion_id);
CREATE INDEX reservacionCodigoIndex ON reservacion USING hash (codigo);
CREATE INDEX vueloFechaSalidaIndex ON vuelo USING btree (fecha_salida);
