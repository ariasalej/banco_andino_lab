"EXISTENCIA DE CLIENTES"
SELECT COUNT(*)
FROM clientes.cliente;

"EXISTENCIA DE CUENTAS"
SELECT COUNT(*)
FROM cuentas.cuenta;

"CUENTAS CON SALGO NEGATIVO"
SELECT *
FROM cuentas.cuenta
WHERE saldo < 0;

"AUTOTRANSFERENCIAS"
SELECT *
FROM transacciones.transaccion
WHERE cuenta_origen = cuenta_destino;

"PARTIDA DOBLE"
SELECT
    id_transaccion,
    SUM(
        CASE
            WHEN tipo_movimiento = 'D' THEN monto
            WHEN tipo_movimiento = 'C' THEN -monto
        END
    ) AS diferencia
FROM contabilidad.movimiento_contable
GROUP BY id_transaccion
HAVING SUM(
    CASE
        WHEN tipo_movimiento = 'D' THEN monto
        WHEN tipo_movimiento = 'C' THEN -monto
    END
) <> 0;

"PRUEBA DE SALDO"
SELECT *
FROM cuentas.cuenta
WHERE saldo < 0;

"PRUEBA DE TRANSACCIONES MODIFICADAS"
UPDATE transacciones.transaccion
SET monto = 999999
WHERE id_transaccion = 1;