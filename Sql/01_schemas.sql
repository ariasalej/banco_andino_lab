-- ==========================================
-- Archivo: 01_schemas.sql
-- Propósito: Creación de esquemas de organización
-- ==========================================

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS security;
CREATE SCHEMA IF NOT EXISTS audit;

COMMENT ON SCHEMA core IS 'Esquema principal para operaciones transaccionales y maestros de negocio';
COMMENT ON SCHEMA security IS 'Esquema para control de acceso RBAC y usuarios internos';
COMMENT ON SCHEMA audit IS 'Esquema reservado para el registro inmutable de trazabilidad y eventos';