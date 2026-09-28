-- ==========================================
-- Archivo: 12_indexes.sql
-- Propósito: Índices optimizados guiados por el workload OLTP
-- ==========================================

-- Búsquedas frecuentes de clientes por documento
CREATE INDEX idx_clientes_documento ON core.clientes(tipo_documento, numero_documento);

-- Búsqueda de cuentas por cliente
CREATE INDEX idx_titularidad_cliente ON core.titularidad(cliente_id);

-- Consultas transaccionales por cuenta e inmutabilidad
CREATE INDEX idx_transacciones_origen ON core.transacciones(cuenta_origen_id) WHERE cuenta_origen_id IS NOT NULL;
CREATE INDEX idx_transacciones_destino ON core.transacciones(cuenta_destino_id) WHERE cuenta_destino_id IS NOT NULL;
CREATE INDEX idx_ledger_cuenta_fecha ON core.ledger_movimientos(cuenta_id, created_at DESC);

-- Índice GIN para búsquedas sobre logs de auditoría
CREATE INDEX idx_audit_jsonb_nuevos ON audit.auditoria_logs USING gin (valores_nuevos);