CREATE TABLE geografia.departamento (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE geografia.ciudad (
    id_ciudad SERIAL PRIMARY KEY,
    id_departamento INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT fk_ciudad_departamento
        FOREIGN KEY (id_departamento)
        REFERENCES geografia.departamento(id_departamento),

    CONSTRAINT uq_ciudad_departamento
        UNIQUE (id_departamento, nombre)
);

CREATE TABLE geografia.oficina (
    id_oficina SERIAL PRIMARY KEY,
    id_ciudad INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),

    CONSTRAINT fk_oficina_ciudad
        FOREIGN KEY (id_ciudad)
        REFERENCES geografia.ciudad(id_ciudad)
);