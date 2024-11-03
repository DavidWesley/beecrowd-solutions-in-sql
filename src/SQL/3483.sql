WITH ranked_cities AS (
    SELECT 
        city_name,
        population,
        ROW_NUMBER() OVER (ORDER BY population DESC) AS rn,
        COUNT(*) OVER () AS total
    FROM cities
)
SELECT 
    city_name,
    population
FROM ranked_cities
WHERE rn = 2 OR rn = total - 1;