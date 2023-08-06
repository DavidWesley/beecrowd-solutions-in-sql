SELECT
  name AS "type",
  CASE
    WHEN TYPE = 'A' THEN 20.0
    WHEN TYPE = 'B' THEN 70.0
    WHEN TYPE = 'C' THEN 530.5
    ELSE 0
  END AS "price"
FROM
  products
ORDER BY
  "price" ASC,
  id DESC;