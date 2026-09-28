-- ==========================================
-- Archivo: 09_ledger.sql
-- Propósito: Libro mayor contable de doble partida
-- ==========================================

CREATE TABLE core.ledger_movimientos (
    movimiento_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transaccion_id INT NOT NULL,
    cuenta_id INT NOT NULL,
    tipo_movimiento VARCHAR(10) NOT NULL,
    monto NUMERIC(15, 2) NOT NULL,
    saldo_resultante NUMERIC(15, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_ledger_transaccion FOREIGN KEY (transaccion_id) REFERENCES core.transacciones(transaccion_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ledger_cuenta FOREIGN KEY (cuenta_id) REFERENCES core.cuentas(cuenta_id) ON DELETE RESTRICT,
    CONSTRAINT chk_ledger_tipo CHECK (tipo_movimiento IN ('DEBITO', 'CREDITO')),
    CONSTRAINT chk_ledger_monto CHECK (monto > 0)
);

COMMENT ON TABLE core.ledger_movimientos IS 'Asientos contables individualizados por transacción (Doble Partida)';