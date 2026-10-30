--- DEO A Zadatak 1 Колико утакмица је одиграно у фебруару 2025?

SELECT COUNT(*)
FROM matches_flat
WHERE kickoff_ts >= '2025-02-01'
AND kickoff_ts < '2025-03-01'
AND status = 'played'; ------RESENJE JE 40

---Zadatak 2 Који стадион има највећи капацитет, а који је највећи стадион неког клуба?

SELECT s.stadium_name, s.capacity,
  t.team_name

FROM stadiums s
JOIN teams t 
ON s.stadium_id = t.stadium_id
ORDER BY s.capacity DESC
LIMIT 1;
 ----RESENJE Harbourside Park	52000	Northport United

 ---Zadatak 3 Колико играча у лиги има српско држављанство (nationality = 'Serbia')?

SELECT COUNT(*)
FROM players
WHERE nationality = 'Serbia';     ---42

--- Zadatak 4 Колико утакмица је завршено резултатом 1:1?

SELECT COUNT(*)
FROM matches
WHERE home_goals = 1
AND away_goals = 1; ----94

---Zadatak  5 Колика је просечна посета по сезони?

SELECT season,
AVG(attendance) AS prosecna_poseta
FROM matches_flat
GROUP BY season; --- 2023/24	24252.951742627345
                    --- 2024/25	24199.493261455525


--- Zadatak 6 Колико голова је дато из пенала по сезони
 
 
 Select m.season, COUNT(*) AS golovi_iz_penala
 From match_events e
 Join matches m
 ON e.match_id = m.match_id
 WHERE m.season IN('2023/24' , '2024/25')
 AND e.event_type = 'penalty_goal'
 GROUP BY m.season;   ---2023/24	104
                      ---   2024/25	109

--- Zadatak 7 Колико различитих играча је дало бар један гол у сезони 2024/25?

SELECT e.player_id, COUNT(*) AS strelci
FROM workspace.default.match_events e --- iz nekog razloga nije htelo da mi prihvati u ovom redu samo matches_event e kaou proslom zadatkunego tek kad sam sve ovo uneo 
Join matches AS m
ON e.match_id = m.match_id
WHERE season = '2024/25'
AND e.event_type IN ('goal','penalty_goal')
GROUP BY e.player_id
HAVING COUNT(*) >= 1; ---- 308

---Zadatak 8 Који судија је највише пута судио утакмице клуба Northport United?

SELECT referee_name,COUNT(*) AS broj_utakmica
FROM matches_flat
WHERE home_team = 'Northport United'
OR away_team = 'Northport United'
GROUP BY referee_name
ORDER BY broj_utakmica DESC
limit 1; --- Peter Lindgren	9

--- Zadatak 9 Који судија је у сезони 2024/25 имао највећи удео утакмица у којима је досуђен бар један пенал, дат или промашен

SELECT m.referee_id,
COUNT(DISTINCT e.match_id) * 100 /
COUNT(DISTINCT m.match_id) AS udeo
FROM workspace.default.matches m 
LEFT JOIN workspace.default.match_events e
ON m.match_id = e.match_id
AND e.event_type IN ('penalty_goal' , 'penalty_miss')
WHERE m.season = '2024/25'
GROUP BY m.referee_id
ORDER BY udeo DESC          -------------probao sam order by pre group by ali iz nekog razloga ne radi
LIMIT 1;


