CREATE OR REPLACE FUNCTION auditoria.proteger_transaccion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF OLD.id_estado_transaccion IS NOT NULL THEN
        RAISE EXCEPTION
            'Las transacciones existentes no pueden modificarse';
    END IF;

    RETURN NEW;

END;
$$;

CREATE TRIGGER trg_proteger_transaccion
BEFORE UPDATE OR DELETE
ON transacciones.transaccion
FOR EACH ROW
EXECUTE FUNCTION auditoria.proteger_transaccion();