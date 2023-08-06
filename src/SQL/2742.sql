SELECT
	life_registry.name,
	ROUND(life_registry.omega * 1.618, 3) AS "Fator N"
FROM
	dimensions
	INNER JOIN life_registry ON dimensions.id = life_registry.dimensions_id
WHERE
  LOWER(life_registry.name) LIKE 'richard%'
	AND  dimensions.name IN ('C774', 'C875')
ORDER BY
	life_registry.omega ASC;