from flask import render_template
from sqlalchemy import text
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

import os

BASE_DIR = os.path.abspath(os.path.dirname(__file__))


class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'your-secret-key'
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'postgresql://aerocondor:o&KVJO6svPDqx8&47HaZ9y76@34.30.32.93:5432/' \
        'aerocondor'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    POSTS_PER_PAGE = 10


config = Config()


application = Flask(__name__)
application.config.from_object(config)

db = SQLAlchemy(application)

def query1(schema='condorito_1k'):
    return f"""
set search_path = {schema};
SELECT p.nombre,
       p.apellido,
       r.fecha                                              AS fecha_reservacion,
       r.costo_total + COALESCE(te.costo * sre.cantidad, 0) AS costo_total,
       a.nombre                                             AS nombre_aeropuerto_origen,
       a2.nombre                                            AS nombre_aeropuerto_destino
FROM persona p
         JOIN
     pasajero ps ON p.nro_documento = ps.nro_documento_persona
         JOIN
     sub_reservacion sr ON ps.nro_documento_persona = sr.nro_documento_pasajero
         JOIN
     reservacion r ON sr.codigo_reservacion = r.codigo AND r.fecha BETWEEN '2019-01-01' AND '2024-12-31'
         LEFT JOIN
     sub_reserva_equipaje sre ON sr.sub_reservacion_id = sre.sub_reservacion_id_sub_reservacion
         LEFT JOIN
     tipo_equipaje te ON sre.codigo_tipo_tipo_equipaje = te.codigo_tipo
         JOIN
     pertenece pe ON sr.sub_reservacion_id = pe.sub_reservacion_id_sub_reservacion
         JOIN
     vuelo v ON pe.nro_vuelo_vuelo = v.nro_vuelo
         JOIN
     tripulante_asignado ta ON v.nro_vuelo = ta.nro_vuelo_vuelo
         JOIN
     tripulante t ON ta.nro_documento_persona_tripulante = t.nro_documento_persona
         JOIN
     aeropuerto a ON v.codigo_iata_aeropuerto_origen = a.codigo_iata AND a.capacidad > 4000
         JOIN
     aeropuerto a2 ON v.codigo_iata_aeropuerto_destino = a2.codigo_iata AND a2.capacidad > 4000
WHERE t.nro_documento_persona IN (select tripulante.nro_documento_persona
                                  from tripulante where tripulante.cargo= 'Azafata')
GROUP BY p.nombre,
         p.apellido,
         r.fecha,
         r.costo_total,
         te.costo,
         sre.cantidad,
         a.nombre,
         a2.nombre
LIMIT  50;
"""


def query2(schema='condorito_1k'):
    return f"""
set search_path = {schema};
SELECT
    avion_matricula,
    passenger_count_avion,
    total_revenue,
    first_flight_date,
    last_flight_date,
    ranking
FROM (
    SELECT
        av.nro_matricula AS avion_matricula,
        COUNT(DISTINCT sr.nro_documento_pasajero) AS passenger_count_avion,
        SUM(r.costo_total) AS total_revenue,
        MIN(v.fecha_salida) AS first_flight_date,
        MAX(v.fecha_salida) AS last_flight_date,
        RANK() OVER (ORDER BY COUNT(DISTINCT sr.nro_documento_pasajero) DESC) as ranking
    FROM
        avion av
    JOIN
        vuelo v ON v.nro_matricula_avion = av.nro_matricula
    JOIN
        asiento_disponible ad ON ad.nro_vuelo_vuelo = v.nro_vuelo
    JOIN
        pertenece p ON p.nro_asiento_asiento_disponible = ad.nro_asiento
                           AND p.nro_vuelo_vuelo = ad.nro_vuelo_vuelo
    JOIN
        sub_reservacion sr ON sr.sub_reservacion_id = p.sub_reservacion_id_sub_reservacion
    JOIN
        reservacion r ON r.codigo = sr.codigo_reservacion
    WHERE
        v.fecha_salida BETWEEN '2023-01-12' AND '2024-01-12'
    GROUP BY
        av.nro_matricula
) AS main_query
WHERE ranking <= 5;
    """


def query3(schema='condorito_1k'):
    return f"""
set search_path = {schema};
SELECT
    (SELECT CONCAT(p.nombre, ' ', p.apellido)
     FROM persona p
     JOIN pasajero paj ON paj.nro_documento_persona = p.nro_documento
     WHERE nro_documento_persona = s.nro_documento_pasajero) AS nombre,

    (SELECT p.nro_documento
     FROM persona p
     JOIN pasajero paj ON paj.nro_documento_persona = p.nro_documento
     WHERE nro_documento_persona = s.nro_documento_pasajero) AS nro_Documento,

    r.codigo AS nro_reservacion,
    v.fecha_salida,

    (SELECT COUNT(*)
     FROM sub_reserva_equipaje se
     WHERE se.sub_reservacion_id_sub_reservacion = s.sub_reservacion_id) AS equipajes,

    r.costo_total AS reservacion_costo

FROM sub_reservacion s
JOIN pasajero paj ON paj.nro_documento_persona = s.nro_documento_pasajero
JOIN pertenece pe ON s.sub_reservacion_id = pe.sub_reservacion_id_sub_reservacion
JOIN vuelo v ON pe.nro_vuelo_vuelo = v.nro_vuelo
JOIN reservacion r ON r.codigo = s.codigo_reservacion

WHERE v.fecha_salida BETWEEN '2023-01-12' AND '2025-01-12'
  AND EXISTS (
      SELECT 1
      FROM sub_reserva_equipaje se
      WHERE se.sub_reservacion_id_sub_reservacion = s.sub_reservacion_id
  )
  AND (
      SELECT COUNT(*)
      FROM sub_reserva_equipaje se
      WHERE se.sub_reservacion_id_sub_reservacion = s.sub_reservacion_id
  ) = 1
  AND r.costo_total > (
      SELECT AVG(costo_total)
      FROM reservacion
  )

ORDER BY r.costo_total DESC
LIMIT 50;
    """


def query_table(query):
    query = text(query)
    with db.engine.connect() as connection:
        result_set = connection.execute(query)  # Put your SQL query here
        columns = result_set.keys()
        result = [{column: value for column, value in zip(columns, row)} for row in result_set]
    return render_template('query_table.html', result=result, columns=columns)


@application.route('/')
def index():
    return render_template('index.html', query1=query1(), query2=query2(),
                           query3=query3())



@application.route('/query1/<schema>')
def query1_view(schema):
    query = query1(schema)
    return query_table(query)


@application.route('/query2/<schema>')
def query2_view(schema):
    query = query2(schema)
    return query_table(query)

@application.route('/query3/<schema>')
def query3_view(schema):
    query = query3(schema)
    return query_table(query)


if __name__ == "__main__":
    application.run(debug=True)
