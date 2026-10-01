CREATE ROLE banco_admin;
CREATE ROLE banco_consulta;
CREATE ROLE banco_operador;

GRANT USAGE ON SCHEMA clientes TO banco_consulta;
GRANT USAGE ON SCHEMA cuentas TO banco_consulta;

GRANT SELECT ON ALL TABLES IN SCHEMA clientes
TO banco_consulta;

GRANT SELECT ON ALL TABLES IN SCHEMA cuentas
TO banco_consulta;

"Para ADMINISTRADOR"
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA clientes
TO banco_admin;

"Para OPERADOR"
GRANT SELECT
ON ALL TABLES IN SCHEMA clientes
TO banco_operador;

"OPERACIONES FINANCIERAS"
GRANT EXECUTE
ON PROCEDURE cuentas.depositar(BIGINT, NUMERIC)
TO banco_operador;