
-------2. Која су три стадиона са највећом просечном посетом у сезони 2024/25

WITH poseta AS (
SELECT s.stadium_name,
AVG(m.attendance) AS prosek
FROM matches m
JOIN stadiums s ON m.stadium_id = s.stadium_id
WHERE m.season = '2024/25'
AND m.status = 'played'
GROUP BY s.stadium_name)

SELECT stadium_name, prosek,
ROW_NUMBER() OVER (ORDER BY prosek DESC) AS rang
FROM poseta
ORDER BY rang
LIMIT 3;

---4. За домаће утакмице клуба Northport United у сезони 2024/25 прикажите посету и промену у односу на претходну домаћу утакмицу. Где је највећи пад?

SELECT m.kickoff_ts, m.attendance,
LAG(m.attendance) OVER (ORDER BY m.kickoff_ts) AS prethodna_poseta,
m.attendance - LAG(m.attendance) OVER (ORDER BY m.kickoff_ts) AS promena
FROM matches m
JOIN teams t ON m.home_team_id = t.team_id
WHERE t.team_name = 'Northport United'
AND m.season = '2024/25'
AND m.status = 'played'
ORDER BY promena ASC NULLS LAST;