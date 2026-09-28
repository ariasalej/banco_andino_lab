-- ==========================================
-- Archivo: 20_teardown.sql
-- Propósito: Limpieza y destrucción limpia del esquema
-- ==========================================

DROP SCHEMA IF EXISTS audit CASCADE;
DROP SCHEMA IF EXISTS security CASCADE;
DROP SCHEMA IF EXISTS core CASCADE;