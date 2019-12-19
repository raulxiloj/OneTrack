-- CREACION DE TABLAS

-- Tablas temporales
CREATE TABLE TEMP_EMPLEADO(
    noempleado INTEGER PRIMARY KEY,
    nombre VARCHAR2(25),
    apellido VARCHAR2(25),
    jefe INTEGER,
    fechanacimiento DATE,
    fechacontratacion DATE,
    direccion VARCHAR2(100),
    ciudad VARCHAR2(80),
    telefono VARCHAR2(25),
    email VARCHAR2(100)
);

CREATE TABLE TEMP_CANCION(
    nombre VARCHAR2(150),
    duracion INTEGER,
    precio NUMBER(10,2),
    sizebytes INTEGER,
    compositor VARCHAR2(200),
    album VARCHAR2(200),
    artista VARCHAR2(200),
    tipoArchivo VARCHAR2(80),
    genero VARCHAR2(80),
    lista VARCHAR2(80)
);

CREATE TABLE TEMP_FACTURA(
    nofactura INTEGER,
    cancion VARCHAR2(200),
    album VARCHAR2(200),
    artista VARCHAR2(200),
    precio NUMBER(10,2),
    cantidad INTEGER,
    fecha DATE,
    total NUMBER(10,2),
    nombrecliente VARCHAR2(50),
    apellidocliente VARCHAR2(50),
    direccion VARCHAR2(200),
    ciudad VARCHAR2(100),
    telefono VARCHAR2(50),
    email VARCHAR2(150),
    soporte INTEGER
);

-- Tablas diseno

CREATE TABLE artista(
    idArtista INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(200)
);

CREATE TABLE compositor(
    idCompositor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(200)
);

CREATE TABLE genero(
    idGenero INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(80) NOT NULL
);

CREATE TABLE tipoArchivo(
    idTipo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100)
);

CREATE TABLE album(
    idAlbum INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL
);

CREATE TABLE cancion(
    idCancion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(150) NOT NULL,
    duracion INTEGER NOT NULL,
    precio NUMBER(8,2) NOT NULL,
    sizeBytes INTEGER NOT NULL,
    artista INTEGER,
    compositor INTEGER,
    genero INTEGER NOT NULL,
    tipoArchivo INTEGER NOT NULL,
    album INTEGER,
    FOREIGN KEY (artista) REFERENCES artista(idArtista),
    FOREIGN KEY (compositor) REFERENCES compositor(idCompositor),
    FOREIGN KEY (genero) REFERENCES genero(idGenero),
    FOREIGN KEY (tipoArchivo) REFERENCES tipoArchivo(idTipo),
    FOREIGN KEY (album) REFERENCES album(idAlbum)
);

CREATE TABLE lista(
    idLista INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100)
);

CREATE TABLE detalleLista(
    idLista INTEGER NOT NULL,
    idCancion INTEGER NOT NULL,
    PRIMARY KEY(idLista, idCancion),
    FOREIGN KEY (idLista) REFERENCES lista(idLista),
    FOREIGN KEY (idCancion) REFERENCES cancion(idCancion)
);

CREATE TABLE ciudad(
    idciudad INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE empleado(
    idEmpleado INTEGER PRIMARY KEY,
    nombre VARCHAR2(30) NOT NULL,
    apellido VARCHAR2(30) NOT NULL,
    jefe INTEGER,
    fechaNacimiento DATE NOT NULL,
    fechaContratacion DATE NOT NULL,
    direccion VARCHAR2(150) NOT NULL,
    ciudad INTEGER NOT NULL,
    telefono VARCHAR2(30) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    FOREIGN KEY(jefe) REFERENCES empleado(idEmpleado) ON DELETE CASCADE,
    FOREIGN KEY(ciudad) REFERENCES ciudad(idciudad)
);

CREATE TABLE cliente(
    idCliente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(30) NOT NULL,
    apellido VARCHAR2(30) NOT NULL,
    direccion VARCHAR2(150) NOT NULL,
    ciudad INTEGER NOT NULL,
    telefono VARCHAR2(30) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    soporte INTEGER NOT NULL,
    FOREIGN KEY (soporte) REFERENCES empleado(idEmpleado),
    FOREIGN KEY(ciudad) REFERENCES ciudad(idciudad)
);

CREATE TABLE factura(
    idFactura INTEGER PRIMARY KEY,
    total NUMBER(8,2) NOT NULL,
    fecha DATE NOT NULL,
    cliente INTEGER NOT NULL,
    FOREIGN KEY (cliente) REFERENCES cliente(idcliente)
);

CREATE TABLE detalleFactura(
    idFactura INTEGER NOT NULL,
    idCancion INTEGER NOT NULL,
    PRIMARY KEY (idFactura,idCancion),
    CONSTRAINT FK_DF_idF FOREIGN KEY (idFactura) REFERENCES factura(idFactura),
    CONSTRAINT FK_DF_idC FOREIGN KEY (idCancion) REFERENCES cancion(idCancion)
);
