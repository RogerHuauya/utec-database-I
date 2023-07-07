CREATE INDEX vueloFechaSalidaIndex ON vuelo USING btree (fecha_salida);
CREATE INDEX vueloNroMatriculaAvionIndex ON vuelo USING hash (nro_matricula_avion);
CREATE INDEX asientoDisponibleNroVueloVueloIndex ON asiento_disponible USING hash (nro_vuelo_vuelo);
CREATE INDEX perteneceAsientoIndex ON pertenece USING hash (nro_asiento_asiento_disponible) ;
CREATE INDEX perteneceVueloIndex ON pertenece USING hash ( nro_vuelo_vuelo) ;
CREATE INDEX perteneceReservacionIndex ON pertenece USING hash (sub_reservacion_id_sub_reservacion);

--esasd