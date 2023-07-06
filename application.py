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


def query2(schema='condorito_1k'):
    return f"""
set search_path = '{schema}';
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
