SELECT
	name,
	(victories + draws + defeats) AS matches,
	victories,
	defeats,
	draws,
	(3 * victories + draws) AS score
FROM
(
	SELECT
		T.name,
		COUNT(CASE WHEN (M.team_1_goals > M.team_2_goals AND T.id = M.team_1) OR (M.team_2_goals > M.team_1_goals AND T.id = M.team_2) THEN 1 END) AS victories,
		COUNT(CASE WHEN (M.team_1_goals < M.team_2_goals AND T.id = M.team_1) OR (M.team_2_goals < M.team_1_goals AND T.id = M.team_2) THEN 1 END) AS defeats,
		COUNT(CASE WHEN (M.team_1_goals = M.team_2_goals AND T.id IN (M.team_1, M.team_2)) THEN 1 END) as draws
	FROM
		matches AS M, teams AS T
	GROUP BY
    T.name
) AS board
ORDER BY
	score DESC,
	name ASC;