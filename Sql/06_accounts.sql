-- ==========================================
-- Archivo: 06_accounts.sql
-- Propósito: Cuentas bancarias y relación de titularidad (N:M)
-- ==========================================

CREATE TABLE core.cuentas (
    cuenta_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero_cuenta VARCHAR(20) NOT NULL UNIQUE,
    producto_id INT NOT NULL,
    oficina_id INT NOT NULL,
    moneda VARCHAR(3) NOT NULL DEFAULT 'COP',
    saldo_contable NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    saldo_disponible NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_cuenta_producto FOREIGN KEY (producto_id) REFERENCES core.productos(producto_id) ON DELETE RESTRICT,
    CONSTRAINT fk_cuenta_oficina FOREIGN KEY (oficina_id) REFERENCES core.municipios(municipio_id) ON DELETE RESTRICT,
    CONSTRAINT fk_cuenta_estado FOREIGN KEY (estado) REFERENCES core.cat_estados_cuenta(estado) ON DELETE RESTRICT,
    CONSTRAINT chk_cuenta_moneda CHECK (moneda = 'COP'),
    CONSTRAINT chk_cuenta_saldos CHECK (saldo_disponible <= saldo_contable)
);

CREATE TABLE core.titularidad (
    titularidad_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id INT NOT NULL,
    cuenta_id INT NOT NULL,
    rol_titular VARCHAR(20) NOT NULL DEFAULT 'PRINCIPAL',
    tipo_firma VARCHAR(20) NOT NULL DEFAULT 'INDISTINTA',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_cliente_cuenta UNIQUE (cliente_id, cuenta_id),
    CONSTRAINT fk_titularidad_cliente FOREIGN KEY (cliente_id) REFERENCES core.clientes(cliente_id) ON DELETE RESTRICT,
    CONSTRAINT fk_titularidad_cuenta FOREIGN KEY (cuenta_id) REFERENCES core.cuentas(cuenta_id) ON DELETE RESTRICT,
    CONSTRAINT chk_rol_titular CHECK (rol_titular IN ('PRINCIPAL', 'CO_TITULAR', 'APODERADO')),
    CONSTRAINT chk_tipo_firma CHECK (tipo_firma IN ('INDISTINTA', 'CONJUNTA'))
);

CREATE TABLE core.eventos_cuenta (
    evento_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cuenta_id INT NOT NULL,
    tipo_evento VARCHAR(30) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    realizado_por VARCHAR(50) NOT NULL,
    fecha_evento TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_evento_cuenta FOREIGN KEY (cuenta_id) REFERENCES core.cuentas(cuenta_id) ON DELETE RESTRICT,
    CONSTRAINT chk_tipo_evento CHECK (tipo_evento IN ('CREACION', 'ACTIVACION', 'BLOQUEO_TEMPORAL', 'BLOQUEO_LEGAL', 'DESBLOQUEO', 'CAMBIO_LIMITES', 'CIERRE'))
);

COMMENT ON TABLE core.cuentas IS 'Cuentas bancarias de clientes';
COMMENT ON TABLE core.titularidad IS 'Relación N:M entre clientes y cuentas con definición de firmas';
COMMENT ON TABLE core.eventos_cuenta IS 'Eventos administrativos del ciclo de vida de la cuenta (no financieros)';