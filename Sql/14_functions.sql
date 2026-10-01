CREATE OR REPLACE FUNCTION cuentas.obtener_saldo(
    p_id_cuenta BIGINT
)
RETURNS NUMERIC(18,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo NUMERIC(18,2);
BEGIN
    SELECT saldo
    INTO v_saldo
    FROM cuentas.cuenta
    WHERE id_cuenta = p_id_cuenta;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La cuenta no existe';
    END IF;

    RETURN v_saldo;
END;
$$;