-- 2 ѕроанализировать, какой период данных выгружен
SELECT MIN(o_date), MAX(o_date) FROM orders_20190822

-- 3 ѕосчитать кол-во строк, кол-во заказов и кол-во уникальных пользователей, кот совершали заказы.

SELECT COUNT(*) FROM orders_20190822 

SELECT COUNT(id_o) FROM orders_20190822

SELECT COUNT(DISTINCT user_id) FROM orders_20190822 

-- 4 ѕо годам посчитать средний чек, среднее кол-во заказов на пользовател€, сделать вывод , как измен€лись это показатели √од от года.

DROP TABLE IF EXISTS tmp_table

 CREATE  TABLE tmp_table 
 select YEAR(o_date) AS YEAR , AVG(PRICE) AS avg_cheque , COUNT(id_o)/ COUNT(distinct user_id) AS avg_orders  from orders_20190822 GROUP BY year(o_date) 

 SELECT (avg_cheque / (SELECT avg_cheque  FROM tmp_table WHERE YEAR = 2016)-1)*100 FROM tmp_table WHERE YEAR = 2017 
 
 -- ¬ывод  средний чек увеличилс€ на 14.449873925169632 %
 
 SELECT (avg_orders / (SELECT avg_orders  FROM tmp_table WHERE YEAR = 2016)-1)*100 FROM tmp_table WHERE YEAR = 2017 
 
 -- ¬ывод среднее кол-во заказов на пользовател€ уменьшилось на 9.93179000 %
 
 DROP TABLE IF EXISTS tmp_table
 
 -- 5 Ќайти кол-во пользователей, кот покупали в одном году и перестали покупать в следующем.
 
 select COUNT(distinct user_id) from orders_20190822 as U16 where YEAR(o_date)=2016 
and user_id not IN (select distinct user_id from orders_20190822 where YEAR(o_date)=2017)

-- 6 Ќайти ID самого активного по кол-ву покупок пользовател€.

select user_id, count(id_o) from orders_20190822 group by user_id order by COUNT(id_o) desc limit 1

-- 7 Ќайти коэффициенты сезонности по мес€цам.

DROP TABLE IF EXISTS t1

DROP TABLE IF EXISTS t2

create table t1
select YEAR(o_date) as year, MONTH(o_date) as month, count(id_o) as orders from orders_20190822
where YEAR(o_date) = 2016 group by YEAR(o_date), MONTH(o_date)

create table t2
select YEAR(o_date) as year, MONTH(o_date) as month, count(id_o) as orders from orders_20190822
where YEAR(o_date) = 2017 group by YEAR(o_date), MONTH(o_date)


select year, month, orders/ (select AVG(orders) from t1) FROM t1
union
select year, month, orders/ (select AVG(orders) from t2) FROM t2

DROP TABLE IF EXISTS t1

DROP TABLE IF EXISTS t2

