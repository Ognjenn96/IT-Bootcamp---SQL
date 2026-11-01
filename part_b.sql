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

----4 Судије: за сваког судију број утакмица и картони по утакмици
  
SELECT
m.referee_name,
COUNT(DISTINCT m.match_id) AS broj_utakmica,
SUM(home_yellow_cards + away_yellow_cards + home_red_cards + away_red_cards) AS broj_kartona,
AVG(home_yellow_cards + away_yellow_cards + home_red_cards + away_red_cards) AS kartoni_po_utakmici
FROM matches_flat m
JOIN matches e
ON m.match_id = e.match_id
WHERE e.status = 'played'
GROUP BY m.referee_name;

---5.Играчи:пет најбољих стрелаца и пет најбољих асистената.
SELECT p.first_name,  p.last_name,
COUNT(*) AS broj_golova
FROM match_events e
JOIN players p
ON e.player_id = p.player_id
WHERE e.event_type IN ('goal', 'penalty_goal')
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY broj_golova DESC
LIMIT 5;          -------- Strelci

SELECT p.first_name, p.last_name,
COUNT(*) AS broj_asistencija
FROM match_events e
JOIN players p
ON e.related_player_id = p.player_id
WHERE e.event_type = 'goal'
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY broj_asistencija DESC
LIMIT 5;   ----Asistenti 

--- 6  Квалитет података: бар два проблема на која сте наишли у подацима (на пример утакмица чији резултат се не слаже са догађајима, догађаји са непостојећим играчем, дан без тренера), са упитима који их проналазе.

SELECT e.match_id, e.player_id, e.event_type
FROM match_events e
LEFT JOIN players p
ON e.player_id = p.player_id
WHERE p.player_id IS NULL;

SELECT player_id, first_name , last_name FROM players
ORDER BY player_id DESC;

SELECT player_id  FROM match_events
ORDER BY player_id DESC;

----- Pronasao sam 2 player_id ali igraci ne postoje



SELECT match_id, season, attendance
FROM matches
WHERE attendance IS NULL;
                    ---------- pronasao sam utakmice bez publike, ali to mozda i nije greska u podacima jer se u nizim ligama cesto desava da klubovi budu kaznjeni zabranom publike kad igraju na domacem terenu
