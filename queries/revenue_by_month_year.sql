-- TODO: Esta consulta devolverá una tabla con los ingresos por mes y año.
-- Tendrá varias columnas: month_no, con los números de mes del 01 al 12;
-- month, con las primeras 3 letras de cada mes (ej. Ene, Feb);
-- Year2016, con los ingresos por mes de 2016 (0.00 si no existe);
-- Year2017, con los ingresos por mes de 2017 (0.00 si no existe); y
-- Year2018, con los ingresos por mes de 2018 (0.00 si no existe).
SELECT 
	STRFTIME('%m', oo.order_purchase_timestamp) as  	month_no
	, CASE STRFTIME('%m', oo.order_purchase_timestamp)
            WHEN '01' THEN 'Jan' 
            WHEN '02' THEN 'Feb' 
            WHEN '03' THEN 'Mar'
            WHEN '04' THEN 'Apr' 
            WHEN '05' THEN 'May' 
            WHEN '06' THEN 'Jun'
            WHEN '07' THEN 'Jul' 
            WHEN '08' THEN 'Aug' 
            WHEN '09' THEN 'Sep'
            WHEN '10' THEN 'Oct' 
            WHEN '11' THEN 'Nov' 
            WHEN '12' THEN 'Dec'
        END AS month
    , 	SUM( CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp ) = '2016' THEN oop.payment_value ELSE 0.00 END ) AS Year2016
    , 	SUM( CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp ) = '2017' THEN oop.payment_value ELSE 0.00 END ) AS Year2017
    , 	SUM( CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp ) = '2018' THEN oop.payment_value ELSE 0.00 END ) AS Year2018
FROM olist_orders oo 
JOIN olist_order_payments oop  ON oo.order_id  = oop.order_id
GROUP BY month_no
ORDER BY month_no;