--- 2022-2023 Before All-Star Break Queries---
SELECT *
FROM all_star_break_2023;

--- Win/Loss Record---
SELECT team, COUNT(CASE WHEN win_loss = 'W' THEN 1 END) AS win,
COUNT(CASE WHEN win_loss = 'L' THEN 1 END) AS loss
FROM all_star_break_2023
GROUP BY team;

SELECT team,game_date, win_loss, COUNT(CASE WHEN win_loss = 'W' THEN 1 END) OVER (PARTITION BY team ORDER BY game_date)
FROM all_star_break_2023;

--- Win Percentage For Each Team ---
WITH t1 AS (
SELECT team, COUNT(win_loss) win
FROM all_star_break_2023
WHERE win_loss = 'W'	
GROUP BY team	
)

SELECT t1.team teams, (t1.win * 100.0 /COUNT(a.game_date)) games
FROM t1
JOIN all_star_break_2023 a
ON t1.team = a.team
GROUP BY t1.team, t1.win
ORDER BY games DESC;

--- Number Of Overtime Games Each Team Played---
SELECT team, COUNT(*) num_overtime_games
FROM all_star_break_2023
WHERE minutes > 240
GROUP BY team
ORDER BY num_overtime_games DESC;

--- Possessions: Estimates number of possessions a team has---
--- 0.96*[(FGA)+(TOV)+0.44*(FTA)-(OReb)]---
SELECT team, (.96*((SUM(fga) + SUM(turnovers) + (.44*(SUM(fta)))) - SUM(oreb))) possessions
FROM all_star_break_2023
GROUP BY team
ORDER BY possessions DESC;

--- Teams With The Best Average Plus/Minus Rating---
SELECT team, AVG(plus_minus) avg_plus_minus
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_plus_minus DESC;

SELECT team, COUNT(CASE WHEN win_loss = 'W' THEN 1 END) AS win,
AVG(plus_minus) avg_plus_minus
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_plus_minus DESC;

---Teams With The Best Assist/Turnover Ratio---
SELECT team, (SUM(ast)/SUM(turnovers)) ast_tov_ratio
FROM all_star_break_2023
GROUP BY team
ORDER BY ast_tov_ratio DESC;

--- The Win/Loss Record Of Teams With The Most Turnovers ---
SELECT team, COUNT(CASE WHEN win_loss = 'W' THEN 1 END) AS win,
COUNT(CASE WHEN win_loss = 'L' THEN 1 END) AS loss, AVG(turnovers) avg_turnovers
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_turnovers DESC;

SELECT team, COUNT(CASE WHEN win_loss = 'W' THEN 1 END) AS win,
COUNT(CASE WHEN win_loss = 'L' THEN 1 END) AS loss, SUM(turnovers) sum_turnovers
FROM all_star_break_2023
GROUP BY team
ORDER BY sum_turnovers DESC;

--- Turnover Percentage: Percent of a team's possessions that ends in turnovers---
--- TOV / (FGA + .475*FTA + AST + TOV)---
SELECT team, SUM(turnovers) *100/(SUM(fga) + (.44*SUM(fta)) + SUM(turnovers)) tov_percentage
FROM all_star_break_2023
FROM all_star_break_2023
ORDER BY tov_percentage DESC;


--- Steals vs Fouls---
SELECT team, SUM(stl) total_steals, SUM(fouls) total_fouls
FROM all_star_break_2023
GROUP BY team;

SELECT team, AVG(stl) total_steals, AVG(fouls) total_fouls
FROM all_star_break_2023
GROUP BY team;

--- Avergae Blocks---
SELECT team, AVG(block)total_blocks
FROM all_star_break_2023
GROUP BY team;

--- The Percentage of Offensive Rebounds That Contribute To The Overall Teams Rebound ---
SELECT team, (SUM(oreb)*100/SUM(reb)) oreb_percentage
FROM all_star_break_2023
GROUP BY team
ORDER BY oreb_percentage;

---The Percentage of Defensive Rebounds That Contribute To The Overall Teams Rebound ---
SELECT team, (SUM(dreb)*100/SUM(reb)) dreb_percentage
FROM all_star_break_2023
GROUP BY team
ORDER BY dreb_percentage DESC;