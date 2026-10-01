"DEPOSITAR"
CREATE OR REPLACE PROCEDURE cuentas.depositar(
    p_id_cuenta BIGINT,
    p_monto NUMERIC(18,2)
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_monto <= 0 THEN
        RAISE EXCEPTION 'El monto debe ser mayor que cero';
    END IF;

    UPDATE cuentas.cuenta
    SET saldo = saldo + p_monto
    WHERE id_cuenta = p_id_cuenta;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La cuenta no existe';
    END IF;

END;
$$;

"RETIRAR"
CREATE OR REPLACE PROCEDURE cuentas.retirar(
    p_id_cuenta BIGINT,
    p_monto NUMERIC(18,2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo NUMERIC(18,2);
BEGIN

    SELECT saldo
    INTO v_saldo
    FROM cuentas.cuenta
    WHERE id_cuenta = p_id_cuenta
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La cuenta no existe';
    END IF;

    IF p_monto <= 0 THEN
        RAISE EXCEPTION 'El monto debe ser mayor que cero';
    END IF;

    IF v_saldo < p_monto THEN
        RAISE EXCEPTION 'Fondos insuficientes';
    END IF;

    UPDATE cuentas.cuenta
    SET saldo = saldo - p_monto
    WHERE id_cuenta = p_id_cuenta;

END;
$$;