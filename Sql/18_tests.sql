-- ==========================================
-- Archivo: 18_tests.sql
-- Propósito: Pruebas unitarias positivas y negativas (Quality Gate G3)
-- ==========================================

-- Prueba 1: Intentar modificar una transacción POSTED (Debe fallar por el trigger de inmutabilidad)
-- UPDATE core.transacciones SET monto = 999999 WHERE transaccion_id = 1;

-- Prueba 2: Intentar transferir dinero a la misma cuenta (Debe fallar)
-- CALL core.sp_realizar_transferencia('TEST-IDEMP-01', 1, 1, 50000);

-- Prueba 3: Intentar transferir sin saldo suficiente (Debe fallar)
-- CALL core.sp_realizar_transferencia('TEST-IDEMP-02', 1, 2, 999999999);