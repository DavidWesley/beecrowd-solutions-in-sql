SELECT
  packages.year,
  senderTB.name AS "sender",
  receiverTB.name AS "receiver"
FROM
  packages
  LEFT JOIN users senderTB ON packages.id_user_sender = senderTB.id
  LEFT JOIN users receiverTB ON packages.id_user_receiver = receiverTB.id
WHERE
  (packages.color = 'blue' OR packages.year = 2015)
  AND 'Taiwan' NOT IN (senderTB.address, receiverTB.address)
ORDER BY
  packages.year DESC;