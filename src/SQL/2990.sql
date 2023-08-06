SELECT
  empregados.cpf,
  empregados.enome,
  departamentos.dnome
FROM
  empregados
  INNER JOIN departamentos USING (dnumero)
  INNER JOIN projetos USING (dnumero)
  LEFT JOIN trabalha ON trabalha.cpf_emp = empregados.cpf
WHERE
  trabalha.cpf_emp IS NULL
ORDER BY
  empregados.cpf;