import random
import math
import uuid`r`nimport os

from datetime import datetime, timedelta, timezone
from decimal import Decimal

import psycopg


# ============================================================
# 1. CONFIGURACIÃ“N
# ============================================================

DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "banco_andino_lab",
    "user": "postgres",
    "password": os.getenv("BANCO_DB_PASSWORD")
}

OBJETIVO_TRANSACCIONES = 1_000_000

TAMANO_LOTE = 25_000

SEED = 20260909

FECHA_INICIO = datetime(
    2025,
    1,
    1,
    tzinfo=timezone.utc
)

FECHA_FIN = datetime(
    2026,
    9,
    28,
    23,
    59,
    59,
    tzinfo=timezone.utc
)

random.seed(SEED)


# ============================================================
# 2. CONEXIÃ“N
# ============================================================

def conectar():

    return psycopg.connect(**DB_CONFIG)


# ============================================================
# 3. OBTENER TOTAL ACTUAL DE TRANSACCIONES
# ============================================================

def obtener_total_transacciones(conn):

    with conn.cursor() as cur:

        cur.execute("""
            SELECT COUNT(*)
            FROM transacciones.transaccion;
        """)

        return cur.fetchone()[0]


# ============================================================
# 4. CARGAR CUENTAS ACTIVAS
# ============================================================

def cargar_cuentas(conn):

    print()
    print("Cargando cuentas activas...")

    with conn.cursor() as cur:

        cur.execute("""
            SELECT
                c.cuenta_id,
                c.moneda_id,
                c.fecha_apertura,
                c.saldo_disponible,
                c.saldo_contable,
                c.sobregiro_autorizado
            FROM cuentas.cuenta c
            JOIN catalogo.estado_cuenta ec
                ON ec.estado_cuenta_id = c.estado_cuenta_id
            WHERE c.cuenta_id >= 3
              AND ec.codigo = 'ACTIVA'
            ORDER BY c.cuenta_id;
        """)

        filas = cur.fetchall()

    cuentas = []

    for fila in filas:

        cuentas.append({
            "cuenta_id": fila[0],
            "moneda_id": fila[1],
            "fecha_apertura": fila[2],
            "saldo_disponible": Decimal(fila[3]),
            "saldo_contable": Decimal(fila[4]),
            "sobregiro_autorizado": Decimal(fila[5])
        })

    print(
        f"Cuentas disponibles: {len(cuentas):,}"
    )

    return cuentas


# ============================================================
# 5. GENERAR FECHA ALEATORIA
# ============================================================

def generar_fecha(fecha_minima):

    if fecha_minima < FECHA_INICIO:
        fecha_minima = FECHA_INICIO

    if fecha_minima > FECHA_FIN:
        fecha_minima = FECHA_FIN

    diferencia = (
        FECHA_FIN - fecha_minima
    )

    segundos = int(
        diferencia.total_seconds()
    )

    if segundos <= 0:
        return fecha_minima

    return fecha_minima + timedelta(
        seconds=random.randint(
            0,
            segundos
        )
    )


# ============================================================
# 6. GENERAR MONTO
# ============================================================

def generar_monto():

    monto = random.lognormvariate(
        math.log(250_000),
        1.0
    )

    # LÃ­mites razonables
    monto = max(
        5_000,
        monto
    )

    monto = min(
        20_000_000,
        monto
    )

    # Redondear a miles
    monto = round(
        monto / 1000
    ) * 1000

    return Decimal(
        str(monto)
    ).quantize(
        Decimal("0.01")
    )


# ============================================================
# 7. GENERAR REFERENCIA ÃšNICA
# ============================================================

def generar_referencia():

    return (
        "TRX-SYN-"
        + uuid.uuid4().hex.upper()
    )


# ============================================================
# 8. CREAR TRANSACCIÃ“N DE DEPÃ“SITO
# ============================================================

