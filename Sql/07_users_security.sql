CREATE TABLE seguridad.usuario (
    id_usuario SERIAL PRIMARY KEY,

    nombre_usuario VARCHAR(100) NOT NULL UNIQUE,

    correo VARCHAR(150) NOT NULL UNIQUE,

    password_hash TEXT NOT NULL,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);