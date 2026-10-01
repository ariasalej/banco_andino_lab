CREATE TABLE cuentas.producto (
    id_producto SERIAL PRIMARY KEY,

    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,

    id_tipo_producto INTEGER NOT NULL,

    tasa_interes NUMERIC(10,4) DEFAULT 0,
    cuota_manejo NUMERIC(15,2) DEFAULT 0,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_producto_tipo
        FOREIGN KEY (id_tipo_producto)
        REFERENCES catalogo.tipo_producto(id_tipo_producto),

    CONSTRAINT chk_tasa_interes
        CHECK (tasa_interes >= 0),

    CONSTRAINT chk_cuota_manejo
        CHECK (cuota_manejo >= 0)
);