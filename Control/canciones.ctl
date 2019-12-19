OPTIONS (SKIP-1)
LOAD DATA
CHARACTERSET UTF8
INFILE '../Data/tracksFinal.csv'
INTO TABLE TEMP_CANCION
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(
    nombre,
    duracion,
    precio,
    sizebytes,
    compositor    "CASE WHEN :compositor IN ('\\N') THEN NULL ELSE :compositor END",
    album,
    artista,
    tipoArchivo,
    genero,
    lista
)
