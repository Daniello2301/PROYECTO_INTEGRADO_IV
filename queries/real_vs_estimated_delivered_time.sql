-- TODO: Esta consulta devolverá una tabla con las diferencias entre los tiempos 
-- reales y estimados de entrega por mes y año. Tendrá varias columnas: 
-- month_no, con los números de mes del 01 al 12; month, con las primeras 3 letras 
-- de cada mes (ej. Ene, Feb); Year2016_real_time, con el tiempo promedio de 
-- entrega real por mes de 2016 (NaN si no existe); Year2017_real_time, con el 
-- tiempo promedio de entrega real por mes de 2017 (NaN si no existe); 
-- Year2018_real_time, con el tiempo promedio de entrega real por mes de 2018 
-- (NaN si no existe); Year2016_estimated_time, con el tiempo promedio estimado 
-- de entrega por mes de 2016 (NaN si no existe); Year2017_estimated_time, con 
-- el tiempo promedio estimado de entrega por mes de 2017 (NaN si no existe); y 
-- Year2018_estimated_time, con el tiempo promedio estimado de entrega por mes 
-- de 2018 (NaN si no existe).
-- PISTAS:
-- 1. Puedes usar la función julianday para convertir una fecha a un número.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Considera tomar order_id distintos.

WITH delivery_times AS (
    SELECT 
        JULIANDAY(  oo.order_delivered_customer_date) - JULIANDAY( oo.order_purchase_timestamp ) AS real_time,
        JULIANDAY( oo.order_estimated_delivery_date) - JULIANDAY(  oo.order_purchase_timestamp) AS estimated_time,
        STRFTIME('%m', oo.order_purchase_timestamp) AS month_no,
        CASE STRFTIME('%m', oo.order_purchase_timestamp)
            WHEN '01' THEN 'Ene' WHEN '02' THEN 'Feb' WHEN '03' THEN 'Mar'
            WHEN '04' THEN 'Abr' WHEN '05' THEN 'May' WHEN '06' THEN 'Jun'
            WHEN '07' THEN 'Jul' WHEN '08' THEN 'Ago' WHEN '09' THEN 'Sep'
            WHEN '10' THEN 'Oct' WHEN '11' THEN 'Nov' WHEN '12' THEN 'Dic'
        END AS month,
        STRFTIME('%Y', oo.order_purchase_timestamp) AS year_date
    FROM olist_orders oo
    WHERE oo.order_status = 'delivered' AND oo.order_delivered_customer_date IS NOT NULL
)
SELECT 
    d.month_no,
    d.month,
    -- Real delivery times
    AVG(CASE WHEN d.year_date = '2016' THEN d.real_time END) AS Year2016_real_time,
    AVG(CASE WHEN d.year_date = '2017' THEN d.real_time END) AS Year2017_real_time,
    AVG(CASE WHEN d.year_date = '2018' THEN d.real_time END) AS Year2018_real_time,
    -- Estimated delivery times
    AVG(CASE WHEN d.year_date = '2016' THEN d.estimated_time END) AS Year2016_estimated_time,
    AVG(CASE WHEN d.year_date = '2017' THEN d.estimated_time END) AS Year2017_estimated_time,
    AVG(CASE WHEN d.year_date = '2018' THEN d.estimated_time END) AS Year2018_estimated_time
FROM delivery_times d
GROUP BY d.month_no, d.month
HAVING d.month_no IS NOT NULL
ORDER BY d.month_no;