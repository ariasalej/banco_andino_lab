-- ==========================================
-- Archivo: 02_catalogs.sql
-- Propósito: Catálogos genéricos y estados acotados
-- ==========================================

CREATE TABLE core.cat_estados_cliente (
    estado VARCHAR(20) PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

INSERT INTO core.cat_estados_cliente (estado, descripcion) VALUES
('ACTIVO', 'Cliente completamente vinculado y activo'),
('INACTIVO', 'Cliente inactivo por falta de operaciones'),
('BLOQUEADO', 'Cliente bloqueado por prevención de riesgo o temas legales'),
('PENDIENTE', 'Cliente en proceso de validación o documentación');

CREATE TABLE core.cat_estados_cuenta (
    estado VARCHAR(20) PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

INSERT INTO core.cat_estados_cuenta (estado, descripcion) VALUES
('ACTIVA', 'Cuenta operativa para todo tipo de transacción'),
('BLOQUEADA_TEMPORAL', 'Bloqueo preventivo de retiros y transferencias'),
('BLOQUEADA_LEGAL', 'Bloqueo total por orden judicial o embargos'),
('CERRADA', 'Cuenta inactiva definitivamente, saldo en cero');

CREATE TABLE core.cat_tipos_transaccion (
    tipo VARCHAR(30) PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

INSERT INTO core.cat_tipos_transaccion (tipo, descripcion) VALUES
('CONSIGNACION', 'Consignación o depósito de dinero'),
('RETIRO', 'Retiro de efectivo en caja o cajero'),
('TRANSFERENCIA', 'Transferencia de fondos entre cuentas'),
('DEBITO_AUTOMATICO', 'Débito automático programado'),
('CREDITO_APLICADO', 'Crédito o abono a favor'),
('REVERSO', 'Operación de reverso o compensación contable');

COMMENT ON TABLE core.cat_estados_cliente IS 'Catálogo de estados válidos para la entidad cliente';
COMMENT ON TABLE core.cat_estados_cuenta IS 'Catálogo de estados válidos del ciclo de vida de una cuenta';
COMMENT ON TABLE core.cat_tipos_transaccion IS 'Catálogo de operaciones financieras admitidas';