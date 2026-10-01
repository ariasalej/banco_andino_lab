CREATE TABLE auditoria.auditoria (
    id_auditoria BIGSERIAL PRIMARY KEY,

    tabla_afectada VARCHAR(100) NOT NULL,
    operacion VARCHAR(20) NOT NULL,

    id_registro BIGINT,

    usuario VARCHAR(100),

    fecha_evento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    datos_anteriores JSONB,
    datos_nuevos JSONB
);