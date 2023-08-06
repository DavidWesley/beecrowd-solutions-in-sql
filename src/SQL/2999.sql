SELECT
  empregado.nome,
  ROUND(brutes.brute - discounts.total_desc, 2) AS "salario"
FROM departamento, divisao
INNER JOIN empregado ON divisao.cod_divisao = empregado.lotacao_div
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

WHERE
  (brutes.brute - discounts.total_desc) >= 8000
GROUP BY
  divisao.cod_divisao,
  empregado.nome,
  brutes.brute,
  discounts.total_desc
HAVING
  (brutes.brute - discounts.total_desc) >= AVG(brutes.brute - discounts.total_desc)
ORDER BY
  divisao.cod_divisao ASC;