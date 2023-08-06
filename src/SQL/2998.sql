WITH
  balances AS (
    SELECT
      clients.name,
      operations.client_id,
      clients.investment,
      operations.month,
      (SUM(operations.profit) OVER (PARTITION BY operations.client_id ORDER BY operations.client_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) - clients.investment) AS "balance"
    FROM clients
    LEFT JOIN operations ON operations.client_id = clients.id
  ),

  paybacks AS (
    SELECT
      balances.client_id,
      balances.name,
      balances.investment,
      balances.balance,
      balances.month,
      ROW_NUMBER() OVER (PARTITION BY balances.client_id ORDER BY MONTH ASC) AS "rank"
    FROM balances
    WHERE balances.balance >= 0
)

SELECT
  name,
  investment,
  "month" AS "month_of_payback",
  balance AS "return"
FROM
  paybacks
WHERE
  rank = 1
ORDER BY
  "return" DESC;