-- ==========================================
-- Archivo: 16_triggers.sql
-- Propósito: Garantizar inmutabilidad de transacciones y auditoría
-- ==========================================

-- Trigger de Inmutabilidad sobre transacciones en estado POSTED
CREATE OR REPLACE FUNCTION core.fn_prevenir_modificacion_transaccion()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.estado = 'POSTED' THEN
        RAISE EXCEPTION 'Violación de Inmutabilidad: Las transacciones contabilizadas (POSTED) no se pueden alterar ni eliminar. Realice un reverso.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inmutabilidad_transacciones
BEFORE UPDATE OR DELETE ON core.transacciones
FOR EACH ROW
EXECUTE FUNCTION core.fn_prevenir_modificacion_transaccion();

-- Trigger de Auditoría Automática para Cuentas
CREATE OR REPLACE FUNCTION audit.fn_auditar_cuentas()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO audit.auditoria_logs (tabla_afectada, operacion, registro_afectado_id, valores_anteriores, valores_nuevos)
        VALUES ('core.cuentas', 'UPDATE', OLD.cuenta_id, to_jsonb(OLD), to_jsonb(NEW));
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO audit.auditoria_logs (tabla_afectada, operacion, registro_afectado_id, valores_anteriores)
        VALUES ('core.cuentas', 'DELETE', OLD.cuenta_id, to_jsonb(OLD));
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditar_cuentas_cambios
AFTER UPDATE OR DELETE ON core.cuentas
FOR EACH ROW
EXECUTE FUNCTION audit.fn_auditar_cuentas();