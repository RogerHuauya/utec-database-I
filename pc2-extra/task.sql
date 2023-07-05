SELECT lib.nombre
FROM libro lib
WHERE lib.nombre IN (SELECT ed.nombre
                     FROM edicion ed
                     WHERE ed.isbn IN (SELECT detailpres.isbn
                                       FROM detalleprestamo detailpres
                                       WHERE detailpres.pnumero IN (SELECT pres.numero
                                                                    FROM prestamo pres
                                                                    WHERE pres.fprestamo >= '2018-01-01'
                                                                      AND pres.fprestamo <= '2023-12-31')
                                       GROUP BY detailpres.isbn
                                       HAVING COUNT(*) > 1))
  and lib.dni in (select dni from autor where especialidad = 'Base de datos');
