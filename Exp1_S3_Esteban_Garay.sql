
select *from cliente;
--caso numero 1
select 
TO_CHAR (numrut_cli, '99G999G999')|| '-' || dvrut_cli as "RUT cliente", 
INITCAP (nombre_cli || ' ' || appaterno_cli || ' ' || apmaterno_cli) as "Nombre Completo Cliente",
INITCAP (direccion_cli) as "Dirección CLiente", 
TO_CHAR (renta_cli,'$9G999G999') as "Renta Cliente", 
'0' || SUBSTR (celular_cli, 1,1) || '-' || 
SUBSTR (celular_cli, 2,3) || '-' || 
SUBSTR (celular_cli, 5,4 ) as "Celular Cliente", 
CASE 
    WHEN renta_cli > 500000 then 'TRAMO 1'
    when renta_cli between 400000 and 500000 then 'TRAMO 2'
    when renta_cli between 200000 and 399999 then 'TRAMO 3'
    when renta_cli < 200000 then 'TRAMO 4'
    else 'SIN CLASIFICAR'
    end as "Tramo Renta"
from cliente
where celular_cli is not null and renta_cli BETWEEN &min_renta AND &max_renta
order by "Nombre Completo Cliente" asc;

 
--caso 2 final
   select 
   id_categoria_emp as "CODIGO_CATEGORIA",
  
   case 
    when id_categoria_emp = 1 then 'Gerente'
    when id_categoria_emp = 2 then 'Supervisor'
    when id_categoria_emp = 3 then 'Ejecutivo de arriendo'
    when id_categoria_emp = 4 then 'Auxiliar'
    else 'sin calificar'
    end as "DESCRIPCION_CATEGORIA",
    count (numrut_emp)as "CANTIDAD_EMPLEADOS",
case 
    when id_sucursal = 10 then 'Sucursal Las Condes'
    when id_sucursal = 20 then 'Sucursal Santiago Centro'
    when id_sucursal = 30 then 'Sucursal Providencia'
    when id_sucursal = 40 then 'Sucursal Vitacura'
    else 'sin calificar' 
    end as "SUCURSAL",
    --ROUND(avg(sueldo_emp)) as "SUELDO PROMEDIO"
   TO_CHAR(ROUND(AVG(sueldo_emp)), '$999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''') AS "SUELDO PROMEDIO"

    from empleado
    having  ROUND(avg(sueldo_emp))> &sueldo_minimo
   group by id_categoria_emp,
   id_sucursal
   order by id_categoria_emp,
   id_sucursal,"CANTIDAD_EMPLEADOS" ;
    
   
  --ejercicio 3 
  
SELECT 
    p.id_tipo_propiedad AS "CODIGO_TIPO_PROPIEDAD",

    CASE 
        WHEN UPPER(p.id_tipo_propiedad) = 'A' THEN 'CASA'
        WHEN UPPER(p.id_tipo_propiedad) = 'B' THEN 'DEPARTAMENTO'
        WHEN UPPER(p.id_tipo_propiedad) = 'C' THEN 'LOCAL'
        WHEN UPPER(p.id_tipo_propiedad) = 'D' THEN 'PARCELA SIN CASA'
        WHEN UPPER(p.id_tipo_propiedad) = 'E' THEN 'PARCELA CON CASA'
        ELSE 'OTRO'
    END AS "DESCRIPCION_TIPO_PROPIEDAD",

    COUNT(p.nro_propiedad) AS "TOTAL_PROPIEDADES",

    -- Promedio de arriendo (formateado con $ y puntos)
    TO_CHAR(ROUND(AVG(NVL(p.valor_arriendo,0))), '$999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''') AS "PROMEDIO_ARRIENDO",

    -- Promedio de superficie
    TO_CHAR(ROUND(AVG(NVL(p.superficie,0))), '999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''') AS "PROMEDIO_SUPERFICIE",

    -- Promedio de valor de arriendo por m2
    TO_CHAR(ROUND(AVG(NVL(p.valor_arriendo,0) / NULLIF(p.superficie,0))), '$999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''') AS "ARRIENDO_POR_M2",

    -- Clasificación según el valor promedio del arriendo por m2
    CASE 
        WHEN AVG(NVL(p.valor_arriendo,0) / NULLIF(p.superficie,0)) < 5000 THEN 'ECONÓMICO'
        WHEN AVG(NVL(p.valor_arriendo,0) / NULLIF(p.superficie,0)) BETWEEN 5000 AND 10000 THEN 'MEDIO'
        WHEN AVG(NVL(p.valor_arriendo,0) / NULLIF(p.superficie,0)) > 10000 THEN 'ALTO'
        ELSE 'SIN CLASIFICAR'
    END AS "CATEGORIA_ARRIENDO",

    -- Fecha de ejecución del reporte
    TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS "FECHA_REPORTE"

FROM 
    propiedad p
GROUP BY 
    p.id_tipo_propiedad
HAVING 
    AVG(NVL(p.valor_arriendo,0) / NULLIF(p.superficie,0)) > &VALOR_PROMEDIO_MINIMO
ORDER BY 
    AVG(NVL(p.valor_arriendo,0) / NULLIF(p.superficie,0)) DESC;







