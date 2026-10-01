CREATE TABLE transacciones.transaccion (
    id_transaccion BIGSERIAL PRIMARY KEY,

    id_tipo_transaccion INTEGER NOT NULL,

    cuenta_origen BIGINT,
    cuenta_destino BIGINT,

    monto NUMERIC(18,2) NOT NULL,

    id_estado_transaccion INTEGER NOT NULL,

    fecha_transaccion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    descripcion VARCHAR(250),

    id_usuario INTEGER,

    CONSTRAINT fk_transaccion_tipo
        FOREIGN KEY (id_tipo_transaccion)
        REFERENCES catalogo.tipo_transaccion(id_tipo_transaccion),

    CONSTRAINT fk_transaccion_estado
        FOREIGN KEY (id_estado_transaccion)
        REFERENCES catalogo.estado_transaccion(id_estado_transaccion),

    CONSTRAINT fk_transaccion_origen
        FOREIGN KEY (cuenta_origen)
        REFERENCES cuentas.cuenta(id_cuenta),

    CONSTRAINT fk_transaccion_destino
        FOREIGN KEY (cuenta_destino)
        REFERENCES cuentas.cuenta(id_cuenta),

    CONSTRAINT fk_transaccion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES seguridad.usuario(id_usuario),

    CONSTRAINT chk_monto_positivo
        CHECK (monto > 0)
);