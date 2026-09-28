-- ==========================================
-- Archivo: 08_transactions.sql
-- Propósito: Encabezado de transacciones financieras
-- ==========================================

CREATE TABLE core.transacciones (
    transaccion_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idempotency_key VARCHAR(64) NOT NULL UNIQUE,
    cuenta_origen_id INT,
    cuenta_destino_id INT,
    tipo_transaccion VARCHAR(30) NOT NULL,
    monto NUMERIC(15, 2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'POSTED',
    descripcion VARCHAR(200),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_tx_cuenta_origen FOREIGN KEY (cuenta_origen_id) REFERENCES core.cuentas(cuenta_id) ON DELETE RESTRICT,
    CONSTRAINT fk_tx_cuenta_destino FOREIGN KEY (cuenta_destino_id) REFERENCES core.cuentas(cuenta_id) ON DELETE RESTRICT,
    CONSTRAINT fk_tx_tipo FOREIGN KEY (tipo_transaccion) REFERENCES core.cat_tipos_transaccion(tipo) ON DELETE RESTRICT,
    CONSTRAINT chk_tx_monto CHECK (monto > 0),
    CONSTRAINT chk_tx_cuentas CHECK (cuenta_origen_id IS NOT NULL OR cuenta_destino_id IS NOT NULL),
    CONSTRAINT chk_tx_origen_destino CHECK (cuenta_origen_id IS NULL OR cuenta_destino_id IS NULL OR cuenta_origen_id <> cuenta_destino_id)
);

COMMENT ON TABLE core.transacciones IS 'Registro inmutable de transacciones financieras ejecutadas';