-- ==========================================
-- Archivo: 14_functions.sql
-- Propósito: Funciones de negocio atómicas y verificaciones
-- ==========================================

-- Función para validar saldo disponible antes de débito
CREATE OR REPLACE FUNCTION core.fn_validar_saldo_disponible(
    p_cuenta_id INT,
    p_monto NUMERIC
) RETURNS BOOLEAN AS $$
DECLARE
    v_saldo NUMERIC;
    v_estado VARCHAR(20);
BEGIN
    SELECT saldo_disponible, estado 
    INTO v_saldo, v_estado 
    FROM core.cuentas 
    WHERE cuenta_id = p_cuenta_id;

    IF v_estado <> 'ACTIVA' THEN
        RAISE EXCEPTION 'La cuenta % no está activa para transacciones (Estado: %).', p_cuenta_id, v_estado;
    END IF;

    IF v_saldo < p_monto THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;