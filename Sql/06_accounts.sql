CREATE TABLE cuentas.cuenta (
    id_cuenta BIGSERIAL PRIMARY KEY,

    numero_cuenta VARCHAR(30) NOT NULL UNIQUE,

    id_producto INTEGER NOT NULL,
    id_oficina INTEGER NOT NULL,

    saldo NUMERIC(18,2) NOT NULL DEFAULT 0,

    id_estado_cuenta INTEGER NOT NULL,

    fecha_apertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre TIMESTAMP,

    CONSTRAINT fk_cuenta_producto
        FOREIGN KEY (id_producto)
        REFERENCES cuentas.producto(id_producto),

    CONSTRAINT fk_cuenta_oficina
        FOREIGN KEY (id_oficina)
        REFERENCES geografia.oficina(id_oficina),

    CONSTRAINT fk_cuenta_estado
        FOREIGN KEY (id_estado_cuenta)
        REFERENCES catalogo.estado_cuenta(id_estado_cuenta),

    CONSTRAINT chk_saldo
        CHECK (saldo >= 0)
);

-------------

CREATE TABLE cuentas.cuenta_cliente (
    id_cuenta BIGINT NOT NULL,
    id_cliente BIGINT NOT NULL,

    fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_fin DATE,

    PRIMARY KEY (id_cuenta, id_cliente),

    FOREIGN KEY (id_cuenta)
        REFERENCES cuentas.cuenta(id_cuenta),

    FOREIGN KEY (id_cliente)
        REFERENCES clientes.cliente(id_cliente)
);