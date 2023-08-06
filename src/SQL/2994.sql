SELECT
  doctors.name,
  ROUND(SUM((attendances.hours * 150.0) * (1 + work_shifts.bonus * 0.01)), 1) AS "salary"
FROM
  doctors
  INNER JOIN attendances ON doctors.id = attendances.id_doctor
  INNER JOIN work_shifts ON work_shifts.id = attendances.id_work_shift
GROUP BY
  doctors.id
ORDER BY
  "salary" DESC;