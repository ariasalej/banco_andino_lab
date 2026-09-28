-- ==========================================
-- Archivo: 17_roles_permissions.sql
-- Propósito: Control de acceso RBAC y principio de mínimo privilegio
-- ==========================================

-- Definición de roles del sistema en PostgreSQL
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'rol_cajero') THEN
        CREATE ROLE rol_cajero;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'rol_auditor') THEN
        CREATE ROLE rol_auditor;
    END IF;
END $$;

-- Permisos para el Rol Cajero (Solo ejecutar procedimientos de operación)
GRANT USAGE ON SCHEMA core TO rol_cajero;
GRANT EXECUTE ON PROCEDURE core.sp_realizar_consignacion TO rol_cajero;
GRANT EXECUTE ON PROCEDURE core.sp_realizar_transferencia TO rol_cajero;
GRANT SELECT ON core.cuentas TO rol_cajero;

-- Permisos para el Rol Auditor (Solo lectura en auditoría y vistas)
GRANT USAGE ON SCHEMA core, audit TO rol_auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA audit TO rol_auditor;
GRANT SELECT ON core.v_auditoria_doble_partida TO rol_auditor;