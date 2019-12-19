-- CONSULTAS

-- 1. Top 10 canciones mas compradas
SELECT nombre, album, artista, compositor, total
FROM
(SELECT c.nombre,a.nombre AS album,ar.nombre AS artista, co.nombre as compositor, COUNT(c.idcancion) AS total
FROM detallefactura d INNER JOIN cancion c
ON d.idcancion = c.idcancion INNER JOIN album a
ON a.idalbum = c.album INNER JOIN artista ar
ON c.artista = ar.idartista LEFT JOIN compositor co
ON c.compositor = co.idcompositor 
GROUP BY c.nombre, a.nombre, ar.nombre, co.nombre
ORDER BY total DESC)
WHERE ROWNUM <= 10;

-- 2. Clientes que han comprado canciones de una lista determinada 
SELECT  c.nombre, c.apellido
FROM factura f INNER JOIN cliente c 
ON f.cliente = c.idcliente INNER JOIN detallefactura d 
ON d.idfactura = f.idfactura INNER JOIN cancion ca
ON d.idcancion = ca.idcancion INNER JOIN detallelista DL
ON dl.idcancion = ca.idcancion INNER JOIN lista l
ON l.idlista = dl.idlista
WHERE l.nombre = 'Grunge'
GROUP BY c.nombre, c.apellido;

-- 3. Top 10 de clientes que mas han gastado en la tienda
SELECT nombre, apellido, gastado
FROM
(SELECT c.nombre, c.apellido,SUM(f.total)AS gastado
FROM factura f INNER JOIN cliente c 
ON f.cliente = c.idcliente 
GROUP BY c.nombre, c.apellido
ORDER BY gastado DESC)
WHERE ROWNUM <= 10;

-- 4. Reporte de ventas totales por mes y anio
SELECT TO_CHAR(fecha,'MONTH') AS Mes, TO_CHAR(fecha,'YYYY') AS Anio, SUM(total) AS total
FROM factura 
GROUP BY TO_CHAR(fecha,'MONTH'), TO_CHAR(fecha,'YYYY') 
ORDER BY  anio; 

-- 5. Top 10 de ciudades que mas han gastadno en la tienda
SELECT nombre as ciudad, gastado
FROM
(SELECT ci.nombre,SUM(f.total)AS gastado
FROM factura f INNER JOIN cliente c 
ON f.cliente = c.idcliente INNER JOIN ciudad ci
ON ci.idciudad = c.ciudad
GROUP BY ci.nombre
ORDER BY gastado DESC)
WHERE ROWNUM <= 10;

-- 6. Porcetanje de canciones por letra que empiezan
SELECT SUBSTR(c.nombre,1,1) AS letra, ROUND((COUNT(SUBSTR(c.nombre,1,1))/(SELECT(SUM(COUNT(SUBSTR(c2.nombre,1,1)))) FROM cancion c2 GROUP BY SUBSTR(c.nombre,1,1)) *100),2) AS porcentaje
FROM cancion c 
GROUP BY SUBSTR(c.nombre,1,1)
ORDER BY SUBSTR(c.nombre,1,1);

-- 7. Porcentaje de ventas de cada ciudad, el 100 % representan todos los ingresos de la tienda
SELECT ci.nombre,SUM(f.total)AS gastado, ROUND((SUM(f.total)/(SELECT SUM(f2.total) FROM factura f2 )*100),2) AS porcentaje
FROM factura f  INNER JOIN cliente c 
ON f.cliente = c.idcliente INNER JOIN ciudad ci
ON ci.idciudad = c.ciudad
GROUP BY ci.nombre
ORDER BY gastado DESC;

-- 8. Mostrar el porcentaje de las categorías más vendidas de cada ciudad de la siguiente manera: Ciudad, Género, Porcentaje De Mercado. 
SELECT t1.ciudad, t3.genero , ROUND((t1.maximo/t2.total *100),2) AS porcentaje
FROM
(SELECT  ciudad, MAX(total) as maximo
FROM
(
SELECT ci.nombre AS ciudad, g.nombre AS genero,COUNT(g.idgenero) AS total
FROM factura f INNER JOIN  detallefactura d
ON f.idfactura = d.idfactura INNER JOIN cancion c
ON d.idcancion = c.idcancion INNER JOIN genero g 
ON c.genero = g.idgenero INNER JOIN cliente cl 
ON f.cliente = cl.idcliente INNER JOIN ciudad ci
ON cl.ciudad = ci.idciudad 
GROUP BY ci.nombre, g.nombre
ORDER BY ci.nombre,total DESC
) group by ciudad) T1 
INNER JOIN (SELECT ci2.nombre as aux, COUNT(g2.idgenero) AS total
FROM factura f2 INNER JOIN  detallefactura d2
ON f2.idfactura = d2.idfactura INNER JOIN cancion c2
ON d2.idcancion = c2.idcancion INNER JOIN genero g2 
ON c2.genero = g2.idgenero INNER JOIN cliente cl2 
ON f2.cliente = cl2.idcliente INNER JOIN ciudad ci2
ON cl2.ciudad = ci2.idciudad
GROUP BY ci2.nombre
ORDER BY ci2.nombre) T2 
ON T1.ciudad = T2.aux INNER JOIN (SELECT ci.nombre AS ciudad, g.nombre AS genero,COUNT(g.idgenero) AS total
FROM factura f INNER JOIN  detallefactura d
ON f.idfactura = d.idfactura INNER JOIN cancion c
ON d.idcancion = c.idcancion INNER JOIN genero g 
ON c.genero = g.idgenero INNER JOIN cliente cl 
ON f.cliente = cl.idcliente INNER JOIN ciudad ci
ON cl.ciudad = ci.idciudad 
GROUP BY ci.nombre, g.nombre
ORDER BY ci.nombre,total DESC) T3 
ON T1.ciudad = T3.ciudad AND T1.maximo = T3.total
ORDER BY t1.ciudad;

