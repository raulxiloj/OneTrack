-- Distribucion de informacion a la nueva base de datos
-- Insercion de las tablas temporales a las tablas del diseno

-- Artista
INSERT INTO artista(nombre)
SELECT artista 
FROM temp_cancion
GROUP BY artista;

-- Compositor
INSERT INTO compositor(nombre)
SELECT compositor 
FROM temp_cancion
WHERE compositor IS NOT NULL
GROUP BY compositor;

-- Genero
INSERT INTO genero(nombre)
SELECT genero 
FROM temp_cancion
GROUP BY genero;

-- Tipo Archivo
INSERT INTO tipoarchivo(nombre)
SELECT tipoarchivo 
FROM temp_cancion
GROUP BY tipoarchivo;

-- Album
INSERT INTO album(nombre)
SELECT album 
FROM temp_cancion
GROUP BY album;

-- Cancion 
INSERT INTO cancion(nombre,duracion,precio,sizeBytes,artista,compositor,genero,tipoArchivo,album)
SELECT t.nombre,t.duracion,t.precio,t.sizebytes, a.idartista, c.idcompositor, g.idgenero, tipo.idtipo, album.idalbum
FROM temp_cancion t INNER JOIN artista a
ON t.artista = a.nombre FULL JOIN compositor c
ON t.compositor = c.nombre INNER JOIN genero g 
ON t.genero = g.nombre INNER JOIN tipoArchivo tipo
ON t.tipoarchivo = tipo.nombre FULL JOIN album album
ON t.album = album.nombre
GROUP BY t.nombre, a.idartista, c.idcompositor, g.idgenero, tipo.idtipo, album.idalbum, t.duracion, t.precio, t.sizebytes;

-- Lista
INSERT INTO lista(nombre)
SELECT lista 
FROM temp_cancion
GROUP BY lista;

-- Detalle lista
INSERT INTO detalleLista(idLista,idCancion)
SELECT l.idlista, c.idcancion
FROM temp_cancion t INNER JOIN lista l
ON t.lista = l.nombre INNER JOIN cancion c 
ON t.nombre = c.nombre INNER JOIN album a
ON t.album = a.nombre AND c.album = a.idalbum;

-- Ciudad 
INSERT INTO ciudad(nombre)
SELECT DISTINCT ciudad
FROM temp_factura
UNION
SELECT ciudad
FROM temp_empleado;

-- Empleado
INSERT INTO empleado(idempleado,nombre, apellido,jefe,fechanacimiento,fechacontratacion,direccion,ciudad,telefono,email)
SELECT t.noempleado,t.nombre,t.apellido,t.jefe,t.fechanacimiento,t.fechacontratacion,t.direccion,c.idciudad,t.telefono,t.email
FROM TEMP_EMPLEADO t INNER JOIN ciudad c 
ON t.ciudad = c.nombre;

-- Cliente
INSERT INTO cliente(nombre,apellido,direccion,ciudad,telefono,email,soporte)
SELECT t.nombrecliente, t.apellidocliente, t.direccion, c.idciudad, t.telefono, t.email, t.soporte
FROM temp_factura t INNER JOIN ciudad c
ON t.ciudad = c.nombre
GROUP BY t.nombrecliente, t.apellidocliente, t.direccion, c.idciudad, t.telefono, t.email, t.soporte; 

-- Factura
INSERT INTO factura(idfactura,total,fecha,cliente)
SELECT t.nofactura, t.total, t.fecha, c.idcliente
FROM temp_factura t INNER JOIN cliente c
ON t.nombrecliente = c.nombre AND t.apellidocliente = c.apellido
GROUP BY  t.nofactura, t.total, t.fecha, c.idcliente;

-- Detalle Factura
INSERT INTO detallefactura (idfactura,idcancion)
SELECT t.nofactura, c.idcancion
FROM temp_factura t, cancion c, album a, artista ar
WHERE c.nombre = t.cancion
AND a.nombre = t.album
AND c.album = a.idalbum
AND ar.nombre = t.artista
AND c.artista = ar.idartista
ORDER BY t.nofactura;

-- COUNT temporales
SELECT * FROM TEMP_CANCION;
SELECT COUNT(*) FROM TEMP_CANCION;
SELECT * FROM TEMP_FACTURA;
SELECT COUNT(*) FROM TEMP_FACTURA;
SELECT * FROM TEMP_EMPLEADO;
SELECT COUNT(*) FROM TEMP_EMPLEADO;

-- Count reales
SELECT COUNT(*) FROM album;
SELECT COUNT(*) FROM artista;
SELECT COUNT(*) FROM cancion;
SELECT COUNT(*) FROM cliente;
SELECT COUNT(*) FROM compositor;
SELECT COUNT(*) FROM empleado;
SELECT COUNT(*) FROM factura;
SELECT COUNT(*) FROM genero;
SELECT COUNT(*) FROM lista;
SELECT COUNT(*) FROM tipoarchivo;
SELECT COUNT(*) FROM detallefactura;
SELECT COUNT(*) FROM detallelista;