def generar_deposito(cuentas):

    cuenta = random.choice(cuentas)

    monto = generar_monto()

    fecha = generar_fecha(
        cuenta["fecha_apertura"]
    )

    # Actualizar saldo en memoria
    cuenta["saldo_disponible"] += monto
    cuenta["saldo_contable"] += monto

    return (
        generar_referencia(),
        "DEPOSITO",
        None,
        cuenta["cuenta_id"],
        cuenta["moneda_id"],
        monto,
        fecha,
        "DepÃ³sito sintÃ©tico"
    )


# ============================================================
# 9. CREAR TRANSACCIÃ“N DE RETIRO
# ============================================================

def generar_retiro(cuentas):

    cuenta = random.choice(cuentas)

    disponible = (
        cuenta["saldo_disponible"]
        + cuenta["sobregiro_autorizado"]
    )

    # No se puede retirar menos de $5.000
    if disponible < Decimal("5000"):
        return None

    monto = generar_monto()

    if monto > disponible:
        monto = disponible

    monto = monto.quantize(
        Decimal("0.01")
    )

    if monto <= 0:
        return None

    fecha = generar_fecha(
        cuenta["fecha_apertura"]
    )

    # Actualizar saldo
    cuenta["saldo_disponible"] -= monto
    cuenta["saldo_contable"] -= monto

    return (
        generar_referencia(),
        "RETIRO",
        cuenta["cuenta_id"],
        None,
        cuenta["moneda_id"],
        monto,
        fecha,
        "Retiro sintÃ©tico"
    )


# ============================================================
# 10. CREAR TRANSACCIÃ“N DE TRANSFERENCIA
# ============================================================

def generar_transferencia(cuentas):

    cuenta_origen, cuenta_destino = random.sample(
        cuentas,
        2
    )

    # Las dos cuentas deben manejar la misma moneda
    if (
        cuenta_origen["moneda_id"]
        != cuenta_destino["moneda_id"]
    ):
        return None

    disponible = (
        cuenta_origen["saldo_disponible"]
        + cuenta_origen["sobregiro_autorizado"]
    )

    if disponible < Decimal("5000"):
        return None

    monto = generar_monto()

    if monto > disponible:
        monto = disponible

    monto = monto.quantize(
        Decimal("0.01")
    )

    if monto <= 0:
        return None

    fecha_minima = max(
        cuenta_origen["fecha_apertura"],
        cuenta_destino["fecha_apertura"]
    )

    fecha = generar_fecha(
        fecha_minima
    )

    # Actualizar origen
    cuenta_origen["saldo_disponible"] -= monto
    cuenta_origen["saldo_contable"] -= monto

    # Actualizar destino
    cuenta_destino["saldo_disponible"] += monto
    cuenta_destino["saldo_contable"] += monto

    return (
        generar_referencia(),
        "TRANSFERENCIA",
        cuenta_origen["cuenta_id"],
        cuenta_destino["cuenta_id"],
        cuenta_origen["moneda_id"],
        monto,
        fecha,
        "Transferencia sintÃ©tica"
    )


# ============================================================
# 11. GENERAR UN LOTE
# ============================================================

def generar_lote(cuentas, cantidad):

    transacciones = []

    while len(transacciones) < cantidad:

        tipo = random.choices(
            [
                "DEPOSITO",
                "RETIRO",
                "TRANSFERENCIA"
            ],
            weights=[
                45,
                30,
                25
            ],
            k=1
        )[0]

        if tipo == "DEPOSITO":

            transaccion = generar_deposito(
                cuentas
            )

        elif tipo == "RETIRO":

            transaccion = generar_retiro(
                cuentas
            )

        else:

            transaccion = generar_transferencia(
                cuentas
            )

        # Si el retiro/transferencia no fue posible,
        # intentamos otra vez.
        if transaccion is not None:

            transacciones.append(
                transaccion
            )

    return transacciones


# ============================================================
# 12. INSERTAR TRANSACCIONES DEL LOTE
# ============================================================

