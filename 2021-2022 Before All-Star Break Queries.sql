--- 2021-2022 Before All-Star Break Queries---
SELECT *
FROM all_star_break_2022;

--- Win/Loss Record---
SELECT team, COUNT(CASE WHEN win_losses = 'W' THEN 1 END) AS win,
COUNT(CASE WHEN win_losses = 'L' THEN 1 END) AS loss
FROM all_star_break_2022
GROUP BY team;

SELECT team,game_dates, win_losses, COUNT(CASE WHEN win_losses = 'W' THEN 1 END) OVER (PARTITION BY team ORDER BY game_dates)
FROM all_star_break_2022;

--- Win Percentage For Each Team ---
WITH t1 AS (
SELECT team, COUNT(win_losses) win
FROM all_star_break_2022
WHERE win_loss = 'W'	
GROUP BY team	
)

SELECT t1.team teams, (t1.win * 100.0 /COUNT(a.game_dates)) games
FROM t1
JOIN all_star_break_2022 a
ON t1.team = a.team
GROUP BY t1.team, t1.win
ORDER BY games DESC;

--- Number Of Overtime Games Each Team Played---
SELECT team, COUNT(*) num_overtime_games
FROM all_star_break_2022
WHERE minute > 240
GROUP BY team
ORDER BY num_overtime_games DESC;

--- Possessions: Estimates number of possessions a team has---
--- 0.96*[(FGA)+(TOV)+0.44*(FTA)-(OReb)]---
SELECT team, (.96*((SUM(fgas) + SUM(turnover) + (.44*(SUM(ftas)))) - SUM(orebs))) possessions
FROM all_star_break_2022
GROUP BY team
ORDER BY possessions DESC;

--- Teams With The Best Average Plus/Minus Rating---
SELECT team, AVG(plus_minuses) avg_plus_minus
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_plus_minus DESC;

SELECT team, COUNT(CASE WHEN win_losses = 'W' THEN 1 END) AS win,
AVG(plus_minuses) avg_plus_minus
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_plus_minus DESC;

---Teams With The Best Assist/Turnover Ratio---
SELECT team, (SUM(asts)/SUM(turnover)) ast_tov_ratio
FROM all_star_break_2022
GROUP BY team
ORDER BY ast_tov_ratio DESC;

--- The Win/Loss Record Of Teams With The Most Turnovers ---
SELECT team, COUNT(CASE WHEN win_losses = 'W' THEN 1 END) AS win,
COUNT(CASE WHEN win_losses = 'L' THEN 1 END) AS loss, AVG(turnover) avg_turnovers
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_turnovers DESC;

SELECT team, COUNT(CASE WHEN win_losses = 'W' THEN 1 END) AS win,
COUNT(CASE WHEN win_losses = 'L' THEN 1 END) AS loss, SUM(turnover) sum_turnovers
FROM all_star_break_2022
GROUP BY team
ORDER BY sum_turnovers DESC;

--- Turnover Percentage: Percent of a team's possessions that ends in turnovers---
--- TOV / (FGA + .475*FTA + AST + TOV)---
SELECT team, SUM(turnover) *100/(SUM(fgas) + (.44*SUM(ftas)) + SUM(turnover)) tov_percentage
FROM all_star_break_2022
ORDER BY tov_percentage DESC;


--- Steals vs Fouls---
SELECT team, SUM(stls) total_steals, SUM(foul) total_fouls
FROM all_star_break_2022
GROUP BY team;

SELECT team, AVG(stls) total_steals, AVG(foul) total_fouls
FROM all_star_break_2022
GROUP BY team;

--- Avergae Blocks---
SELECT team, AVG(blocks)total_blocks
FROM all_star_break_2022
GROUP BY team;

--- The Percentage of Offensive Rebounds That Contribute To The Overall Teams Rebound ---
SELECT team, (SUM(orebs)*100/SUM(rebs)) oreb_percentage
FROM all_star_break_2022
GROUP BY team
ORDER BY oreb_percentage;

---The Percentage of Defensive Rebounds That Contribute To The Overall Teams Rebound---
SELECT team, (SUM(drebs)*100/SUM(rebs)) dreb_percentage
FROM all_star_break_2022
GROUP BY team
ORDER BY dreb_percentage DESC;