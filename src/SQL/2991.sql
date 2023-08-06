SELECT
  departamento.nome AS "Nome Departamento",
  COUNT(departamento.nome) AS "Numero de Empregados",
  ROUND(AVG(brutes.brute - discounts.total_desc), 2) AS "Media Salarial",
  ROUND(MAX(brutes.brute - discounts.total_desc), 2) AS "Maior Salario",
  (
    CASE
      WHEN MIN(brutes.brute - discounts.total_desc) = 0 THEN 0
      ELSE ROUND(MIN(brutes.brute - discounts.total_desc), 2)
    END
  ) AS "Menor Salario"
FROM departamento
  INNER JOIN empregado ON departamento.cod_dep = empregado.lotacao
  INNER JOIN (
    SELECT
      empregado.matr,
      COALESCE(SUM(vencimento.valor), 0) AS brute
    FROM empregado
    LEFT JOIN emp_venc USING (matr)
    LEFT JOIN vencimento USING (cod_venc)
    GROUP BY empregado.matr
  ) AS brutes USING (matr)
  INNER JOIN (
    SELECT
      empregado.matr,
      COALESCE(SUM(desconto.valor), 0) AS total_desc
    FROM empregado
    LEFT JOIN emp_desc USING (matr)
    LEFT JOIN desconto USING (cod_desc)
    GROUP BY empregado.matr
  ) AS discounts USING (matr)
GROUP BY
  departamento.cod_dep,
  departamento.nome
ORDER BY
  AVG(brutes.brute - discounts.total_desc) DESC;