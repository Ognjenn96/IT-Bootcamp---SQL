---1. Преглед сезоне: број утакмица и голова, просечан број голова по утакмици, удео победа домаћина, нерешених и победа гостију.
SELECT season, COUNT(*) AS utakmice,
SUM(home_goals + away_goals) AS broj_golova,
ROUND(AVG(home_goals + away_goals), 2) AS prosek_golova,
SUM( CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS pobede_domacina,
SUM( CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END) AS nereseno,
SUM( CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END) AS pobede_gostiju
FROM workspace.default.matches
WHERE status = 'played'
GROUP BY season;


---2 По месецима: број утакмица и голова по месецима, и просечан број голова по утакмици у сваком месецу. Који месец се издваја?
SELECT
YEAR(kickoff_ts) AS godina,
MONTH(kickoff_ts) AS mesec,
COUNT(*) AS broj_utakmica,
SUM(home_goals + away_goals) AS golovi,
AVG(home_goals + away_goals) AS prosecni_golovi
FROM workspace.default.matches
WHERE status = 'played'
GROUP BY YEAR(kickoff_ts) , MONTH(kickoff_ts);

---3 Публика: просечна посета и попуњеност по стадиону; утакмице без податка о посети и утакмица без публике.

SELECT s.stadium_name,
ROUND(AVG(m.attendance),2) AS prosecna_poseta,
AVG(m.attendance)*  100.0 / s.capacity AS popunjenost
FROM workspace.default.matches m
JOIN workspace.default.stadiums s
ON m.stadium_id = s.stadium_id
WHERE m.status = 'played'
AND s.capacity > 0
GROUP BY s.stadium_name , s.capacity;


