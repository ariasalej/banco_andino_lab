-- ==========================================
-- Archivo: 11_constraints.sql
-- Propósito: Reglas avanzadas de integridad transaccional
-- ==========================================

-- Asegura que una cuenta con saldo disponible positivo no pueda cerrarse directamente
ALTER TABLE core.cuentas
    ADD CONSTRAINT chk_cierre_saldo_cero 
    CHECK (estado <> 'CERRADA' OR (saldo_contable = 0 AND saldo_disponible = 0));