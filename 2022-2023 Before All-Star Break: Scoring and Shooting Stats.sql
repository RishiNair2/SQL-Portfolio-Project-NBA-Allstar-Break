--- 2022-2023 Before All-Star Break Queries---
--- Scoring/Shooting Stats---
SELECT *
FROM all_star_break_2023;

--- Possessions: Estimates number of possessions a team has---
--- 0.96*[(FGA)+(TOV)+0.44*(FTA)-(OReb)]---
SELECT team, (.96*((SUM(fga) + SUM(turnovers) + (.44*(SUM(fta)))) - SUM(oreb))) possessions
FROM all_star_break_2023
GROUP BY team
ORDER BY possessions DESC;

--- Effective Field Goal Percentage: Adjusts a player's or team's FG% for the fact that a 3 pointer is worth 1.5 times a standard FG----
-- (FG + .5 * 3P) / FGA---
SELECT t1.team, AVG(t1.efg) * 100 avg_efg
FROM(
SELECT team, ((fgm + (.5*tpm))/(fga)) efg
FROM all_star_break_2023) t1
GROUP BY t1.team
ORDER BY avg_efg DESC;

--- True Shooting Percentage: Adjusts standard FG% to include their FT%, encompasses all ways to score---
--- Pts / (2 * (FGA + .475 * FTA)) --- 
SELECT t1.team, AVG(ts_percentage) avg_ts_percentage
FROM(
SELECT team, (points *100/(2*(fga + .475*fta))) ts_percentage 
FROM all_star_break_2023) t1
GROUP BY t1.team
ORDER BY avg_ts_percentage DESC;

--- Offensive Efficiency Rating: number of points a team scores per 100 possessions.---
--- 100*(Points Scored / Possessions)---
SELECT team, ((100*SUM(points))/(SUM(fga) + (.44*SUM(fta)) + SUM(turnovers))) oer
FROM all_star_break_2023
GROUP BY team
ORDER BY oer DESC;

--- Teams That Averaged The Most Points Before The All-Star Break---
SELECT team, AVG(points) avg_points
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_points DESC;

SELECT team, game_date, AVG(points) OVER (PARTITION BY team ORDER BY game_date)
FROM all_star_break_2023;

--- 2 Point Field Goal Frequency: The percentage of team field goal attempts that are 2 point field goals  ---
--- (2FGA)/(FGA) ---
SELECT team, (SUM(fga)-SUM(tpa))*100/ SUM(fga) two_fg_frequency
FROM all_star_break_2023
GROUP BY team
ORDER BY two_fg_frequency DESC;

--- 2 Point Field Goal Percentage: The percentage of made two-point field goals---
SELECT team, (SUM(fgm)-SUM(tpm))*100/(SUM(fga)-SUM(tpa)) two_fg_percentage
FROM all_star_break_2023
GROUP BY team
ORDER BY two_fg_percentage DESC;

--- Teams That Attempted The Most 2 Point Field Goals---
SELECT t1.team, AVG(two_point_attempts) avg_two_point_attempts
FROM(
SELECT team, fga-tpa two_point_attempts
FROM all_star_break_2023) t1
GROUP BY t1.team
ORDER BY avg_two_point_attempts DESC;

SELECT t1.team, AVG(t1.two_point_attempts) OVER (PARTITION BY t1.team ORDER BY t1.game_date )
FROM(
SELECT team, game_date, fga-tpa two_point_attempts
FROM all_star_break_2023) t1

--- The Percentage of 2 Point Baskets That Contribute To The Overall Teams Points---
SELECT team, ((SUM(fgm)-SUM(tpm))*2)*100/SUM(points) two_points_scored
FROM all_star_break_2023
GROUP BY team
ORDER BY two_points_scored DESC;

--3 Point Field Goal Frequency: The percentage of team field goal attempts that are 2 point field goals  ---
--- (3FGA)/(FGA) ---
SELECT team, SUM(tpa)*100/ SUM(fga) three_point_fg_frequency
FROM all_star_break_2023
GROUP BY team
ORDER BY three_point_fg_frequency DESC;

--- 3 Point Field Goal Percentage: The percentage of made two-point field goals---
SELECT team, AVG(tp_percent) three_pt_fg_percentage
FROM all_star_break_2023
GROUP BY team
ORDER BY three_pt_fg_percentage DESC;

--- Teams That Attempted The Most 3 Point Field Goals---
SELECT team, AVG(tpa) avg_three_pt_fg_attempts
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_three_pt_fg_attempts DESC;

SELECT team,game_date, AVG(tpa) OVER (PARTITION BY team ORDER BY game_date)
FROM all_star_break_2023;

--- Teams That Made The Most 3 Point Field Goals--
SELECT team, AVG(tpm) avg_three_pt_fg_made
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_three_pt_fg_made DESC;

--- The Percentage of 3 Point Baskets That Contribute To The Overall Teams Points---
SELECT team, ((SUM(tpm))*3)*100/SUM(points) three_points_scored
FROM all_star_break_2023
GROUP BY team
ORDER BY three_points_scored DESC;

---Free Throw Rate: measures a team’s ability to get to the free throw line---
---FTA / FGA---
SELECT team, (SUM(fta)/SUM(fga)) ftr
FROM all_star_break_2023
GROUP BY team
ORDER BY ftr DESC;

--- Teams That Average The Most 2 Point Field Goals Attempted--
SELECT team, AVG(fta) avg_free_throw_attempts
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_free_throw_attempts DESC;

--- Teams With The Highest Free Throw Percentage ---
SELECT team, AVG(ft_percent) avg_free_throw_percent
FROM all_star_break_2023
GROUP BY team
ORDER BY avg_free_throw_percent DESC;

--- The Percentage of Free Throw Baskets That Contribute To The Overall Teams Points---
SELECT team, (SUM(ftm))*100/SUM(points) free_throw_points_scored
FROM all_star_break_2023
GROUP BY team
ORDER BY free_throw_points_scored DESC;