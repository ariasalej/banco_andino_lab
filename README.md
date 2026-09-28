# Banco Andino Lab

Proyecto de Ingeniería de Bases de Datos Relacionales utilizando PostgreSQL.

## Descripción

Sistema de base de datos bancaria diseñado para soportar operaciones financieras, administración de clientes y cuentas, contabilidad de partida doble, auditoría, seguridad mediante roles y consultas analíticas.

## Tecnologías

- PostgreSQL 16+
- Python 3.11+
- Faker
- psycopg
- DbVisualizer
- Git / GitHub

## Estructura

- Sql/ — scripts de creación, restricciones, índices, funciones, procedimientos, triggers, roles y pruebas.
- Data/ — generador de datos sintéticos.
- Consultas/ — consultas SQL y evidencias de resultados.
- Evidencias/ — capturas de las pruebas y funcionamiento del sistema.
- Prompts/ — prompts utilizados durante el desarrollo asistido por IA.

## Modelo

La base de datos se encuentra organizada en los siguientes esquemas:

- catalogo
- geografia
- clientes
- cuentas
- seguridad
- 	ransacciones
- contabilidad
- uditoria

## Volumen de datos

El proyecto fue probado con aproximadamente:

- 10.000 clientes
- 50.000 cuentas
- 1.000.000+ transacciones
- 2.000.000+ movimientos contables

## Características

- Integridad referencial mediante PK y FK.
- Restricciones UNIQUE, NOT NULL y CHECK.
- Manejo de valores monetarios mediante NUMERIC.
- Transacciones financieras con control de saldo.
- Transferencias atómicas.
- Contabilidad de partida doble.
- Reversión de transacciones.
- Protección de transacciones posteadas.
- Auditoría.
- Roles y permisos RBAC.
- Índices para optimización.
- Consultas básicas, intermedias y avanzadas.
- Pruebas de calidad e integridad.
- Análisis de rendimiento mediante EXPLAIN ANALYZE.
- Generación de datos sintéticos mediante Python.

## Orden de ejecución

Los scripts SQL deben ejecutarse siguiendo su numeración:

1. Extensiones
2. Esquemas
3. Catálogos
4. Geografía
5. Clientes
6. Productos
7. Cuentas
8. Seguridad
9. Transacciones
10. Contabilidad
11. Auditoría
12. Restricciones
13. Índices
14. Vistas
15. Funciones
16. Procedimientos
17. Triggers
18. Roles y permisos
19. Pruebas

## Evidencias

Las pruebas realizadas y sus resultados se encuentran en la carpeta Evidencias/.

El proyecto también incluye evidencias de consultas, seguridad, integridad, transacciones, contabilidad y funcionamiento general.

## Autores

Proyecto académico — Ingeniería de Sistemas.
