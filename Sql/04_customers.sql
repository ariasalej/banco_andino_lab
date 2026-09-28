-- ==========================================
-- Archivo: 04_customers.sql
-- Propósito: Maestro de clientes (Persona Natural y Jurídica)
-- ==========================================

CREATE TABLE core.clientes (
    cliente_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo_persona VARCHAR(10) NOT NULL,
    tipo_documento VARCHAR(10) NOT NULL,
    numero_documento VARCHAR(20) NOT NULL,
    primer_nombre VARCHAR(50),
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50),
    segundo_apellido VARCHAR(50),
    razon_social VARCHAR(150),
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    municipio_id INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Restricción de unicidad compuesto por tipo y número de documento
    CONSTRAINT uk_cliente_documento UNIQUE (tipo_documento, numero_documento),
    
    -- Restricción de integridad referencial con municipio
    CONSTRAINT fk_cliente_municipio 
        FOREIGN KEY (municipio_id) 
        REFERENCES core.municipios(municipio_id) 
        ON DELETE RESTRICT,
        
    -- Restricción de integridad referencial con catálogo de estados
    CONSTRAINT fk_cliente_estado 
        FOREIGN KEY (estado) 
        REFERENCES core.cat_estados_cliente(estado) 
        ON DELETE RESTRICT,
        
    -- Validaciones de dominio de negocio
    CONSTRAINT chk_tipo_persona CHECK (tipo_persona IN ('NATURAL', 'JURIDICA')),
    CONSTRAINT chk_tipo_documento CHECK (
        tipo_documento IN ('CC', 'CE', 'NIT', 'PASAPORTE')
    ),
    CONSTRAINT chk_datos_persona CHECK (
        (tipo_persona = 'NATURAL' AND primer_nombre IS NOT NULL AND primer_apellido IS NOT NULL AND razon_social IS NULL) OR
        (tipo_persona = 'JURIDICA' AND razon_social IS NOT NULL AND primer_nombre IS NULL AND primer_apellido IS NULL)
    )
);

COMMENT ON TABLE core.clientes IS 'Maestro unificado de clientes (Persona Natural y Jurídica)';
COMMENT ON CONSTRAINT chk_datos_persona ON core.clientes IS 'Garantiza consistencia entre los nombres de persona natural o razón social de jurídica';