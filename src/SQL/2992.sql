WITH divisao_avg_salaries AS (
	SELECT
		departamento.nome AS "departamento",
		departamento.cod_dep,
		divisao.nome AS "divisao",
		ROUND(AVG(brutes.brute - discounts.total_desc), 2) AS "media"
	FROM departamento
  INNER JOIN divisao USING (cod_dep)
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
	GROUP BY
		divisao.cod_divisao,
		departamento.cod_dep,
		divisao.nome,
		departamento.nome
	ORDER BY
		AVG(brutes.brute - discounts.total_desc) DESC
)

SELECT
	T.departamento,
	T.divisao,
	T.media
FROM
(
	(SELECT * FROM divisao_avg_salaries AS das1 WHERE das1.cod_dep = 1 ORDER BY das1.media DESC LIMIT 1) UNION ALL
	(SELECT * FROM divisao_avg_salaries AS das2 WHERE das2.cod_dep = 2 ORDER BY das2.media DESC LIMIT 1) UNION ALL
	(SELECT * FROM divisao_avg_salaries AS das3 WHERE das3.cod_dep = 3 ORDER BY das3.media DESC LIMIT 1)
) T
ORDER BY
	T.media DESC