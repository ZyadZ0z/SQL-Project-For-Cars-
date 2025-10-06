select * from cars_project.merc;
select * from cars_project.bmw;

describe cars_project.merc;
describe cars_project.bmw;


select distinct model
from cars_project.merc;
 
 
 
 select distinct model
from cars_project.bmw;

select 
count(distinct model )
from cars_project.bmw;

select 
count(distinct model )
from cars_project.merc;



-- //////////////////////////////////////////////////////////////////////////////////////////////////////// DATA CLEANING 


SELECT 
  COUNT(*) AS total,
  SUM(CASE WHEN year < 1900 OR year > EXTRACT(YEAR FROM CURRENT_DATE)+1 THEN 1 ELSE 0 END) AS bad_years,
  SUM(CASE WHEN price <= 0 OR price IS NULL THEN 1 ELSE 0 END) AS bad_prices,
  SUM(CASE WHEN mileage < 0 THEN 1 ELSE 0 END) AS negative_mileage
FROM cars_project.bmw;







SELECT 
  COUNT(*) AS total,
  SUM(CASE WHEN year < 1900 OR year > EXTRACT(YEAR FROM CURRENT_DATE)+1 THEN 1 ELSE 0 END) AS bad_years,
  SUM(CASE WHEN price <= 0 OR price IS NULL THEN 1 ELSE 0 END) AS bad_prices,
  SUM(CASE WHEN mileage < 0 THEN 1 ELSE 0 END) AS negative_mileage
FROM cars_project.merc;





-- avg price for each year 





SELECT
    year,
    COUNT(*) AS n,
    AVG(price) AS avg_price,
    (
        SELECT
            AVG(T2.price)
        FROM (
            SELECT
                T1.price,
                T1.year,
                
                ROW_NUMBER() OVER (PARTITION BY T1.year ORDER BY T1.price) as rn_asc,
                
                ROW_NUMBER() OVER (PARTITION BY T1.year ORDER BY T1.price DESC) as rn_desc
            FROM
                cars_project.bmw AS T1
            WHERE
                T1.year = T0.year 
        ) AS T2
       
        WHERE
            T2.rn_asc IN (T2.rn_desc, T2.rn_desc - 1, T2.rn_desc + 1)
    ) AS median_price
FROM
    cars_project.bmw AS T0
GROUP BY
    year
ORDER BY
    year;
    
    

SELECT
    year,
    COUNT(*) AS n,
    AVG(price) AS avg_price,
   
    (
        SELECT
            AVG(T2.price)
        FROM (
            SELECT
                T1.price,
                T1.year,
              
                ROW_NUMBER() OVER (PARTITION BY T1.year ORDER BY T1.price) as rn_asc,
                
                ROW_NUMBER() OVER (PARTITION BY T1.year ORDER BY T1.price DESC) as rn_desc
            FROM
                cars_project.merc AS T1
            WHERE
                T1.year = T0.year 
        ) AS T2
        
        WHERE
            T2.rn_asc IN (T2.rn_desc, T2.rn_desc - 1, T2.rn_desc + 1)
    ) AS median_price
FROM
    cars_project.merc AS T0
GROUP BY
    year
ORDER BY     year ; 


-- Fuel type frequency and percentage

SELECT fuelType, COUNT(*) AS cnt
FROM cars_project.merc
GROUP BY fuelType
ORDER BY cnt DESC;





SELECT fuelType, COUNT(*) AS cnt
FROM cars_project.bmw
GROUP BY fuelType
ORDER BY cnt DESC;

    
-- comparing Average price by Model and Year 


SELECT
  b.model,
  b.year,
  b.avg_price AS bmw_avg_price,
  m.avg_price AS mercedes_avg_price,
  (b.avg_price - m.avg_price) AS price_diff
FROM (
  SELECT model, year, AVG(price) AS avg_price
  FROM cars_project.bmw
  GROUP BY model, year
) b

LEFT JOIN (
  SELECT model, year, AVG(price) AS avg_price
  FROM cars_project.merc
  GROUP BY model, year
) m
ON b.model = m.model AND b.year = m.year

UNION ALL

SELECT
  m.model,
  m.year,
  b.avg_price AS bmw_avg_price,
  m.avg_price AS mercedes_avg_price,
  (b.avg_price - m.avg_price) AS price_diff
FROM (
  
  SELECT model, year, AVG(price) AS avg_price
  FROM cars_project.bmw
  GROUP BY model, year
) b

RIGHT JOIN (
   
  SELECT model, year, AVG(price) AS avg_price
  FROM cars_project.merc
  GROUP BY model, year
) m
ON b.model = m.model AND b.year = m.year
WHERE b.model IS NULL 

ORDER BY year DESC;








-- comparing General Price Distribution 
    