def insertar_transacciones(
    conn,
    transacciones
):

    with conn.cursor() as cur:

        # ----------------------------------------------------
        # TABLA TEMPORAL
        # ----------------------------------------------------

        cur.execute("""
            CREATE TEMP TABLE IF NOT EXISTS
            tmp_transacciones (
                referencia VARCHAR(50),
                tipo_codigo VARCHAR(20),
                cuenta_origen_id BIGINT,
                cuenta_destino_id BIGINT,
                moneda_id SMALLINT,
                monto NUMERIC(18,2),
                fecha_transaccion TIMESTAMPTZ,
                descripcion VARCHAR(250)
            ) ON COMMIT DELETE ROWS;
        """)

        cur.execute("""
            TRUNCATE tmp_transacciones;
        """)

        # ----------------------------------------------------
        # COPY MASIVO
        # ----------------------------------------------------

        with cur.copy("""
            COPY tmp_transacciones (
                referencia,
                tipo_codigo,
                cuenta_origen_id,
                cuenta_destino_id,
                moneda_id,
                monto,
                fecha_transaccion,
                descripcion
            )
            FROM STDIN
        """) as copy:

            for transaccion in transacciones:

                copy.write_row(
                    transaccion
                )

        # ----------------------------------------------------
        # INSERTAR TRANSACCIONES
        # ----------------------------------------------------

        cur.execute("""
            INSERT INTO transacciones.transaccion (
                referencia,
                tipo_transaccion_id,
                estado_transaccion_id,
                cuenta_origen_id,
                cuenta_destino_id,
                moneda_id,
                monto,
                fecha_transaccion,
                descripcion,
                fecha_posteo
            )
            SELECT
                tmp.referencia,
                tt.tipo_transaccion_id,
                et.estado_transaccion_id,
                tmp.cuenta_origen_id,
                tmp.cuenta_destino_id,
                tmp.moneda_id,
                tmp.monto,
                tmp.fecha_transaccion,
                tmp.descripcion,
                tmp.fecha_transaccion
            FROM tmp_transacciones tmp
            JOIN catalogo.tipo_transaccion tt
                ON tt.codigo = tmp.tipo_codigo
            JOIN catalogo.estado_transaccion et
                ON et.codigo = 'POSTEADA';
        """)

        # ----------------------------------------------------
        # MOVIMIENTO 1
        # ----------------------------------------------------
        # DEPÃ“SITO:
        #   Caja/Bancos      DEBITO
        #
        # RETIRO:
        #   Cuenta cliente  DEBITO
        #
        # TRANSFERENCIA:
        #   Cuenta origen   DEBITO
        # ----------------------------------------------------

        cur.execute("""
            INSERT INTO contabilidad.movimiento (
                transaccion_id,
                cuenta_id,
                cuenta_contable_id,
                tipo_movimiento,
                monto,
                fecha_movimiento,
                descripcion
            )
            SELECT
                tr.transaccion_id,

                CASE
                    WHEN tmp.tipo_codigo = 'DEPOSITO'
                        THEN NULL
                    ELSE tmp.cuenta_origen_id
                END,

                CASE
                    WHEN tmp.tipo_codigo = 'DEPOSITO'
                        THEN 1
                    ELSE 2
                END,

                'DEBITO',

                tmp.monto,

                tmp.fecha_transaccion,

                tmp.descripcion

            FROM tmp_transacciones tmp

            JOIN transacciones.transaccion tr
                ON tr.referencia = tmp.referencia;
        """)

        # ----------------------------------------------------
        # MOVIMIENTO 2
        # ----------------------------------------------------
        # DEPÃ“SITO:
        #   Cuenta cliente  CREDITO
        #
        # RETIRO:
        #   Caja/Bancos      CREDITO
        #
        # TRANSFERENCIA:
        #   Cuenta destino   CREDITO
        # ----------------------------------------------------

        cur.execute("""
            INSERT INTO contabilidad.movimiento (
                transaccion_id,
                cuenta_id,
                cuenta_contable_id,
                tipo_movimiento,
                monto,
                fecha_movimiento,
                descripcion
            )
            SELECT
                tr.transaccion_id,

                CASE
                    WHEN tmp.tipo_codigo = 'DEPOSITO'
                        THEN tmp.cuenta_destino_id
                    WHEN tmp.tipo_codigo = 'TRANSFERENCIA'
                        THEN tmp.cuenta_destino_id
                    ELSE NULL
                END,

                CASE
                    WHEN tmp.tipo_codigo = 'RETIRO'
                        THEN 1
                    ELSE 2
                END,

                'CREDITO',

                tmp.monto,

                tmp.fecha_transaccion,

                tmp.descripcion

            FROM tmp_transacciones tmp

            JOIN transacciones.transaccion tr
                ON tr.referencia = tmp.referencia;
        """)


