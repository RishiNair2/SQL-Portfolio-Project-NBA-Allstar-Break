--- 2021-2022 Before All-Star Break Queries---
--- Scoring/Shooting Stats---
SELECT *
FROM all_star_break_2022;

--- Possessions: Estimates number of possessions a team has---
--- 0.96*[(FGA)+(TOV)+0.44*(FTA)-(OReb)]---
SELECT team, (.96*((SUM(fgas) + SUM(turnover) + (.44*(SUM(ftas)))) - SUM(orebs))) possessions
FROM all_star_break_2022
GROUP BY team
ORDER BY possessions DESC;

--- Effective Field Goal Percentage: Adjusts a player's or team's FG% for the fact that a 3 pointer is worth 1.5 times a standard FG----
-- (FG + .5 * 3P) / FGA---
SELECT t1.team, AVG(t1.efg) * 100 avg_efg
FROM(
SELECT team, ((fgms + (.5*tpms))/(fgas)) efg
FROM all_star_break_2022) t1
GROUP BY t1.team
ORDER BY avg_efg DESC;

--- True Shooting Percentage: Adjusts standard FG% to include their FT%, encompasses all ways to score---
--- Pts / (2 * (FGA + .475 * FTA)) --- 
SELECT t1.team, AVG(ts_percentage) avg_ts_percentage
FROM(
SELECT team, (point *100/(2*(fgas + .475*ftas))) ts_percentage 
FROM all_star_break_2022) t1
GROUP BY t1.team
ORDER BY avg_ts_percentage DESC;

--- Offensive Efficiency Rating: number of points a team scores per 100 possessions.---
--- 100*(Points Scored / Possessions)---
SELECT team, ((100*SUM(point))/(SUM(fgas) + (.44*SUM(ftas)) + SUM(turnover))) oer
FROM all_star_break_2022
GROUP BY team
ORDER BY oer DESC;

--- Teams That Averaged The Most Points Before The All-Star Break---
SELECT team, AVG(point) avg_points
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_points DESC;

SELECT team, game_dates, AVG(point) OVER (PARTITION BY team ORDER BY game_dates)
FROM all_star_break_2022;

--- 2 Point Field Goal Frequency: The percentage of team field goal attempts that are 2 point field goals  ---
--- (2FGA)/(FGA) ---
SELECT team, (SUM(fgas)-SUM(tpas))*100/ SUM(fgas) two_fg_frequency
FROM all_star_break_2022
GROUP BY team
ORDER BY two_fg_frequency DESC;

--- 2 Point Field Goal Percentage: The percentage of made two-point field goals---
SELECT team, (SUM(fgms)-SUM(tpms))*100/(SUM(fgas)-SUM(tpas)) two_fg_percentage
FROM all_star_break_2022
GROUP BY team
ORDER BY two_fg_percentage DESC;

--- Teams That Attempted The Most 2 Point Field Goals---
SELECT t1.team, AVG(two_point_attempts) avg_two_point_attempts
FROM(
SELECT team, fgas-tpas two_point_attempts
FROM all_star_break_2022) t1
GROUP BY t1.team
ORDER BY avg_two_point_attempts DESC;

SELECT t1.team, AVG(t1.two_point_attempts) OVER (PARTITION BY t1.team ORDER BY t1.game_dates )
FROM(
SELECT team, game_dates, fgas-tpas two_point_attempts
FROM all_star_break_2022) t1

--- The Percentage of 2 Point Baskets That Contribute To The Overall Teams Points---
SELECT team, ((SUM(fgms)-SUM(tpms))*2)*100/SUM(point) two_points_scored
FROM all_star_break_2022
GROUP BY team
ORDER BY two_points_scored DESC;

--3 Point Field Goal Frequency: The percentage of team field goal attempts that are 2 point field goals  ---
--- (3FGA)/(FGA) ---
SELECT team, SUM(tpas)*100/ SUM(fgas) three_point_fg_frequency
FROM all_star_break_2022
GROUP BY team
ORDER BY three_point_fg_frequency DESC;

--- 3 Point Field Goal Percentage: The percentage of made two-point field goals---
SELECT team, AVG(tp_percents) three_pt_fg_percentage
FROM all_star_break_2022
GROUP BY team
ORDER BY three_pt_fg_percentage DESC;

--- Teams That Attempted The Most 3 Point Field Goals---
SELECT team, AVG(tpas) avg_three_pt_fg_attempts
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_three_pt_fg_attempts DESC;

SELECT team,game_dates, AVG(tpas) OVER (PARTITION BY team ORDER BY game_dates)
FROM all_star_break_2022;

--- Teams That Made The Most 3 Point Field Goals--
SELECT team, AVG(tpms) avg_three_pt_fg_made
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_three_pt_fg_made DESC;

--- The Percentage of 3 Point Baskets That Contribute To The Overall Teams Points---
SELECT team, ((SUM(tpms))*3)*100/SUM(points) three_points_scored
FROM all_star_break_2022
GROUP BY team
ORDER BY three_points_scored DESC;

---Free Throw Rate: measures a team’s ability to get to the free throw line---
---FTA / FGA---
SELECT team, (SUM(ftas)/SUM(fgas)) ftr
FROM all_star_break_2022
GROUP BY team
ORDER BY ftr DESC;

--- Teams That Average The Most 2 Point Field Goals Attempted--
SELECT team, AVG(ftas) avg_free_throw_attempts
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_free_throw_attempts DESC;

--- Teams With The Highest Free Throw Percentage ---
SELECT team, AVG(ft_percents) avg_free_throw_percent
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_free_throw_percent DESC;

--- The Percentage of Free Throw Baskets That Contribute To The Overall Teams Points---
SELECT team, (SUM(ftms))*100/SUM(point) free_throw_points_scored
FROM all_star_break_2022
GROUP BY team
ORDER BY free_throw_points_scored DESC;