-- 9. Mostrar los clientes que hayan consumido más que el promedio que consumen una ciudad determinada. (se dará un nombre durante la calificación)
SELECT c.nombre, c.apellido, ROUND(AVG(f.total),2) AS promediocliente
FROM factura f INNER JOIN cliente c
ON f.cliente = c.idcliente 
GROUP BY c.nombre, c.apellido
HAVING AVG(f.total) > (
    SELECT ROUND(AVG(f.total),2) AS promediociudad
    FROM factura f INNER JOIN  cliente c
    ON f.cliente = c.idcliente LEFT JOIN ciudad ci
    ON c.ciudad = ci.idciudad
    WHERE ci.nombre = 'Prague'
    GROUP BY ci.nombre
);

-- 10. Mostrar el género que más compra cada cliente.
SELECT t1.nombre, t2.genero, t2.comprado
FROM
(SELECT id, nombre, MAX(COMPRADO) AS MAXI FROM (
SELECT c.idcliente AS id, c.nombre, c.apellido, g.nombre AS genero, COUNT(g.nombre) AS comprado
FROM factura f INNER JOIN detallefactura d
ON f.idfactura = d.idfactura INNER JOIN cliente c
ON f.cliente = c.idcliente INNER JOIN cancion ca
ON d.idcancion = ca.idcancion INNER JOIN genero g
ON ca.genero = g.idgenero
GROUP BY c.idcliente, c.nombre, c.apellido,g.nombre
ORDER BY c.nombre, comprado DESC) 
GROUP BY id, NOMBRE
ORDER BY nombre) T1 INNER JOIN
(SELECT c.idcliente AS id, c.nombre, c.apellido, g.nombre AS genero, COUNT(g.nombre) AS comprado
FROM factura f INNER JOIN detallefactura d
ON f.idfactura = d.idfactura INNER JOIN cliente c
ON f.cliente = c.idcliente INNER JOIN cancion ca
ON d.idcancion = ca.idcancion INNER JOIN genero g
ON ca.genero = g.idgenero
GROUP BY c.idcliente, c.nombre, c.apellido,g.nombre
ORDER BY c.nombre, comprado DESC) T2
ON T1.id = T2.id AND T1.maxi = T2.comprado;

-- 11. Mostrar los empleados con la cantidad de personas a cargo y su jefe inmediato.
 SELECT empleado, jefe, COUNT(nombre) AS clientes
 FROM(
 SELECT e.nombre AS empleado ,j.nombre as Jefe, c.nombre
 FROM empleado e LEFT JOIN empleado j
 ON e.jefe = j.idempleado LEFT JOIN cliente c 
 ON e.idempleado =  c.soporte) 
 GROUP BY empleado, jefe
 ORDER BY empleado;
 
-- 12. Top 5 de clientes que más compran de cada ciudad con el porcentaje que representan en esa ciudad.
SELECT ciudad, nombre, apellido, comprado
FROM(
    SELECT ciudad, MAX(compra) AS comprado 
    FROM(
        SELECT c.idcliente, c.nombre, c.apellido, ci.nombre as ciudad, SUM(f.total) AS compra
        FROM factura f INNER JOIN cliente c
        ON f.cliente = c.idcliente INNER JOIN ciudad ci
        ON c.ciudad = ci.idciudad
        GROUP BY c.idcliente, c.nombre, c.apellido,ci.nombre
        )
    GROUP BY ciudad
    ) T1 INNER JOIN  
        (SELECT c.idcliente AS id, c.nombre, c.apellido,ci.nombre as ciudad2, SUM(f.total) AS compra2
        FROM factura f INNER JOIN cliente c
        ON f.cliente = c.idcliente INNER JOIN ciudad ci
        ON c.ciudad = ci.idciudad
        GROUP BY c.idcliente, c.nombre, c.apellido,ci.nombre
        ORDER BY ci.nombre) T2 
    ON t1.ciudad = t2.ciudad2 AND t1.comprado = t2.compra2 
    ORDER BY t1.ciudad;