# ============================================================
# 13. ACTUALIZAR SALDOS
# ============================================================

def actualizar_saldos(
    conn,
    cuentas
):

    with conn.cursor() as cur:

        datos = [
            (
                cuenta["saldo_disponible"],
                cuenta["saldo_contable"],
                cuenta["cuenta_id"]
            )
            for cuenta in cuentas
        ]

        cur.executemany(
            """
            UPDATE cuentas.cuenta
            SET
                saldo_disponible = %s,
                saldo_contable = %s
            WHERE cuenta_id = %s;
            """,
            datos
        )


# ============================================================
# 14. PROCESAR TODO
# ============================================================

def procesar():

    print("=" * 65)
    print("GENERADOR MASIVO DE TRANSACCIONES")
    print("=" * 65)

    with conectar() as conn:

        # ----------------------------------------------------
        # TOTAL ACTUAL
        # ----------------------------------------------------

        total_actual = obtener_total_transacciones(
            conn
        )

        faltantes = (
            OBJETIVO_TRANSACCIONES
            - total_actual
        )

        print()
        print(
            f"Transacciones actuales: "
            f"{total_actual:,}"
        )

        print(
            f"Objetivo: "
            f"{OBJETIVO_TRANSACCIONES:,}"
        )

        print(
            f"Transacciones por generar: "
            f"{faltantes:,}"
        )

        if faltantes <= 0:

            print()
            print(
                "El objetivo ya fue alcanzado."
            )

            return

        # ----------------------------------------------------
        # CUENTAS
        # ----------------------------------------------------

        cuentas = cargar_cuentas(
            conn
        )

        if not cuentas:

            raise Exception(
                "No existen cuentas activas."
            )

        # ----------------------------------------------------
        # LOTES
        # ----------------------------------------------------

        procesadas = 0

        numero_lote = 0

        while procesadas < faltantes:

            numero_lote += 1

            cantidad_lote = min(
                TAMANO_LOTE,
                faltantes - procesadas
            )

            print()
            print("-" * 65)

            print(
                f"Lote {numero_lote:,}"
            )

            print(
                f"Cantidad: "
                f"{cantidad_lote:,}"
            )

            print("Generando datos...")

            transacciones = generar_lote(
                cuentas,
                cantidad_lote
            )

            print("Insertando transacciones...")

            insertar_transacciones(
                conn,
                transacciones
            )

            print("Actualizando saldos...")

            actualizar_saldos(
                conn,
                cuentas
            )

            # ------------------------------------------------
            # COMMIT DEL LOTE
            # ------------------------------------------------

            conn.commit()

            procesadas += cantidad_lote

            total = (
                total_actual
                + procesadas
            )

            porcentaje = (
                total
                / OBJETIVO_TRANSACCIONES
            ) * 100

            print(
                f"Lote completado."
            )

            print(
                f"Progreso: "
                f"{total:,}/"
                f"{OBJETIVO_TRANSACCIONES:,}"
            )

            print(
                f"Porcentaje: "
                f"{porcentaje:.2f}%"
            )

        # ----------------------------------------------------
        # FINAL
        # ----------------------------------------------------

        print()
        print("=" * 65)
        print("GENERACIÃ“N COMPLETADA")
        print("=" * 65)

        print(
            f"Total final esperado: "
            f"{OBJETIVO_TRANSACCIONES:,}"
        )


# ============================================================
# 15. EJECUTAR
# ============================================================

if __name__ == "__main__":

    try:

        procesar()

    except Exception as error:

        print()
        print("=" * 65)
        print("ERROR")
        print("=" * 65)

        print(
            type(error).__name__
        )

        print(error)
