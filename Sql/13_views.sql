-- ==========================================
-- Archivo: 13_views.sql
-- Propósito: Vistas de consulta y conciliación contable
-- ==========================================

CREATE OR REPLACE VIEW core.v_resumen_cuentas AS
SELECT 
    c.cuenta_id,
    c.numero_cuenta,
    p.nombre_producto,
    c.moneda,
    c.saldo_contable,
    c.saldo_disponible,
    c.estado,
    o.nombre AS oficina,
    m.nombre AS municipio
FROM core.cuentas c
JOIN core.productos p ON c.producto_id = p.producto_id
JOIN core.oficinas o ON c.oficina_id = o.oficina_id
JOIN core.municipios m ON o.municipio_id = m.municipio_id;

-- Vista para auditar la doble partida (Débitos vs Créditos por transacción)
CREATE OR REPLACE VIEW core.v_auditoria_doble_partida AS
SELECT 
    transaccion_id,
    SUM(CASE WHEN tipo_movimiento = 'DEBITO' THEN monto ELSE 0 END) AS total_debito,
    SUM(CASE WHEN tipo_movimiento = 'CREDITO' THEN monto ELSE 0 END) AS total_credito,
    (SUM(CASE WHEN tipo_movimiento = 'DEBITO' THEN monto ELSE 0 END) - 
     SUM(CASE WHEN tipo_movimiento = 'CREDITO' THEN monto ELSE 0 END)) AS diferencia
FROM core.ledger_movimientos
GROUP BY transaccion_id;