CREATE TABLE clientes.cliente (
    id_cliente BIGSERIAL PRIMARY KEY,

    id_tipo_documento INTEGER NOT NULL,
    numero_documento VARCHAR(30) NOT NULL UNIQUE,

    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,

    fecha_nacimiento DATE,

    id_ciudad INTEGER,

    correo VARCHAR(150),
    telefono VARCHAR(30),

    id_estado_cliente INTEGER NOT NULL,

    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_cliente_tipo_documento
        FOREIGN KEY (id_tipo_documento)
        REFERENCES catalogo.tipo_documento(id_tipo_documento),

    CONSTRAINT fk_cliente_ciudad
        FOREIGN KEY (id_ciudad)
        REFERENCES geografia.ciudad(id_ciudad),

    CONSTRAINT fk_cliente_estado
        FOREIGN KEY (id_estado_cliente)
        REFERENCES catalogo.estado_cliente(id_estado_cliente)
);