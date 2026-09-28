-- ==========================================
-- Archivo: 00_extensions.sql
-- Propósito: Habilitación de extensiones necesarias
-- ==========================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

COMMENT ON EXTENSION pgcrypto IS 'Funciones criptográficas para hashing y generación de UUIDs';