SELECT 'BMW' as brand, AVG(price) avg_price, STDDEV(price) sd_price FROM cars_project.bmw
UNION ALL
SELECT 'Mercedes' as brand, AVG(price), STDDEV(price) FROM cars_project.merc;
    
    
    
-- Arranging Models By price within each Year 

SELECT * , 
RANK() OVER ( partition by year ORDER BY AvG_price DESC) as  PRICE_RANK_in_Year 
FROM (
SELECT model ,
year , 
avg(price) as AvG_price 
from cars_project.bmw
group by 1 ,2
) as t
ORDER BY year DESC ,PRICE_RANK_in_Year;









-- Percentage Difference each Year For the market 



WITH b AS (
  SELECT year, AVG(price) avg_price FROM cars_project.bmw GROUP BY year
), m AS (
  SELECT year, AVG(price) avg_price FROM cars_project.merc GROUP BY year
)
SELECT b.year,
       b.avg_price AS bmw_avg,
       m.avg_price AS mercedes_avg,
       (b.avg_price - m.avg_price)/NULLIF(m.avg_price,0) * 100 AS pct_diff_vs_mercedes
FROM b
JOIN m USING (year)
ORDER BY b.year DESC;







-- Average price for the engine across 3 years 
select year,
      avg(AVG_price) over( order by year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_year_avg
from(
SELECT year,
avg(price) as AVG_price
FROM cars_project.bmw 
group by 1 
) as x 
order by 1 ;





-- bucketing for prices 




SELECT year,
  NTILE(10) OVER (ORDER BY price) AS decile,
  COUNT(*) AS cnt,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM cars_project.bmw
GROUP BY 1
ORDER BY decile;




-- find the model and year and calculate  who wins on price / milage 

SELECT 
b.model, 
b.year,
b.price AS bmw_price, 
m.price AS mercedes_price,
CASE
WHEN b.price < m.price THEN 'BMW cheaper'
WHEN b.price > m.price THEN 'Mercedes cheaper'
ELSE 'equal'
END AS who_cheaper
FROM (
  SELECT 
  model,
  year, 
  AVG(price) AS price 
  FROM cars_project.bmw
  GROUP BY 1, 2
) b
JOIN (
  SELECT 
  model, 
  year, 
  AVG(price) AS price 
  FROM cars_project.merc
  GROUP BY 1, 2
) m
ON b.model = m.model AND b.year = m.year;






--  compute mean and variance, then compute z-score between means


WITH stats AS (
  SELECT 'BMW' AS brand, AVG(price) mean, VAR_SAMP(price) var, COUNT(*) n FROM cars_project.bmw
  UNION ALL
  SELECT 'Mercedes', AVG(price), VAR_SAMP(price), COUNT(*) FROM cars_project.merc
)
SELECT
  (b.mean - m.mean) / SQRT(b.var/b.n + m.var/m.n) AS z_approx
FROM (SELECT * FROM stats WHERE brand='BMW') b, (SELECT * FROM stats WHERE brand='Mercedes') m;





-- Top 5 Models for each year by price 




SELECT 
year, 
model, 
price,
 rank_in_year
FROM (
  SELECT year, model, AVG(price) AS price,
         ROW_NUMBER() OVER (PARTITION BY year ORDER BY AVG(price) DESC) AS rank_in_year
  FROM cars_project.merc
  GROUP BY 1, 2
) t
WHERE rank_in_year <= 5
ORDER BY year DESC, rank_in_year
limit 5;




-- FOR B M W 

SELECT 
year, 
model, 
price,
rank_in_year
FROM (
  SELECT year, model, AVG(price) AS price,
         ROW_NUMBER() OVER (PARTITION BY year ORDER BY AVG(price) DESC) AS rank_in_year
  FROM cars_project.bmw
  GROUP BY year, model
) t
WHERE rank_in_year <= 5
ORDER BY year DESC, rank_in_year
limit 5;







-- Calculate the correlation between engine size and price per km




WITH features AS (
  SELECT 
    *,
    YEAR(CURDATE()) - year AS age,
    price / NULLIF(mileage, 0) AS price_per_km,
    CASE 
        WHEN price > (SELECT AVG(price) FROM cars_project.bmw) THEN 1 
        ELSE 0 
    END AS is_expensive
  FROM 
    cars_project.bmw
)
SELECT 
    (
        (COUNT(price_per_km) * SUM(engineSize * price_per_km)) - (SUM(engineSize) * SUM(price_per_km))
    ) / 
    (
        SQRT(
            (COUNT(price_per_km) * SUM(engineSize * engineSize) - POWER(SUM(engineSize), 2)) *
            (COUNT(price_per_km) * SUM(price_per_km * price_per_km) - POWER(SUM(price_per_km), 2))
        )
    ) AS corr_engine_priceperkm
FROM features
WHERE price_per_km IS NOT NULL;




