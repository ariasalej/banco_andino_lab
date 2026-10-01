CREATE TABLE catalogo.tipo_documento (
    id_tipo_documento SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE catalogo.estado_cliente (
    id_estado_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE catalogo.tipo_producto (
    id_tipo_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE catalogo.estado_cuenta (
    id_estado_cuenta SERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE catalogo.tipo_transaccion (
    id_tipo_transaccion SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE catalogo.estado_transaccion (
    id_estado_transaccion SERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE
);

"""
INSERT INICIALES
"""

INSERT INTO catalogo.estado_cliente (nombre)
VALUES
('ACTIVO'),
('INACTIVO');

INSERT INTO catalogo.estado_cuenta (nombre)
VALUES
('ACTIVA'),
('BLOQUEADA'),
('CERRADA');

INSERT INTO catalogo.estado_transaccion (nombre)
VALUES
('PENDIENTE'),
('APROBADA'),
('RECHAZADA'),
('REVERSADA');