-- ==========================================
-- Archivo: 05_products.sql
-- Propósito: Definición de productos financieros
-- ==========================================

CREATE TABLE core.productos (
    producto_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_producto VARCHAR(20) NOT NULL UNIQUE,
    nombre_producto VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO core.productos (codigo_producto, nombre_producto, descripcion) VALUES
('AHORROS', 'Cuenta de Ahorros Tradicional', 'Cuenta para personas naturales con tasa de interés'),
('CORRIENTE', 'Cuenta Corriente', 'Cuenta transaccional con opción de cupo de sobregiro'),
('NOMINA', 'Cuenta de Nómina', 'Cuenta con beneficios para empleados vinculados'),
('EMPRESARIAL', 'Cuenta Corporativa', 'Cuenta de alto volumen para personas jurídicas');

COMMENT ON TABLE core.productos IS 'Catálogo de productos financieros ofrecidos por Banco Andino';