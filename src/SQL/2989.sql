SELECT
	departamento.nome AS "departamento",
	divisao.nome AS "divisao",
	ROUND(AVG(brutes.brute - discounts.total_desc), 2) AS "media",
	ROUND(MAX(brutes.brute - discounts.total_desc), 2) AS "maior"
FROM
	departamento
	INNER JOIN divisao USING (cod_dep)
	INNER JOIN empregado ON divisao.cod_divisao = empregado.lotacao_div
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
	divisao.cod_divisao,
	divisao.nome,
	departamento.nome
ORDER BY
	AVG(brutes.brute - discounts.total_desc) DESC;