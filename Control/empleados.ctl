OPTIONS (SKIP-1)
LOAD DATA
CHARACTERSET UTF8
INFILE '../Data/Empleados.csv'
INTO TABLE TEMP_EMPLEADO
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(
    noempleado,
    nombre, 
    apellido,
    jefe 		"CASE WHEN :jefe IN ('\\N') THEN NULL ELSE :jefe END",	
    fechanacimiento 	"TO_DATE(SUBSTR(:fechanacimiento,2,10),'YYYY-MM-DD')",
    fechacontratacion 	"TO_DATE(SUBSTR(:fechanacimiento,2,10),'YYYY-MM-DD')",
    direccion,
    ciudad,
    telefono,
    email
)
