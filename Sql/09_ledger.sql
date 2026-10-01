CREATE TABLE contabilidad.movimiento_contable (
    id_movimiento BIGSERIAL PRIMARY KEY,

    id_transaccion BIGINT NOT NULL,

    id_cuenta BIGINT NOT NULL,

    tipo_movimiento CHAR(1) NOT NULL,

    monto NUMERIC(18,2) NOT NULL,

    fecha_movimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_movimiento_transaccion
        FOREIGN KEY (id_transaccion)
        REFERENCES transacciones.transaccion(id_transaccion),

    CONSTRAINT fk_movimiento_cuenta
        FOREIGN KEY (id_cuenta)
        REFERENCES cuentas.cuenta(id_cuenta),

    CONSTRAINT chk_tipo_movimiento
        CHECK (tipo_movimiento IN ('D','C')),

    CONSTRAINT chk_monto_movimiento
        CHECK (monto > 0)
);