SELECT
	departamento.nome AS "Departamento",
	empregado.nome AS "Empregado",
	(CASE WHEN brutes.brute = 0 THEN 0 ELSE ROUND(brutes.brute, 2) END) AS "Salario Bruto",
	(CASE WHEN discounts.total_desc = 0 THEN 0 ELSE ROUND(discounts.total_desc, 2) END) AS "Total Desconto",
	(CASE WHEN (brutes.brute - discounts.total_desc) = 0 THEN 0 ELSE ROUND(brutes.brute - discounts.total_desc, 2) END) AS "Salario Liquidoaws"
FROM empregado
INNER JOIN departamento ON departamento.cod_dep = empregado.lotacao
INNER JOIN (
  SELECT empregado.matr, COALESCE(SUM(vencimento.valor), 0) AS brute
  FROM empregado
  LEFT JOIN emp_venc USING (matr)
  LEFT JOIN vencimento USING (cod_venc)
  GROUP BY empregado.matr
) AS brutes USING (matr)

INNER JOIN (
  SELECT empregado.matr, COALESCE(SUM(desconto.valor), 0) AS total_desc
  FROM empregado
  LEFT JOIN emp_desc USING (matr)
  LEFT JOIN desconto USING (cod_desc)
  GROUP BY empregado.matr
) AS discounts USING (matr)

GROUP BY
	empregado.matr,
	departamento.nome,
	empregado.nome,
	brutes.brute,
	discounts.total_desc
ORDER BY
	(brutes.brute - discounts.total_desc) DESC,
	empregado.nome DESC;