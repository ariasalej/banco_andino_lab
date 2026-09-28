-- ==========================================
-- Archivo: 15_procedures.sql
-- Propósito: Operaciones atómicas de transferencia, consignación y reverso
-- ==========================================

-- Procedimiento para realizar consignaciones atómicas
CREATE OR REPLACE PROCEDURE core.sp_realizar_consignacion(
    p_idempotency_key VARCHAR(64),
    p_cuenta_destino_id INT,
    p_monto NUMERIC(15,2),
    p_descripcion VARCHAR(200) DEFAULT 'Consignación en efectivo/cheque'
) AS $$
DECLARE
    v_transaccion_id INT;
    v_saldo_actual NUMERIC(15,2);
    v_saldo_nuevo NUMERIC(15,2);
BEGIN
    -- Validar monto
    IF p_monto <= 0 THEN
        RAISE EXCEPTION 'El monto a consignar debe ser mayor a cero';
    END IF;

    -- Bloquear la cuenta destino para evitar condiciones de carrera (Lost Update)
    SELECT saldo_contable INTO v_saldo_actual
    FROM core.cuentas
    WHERE cuenta_id = p_cuenta_destino_id AND estado = 'ACTIVA'
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La cuenta destino % no existe o no está activa', p_cuenta_destino_id;
    END IF;

    v_saldo_nuevo := v_saldo_actual + p_monto;

    -- Registrar cabecera de la transacción
    INSERT INTO core.transacciones (idempotency_key, cuenta_origen_id, cuenta_destino_id, tipo_transaccion, monto, estado, descripcion)
    VALUES (p_idempotency_key, NULL, p_cuenta_destino_id, 'CONSIGNACION', p_monto, 'POSTED', p_descripcion)
    RETURNING transaccion_id INTO v_transaccion_id;

    -- Registrar movimiento contable (Crédito a la cuenta)
    INSERT INTO core.ledger_movimientos (transaccion_id, cuenta_id, tipo_movimiento, monto, saldo_resultante)
    VALUES (v_transaccion_id, p_cuenta_destino_id, 'CREDITO', p_monto, v_saldo_nuevo);

    -- Actualizar saldo de la cuenta
    UPDATE core.cuentas
    SET saldo_contable = v_saldo_nuevo,
        saldo_disponible = saldo_disponible + p_monto,
        updated_at = CURRENT_TIMESTAMP
    WHERE cuenta_id = p_cuenta_destino_id;

END;
$$ LANGUAGE plpgsql;

-- Procedimiento para transferencias atómicas entre dos cuentas
CREATE OR REPLACE PROCEDURE core.sp_realizar_transferencia(
    p_idempotency_key VARCHAR(64),
    p_cuenta_origen_id INT,
    p_cuenta_destino_id INT,
    p_monto NUMERIC(15,2),
    p_descripcion VARCHAR(200) DEFAULT 'Transferencia entre cuentas'
) AS $$
DECLARE
    v_transaccion_id INT;
    v_saldo_orig_actual NUMERIC(15,2);
    v_saldo_orig_nuevo NUMERIC(15,2);
    v_saldo_dest_actual NUMERIC(15,2);
    v_saldo_dest_nuevo NUMERIC(15,2);
BEGIN
    IF p_cuenta_origen_id = p_cuenta_destino_id THEN
        RAISE EXCEPTION 'La cuenta de origen y destino no pueden ser la misma';
    END IF;

    IF p_monto <= 0 THEN
        RAISE EXCEPTION 'El monto a transferir debe ser mayor a cero';
    END IF;

    -- Ordenar bloqueos pesimistas por ID para evitar Deadlocks
    IF p_cuenta_origen_id < p_cuenta_destino_id THEN
        SELECT saldo_disponible INTO v_saldo_orig_actual FROM core.cuentas WHERE cuenta_id = p_cuenta_origen_id AND estado = 'ACTIVA' FOR UPDATE;
        SELECT saldo_contable INTO v_saldo_dest_actual FROM core.cuentas WHERE cuenta_id = p_cuenta_destino_id AND estado = 'ACTIVA' FOR UPDATE;
    ELSE
        SELECT saldo_contable INTO v_saldo_dest_actual FROM core.cuentas WHERE cuenta_id = p_cuenta_destino_id AND estado = 'ACTIVA' FOR UPDATE;
        SELECT saldo_disponible INTO v_saldo_orig_actual FROM core.cuentas WHERE cuenta_id = p_cuenta_origen_id AND estado = 'ACTIVA' FOR UPDATE;
    END IF;

    IF v_saldo_orig_actual < p_monto THEN
        RAISE EXCEPTION 'Saldo insuficiente en la cuenta de origen %', p_cuenta_origen_id;
    END IF;

    v_saldo_orig_nuevo := v_saldo_orig_actual - p_monto;
    v_saldo_dest_nuevo := v_saldo_dest_actual + p_monto;

    -- Registrar cabecera
    INSERT INTO core.transacciones (idempotency_key, cuenta_origen_id, cuenta_destino_id, tipo_transaccion, monto, estado, descripcion)
    VALUES (p_idempotency_key, p_cuenta_origen_id, p_cuenta_destino_id, 'TRANSFERENCIA', p_monto, 'POSTED', p_descripcion)
    RETURNING transaccion_id INTO v_transaccion_id;

    -- Registrar Doble Partida (Débito en Origen, Crédito en Destino)
    INSERT INTO core.ledger_movimientos (transaccion_id, cuenta_id, tipo_movimiento, monto, saldo_resultante)
    VALUES 
    (v_transaccion_id, p_cuenta_origen_id, 'DEBITO', p_monto, v_saldo_orig_nuevo),
    (v_transaccion_id, p_cuenta_destino_id, 'CREDITO', p_monto, v_saldo_dest_nuevo);

    -- Actualizar saldos de origen
    UPDATE core.cuentas
    SET saldo_contable = saldo_contable - p_monto,
        saldo_disponible = v_saldo_orig_nuevo,
        updated_at = CURRENT_TIMESTAMP
    WHERE cuenta_id = p_cuenta_origen_id;

    -- Actualizar saldos de destino
    UPDATE core.cuentas
    SET saldo_contable = v_saldo_dest_nuevo,
        saldo_disponible = saldo_disponible + p_monto,
        updated_at = CURRENT_TIMESTAMP
    WHERE cuenta_id = p_cuenta_destino_id;

END;
$$ LANGUAGE plpgsql;