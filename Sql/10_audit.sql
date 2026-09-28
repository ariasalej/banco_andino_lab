-- ==========================================
-- Archivo: 10_audit.sql
-- Propósito: Tabla inmutable de pistas de auditoría
-- ==========================================

CREATE TABLE audit.auditoria_logs (
    log_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_responsable VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
    tabla_afectada VARCHAR(50) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    registro_afectado_id INT,
    valores_anteriores JSONB,
    valores_nuevos JSONB,
    client_ip VARCHAR(45),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_audit_operacion CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE'))
);

COMMENT ON TABLE audit.auditoria_logs IS 'Registro centralizado e inmutable de operaciones sobre tablas críticas';