OPTIONS (SKIP-1)
LOAD DATA
CHARACTERSET UTF8
INFILE '../Data/facturasFinal.csv'
INTO TABLE TEMP_FACTURA
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(
    noFactura,
    cancion,
    album,
    artista,
    precio,
    cantidad,
    fecha	     "TO_DATE(SUBSTR(:fecha,0,10),'YYYY-MM-DD')",
    total,
    nombrecliente,
    apellidocliente,
    direccion,
    ciudad,
    telefono,
    email,
    soporte
)
