-- ==========================================
-- Archivo: 03_geography.sql
-- Propósito: Divisiones político-administrativas y sucursales
-- ==========================================

CREATE TABLE core.departamentos (
    departamento_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_dane VARCHAR(2) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT chk_dept_codigo_dane CHECK (codigo_dane ~ '^[0-9]{2}$')
);

CREATE TABLE core.municipios (
    municipio_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    departamento_id INT NOT NULL,
    codigo_dane VARCHAR(5) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT fk_municipio_departamento 
        FOREIGN KEY (departamento_id) 
        REFERENCES core.departamentos(departamento_id) 
        ON DELETE RESTRICT,
    CONSTRAINT chk_muni_codigo_dane CHECK (codigo_dane ~ '^[0-9]{5}$')
);

CREATE TABLE core.oficinas (
    oficina_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    municipio_id INT NOT NULL,
    codigo_oficina VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_oficina_municipio 
        FOREIGN KEY (municipio_id) 
        REFERENCES core.municipios(municipio_id) 
        ON DELETE RESTRICT
);

COMMENT ON TABLE core.departamentos IS 'Catálogo oficial de departamentos colombianos con código DANE (2 dígitos)';
COMMENT ON TABLE core.municipios IS 'Catálogo oficial de municipios con código DANE (5 dígitos)';
COMMENT ON TABLE core.oficinas IS 'Sucursales y oficinas operativas del Banco Andino Colombia';