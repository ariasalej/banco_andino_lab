CREATE OR REPLACE VIEW cuentas.vw_cuentas_clientes AS
SELECT
    c.id_cuenta,
    c.numero_cuenta,
    cl.id_cliente,
    cl.nombres,
    cl.apellidos,
    c.saldo
FROM cuentas.cuenta c
JOIN cuentas.cuenta_cliente cc
    ON cc.id_cuenta = c.id_cuenta
JOIN clientes.cliente cl
    ON cl.id_cliente = cc.id_cliente;

CREATE OR REPLACE VIEW transacciones.vw_resumen_transacciones AS
SELECT
    t.id_transaccion,
    t.fecha_transaccion,
    t.monto,
    tt.nombre AS tipo_transaccion,
    et.nombre AS estado
FROM transacciones.transaccion t
JOIN catalogo.tipo_transaccion tt
    ON tt.id_tipo_transaccion = t.id_tipo_transaccion
JOIN catalogo.estado_transaccion et
    ON et.id_estado_transaccion = t.id_estado_transaccion;