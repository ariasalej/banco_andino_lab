CREATE INDEX idx_cliente_documento
ON clientes.cliente(numero_documento);

-------------------------

CREATE INDEX idx_cuenta_producto
ON cuentas.cuenta(id_producto);

-------------------------

CREATE INDEX idx_cuenta_estado
ON cuentas.cuenta(id_estado_cuenta);

--------------------------

CREATE INDEX idx_transaccion_fecha
ON transacciones.transaccion(fecha_transaccion);

---------------------------

CREATE INDEX idx_transaccion_origen
ON transacciones.transaccion(cuenta_origen);

---------------------------

CREATE INDEX idx_transaccion_destino
ON transacciones.transaccion(cuenta_destino);

----------------------------

CREATE INDEX idx_movimiento_transaccion
ON contabilidad.movimiento_contable(id_transaccion);

CREATE INDEX idx_movimiento_cuenta
ON contabilidad.movimiento_contable(id_cuenta);