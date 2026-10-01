ALTER TABLE cuentas.cuenta
ADD CONSTRAINT chk_fecha_cierre
CHECK (
    fecha_cierre IS NULL
    OR fecha_cierre >= fecha_apertura
);

ALTER TABLE transacciones.transaccion
ADD CONSTRAINT chk_no_autotransferencia
CHECK (
    cuenta_origen IS NULL
    OR cuenta_destino IS NULL
    OR cuenta_origen <> cuenta_destino
);

ALTER TABLE clientes.cliente
ADD CONSTRAINT chk_fecha_nacimiento
CHECK (fecha_nacimiento <= CURRENT_DATE);