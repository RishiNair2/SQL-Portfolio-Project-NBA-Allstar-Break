--- 2021-2022 & 2022-2023 Combined Allstar Break Queries ---
CREATE VIEW all_star_break AS(
	SELECT g.team, g.game_date, g.win_loss, g.minutes, g.points, g.fgm, g.fga, g.fg_percent,
	g.tpm,g.tpa,g.tp_percent,g.ftm, g.fta, g.ft_percent, g.oreb, g.dreb, g.reb, g.ast,g.stl,
	g.block,g.turnovers,g.fouls, g.plus_minus, f.game_dates, f.win_losses, f.minute, f.point, f.fgms, f.fgas, f.fg_percentage,
	f.tpms,f.tpas,f.tp_percents,f.ftms, f.ftas, f.ft_percents, f.orebs, f.drebs, f.rebs, f.asts,f.stls,
	f.blocks,f.turnover,f.foul, f.plus_minuses
	FROM all_star_break_2023 g
	JOIN all_star_break_2022 f
	ON g.team = f.team )

---- All-star Break Initial Query---
SELECT *
FROM all_star_break
LIMIT 5;

--- Win Differential ---
SELECT t1.team, (t1.win_2023 - t1.win_2022) win_differential
FROM(
SELECT team, COUNT(CASE WHEN win_loss = 'W' THEN 1 END) AS win_2023 ,
COUNT(CASE WHEN win_losses = 'W' THEN 1 END) AS win_2022,
FROM all_star_break
GROUP BY team) t1


SELECT team, COUNT(CASE WHEN win_loss = 'W' THEN 1 END) AS win_2023 ,
COUNT(CASE WHEN win_losses = 'W' THEN 1 END) AS win_2022,
FROM all_star_break
GROUP BY team;

--- Possessions Differential---
SELECT t1.team, (t1.possessions_2023 - t1.possessions_2022) position_differential
FROM(
SELECT team, (.96*((SUM(fga) + SUM(turnovers) + (.44*(SUM(fta)))) - SUM(oreb))) possessions_2023 ,
(.96*((SUM(fgas) + SUM(turnover) + (.44*(SUM(ftas)))) - SUM(orebs))) possessions_2022
FROM all_star_break
GROUP BY team ) t1


SELECT team, (.96*((SUM(fga) + SUM(turnovers) + (.44*(SUM(fta)))) - SUM(oreb))) possessions_2023 ,
(.96*((SUM(fgas) + SUM(turnover) + (.44*(SUM(ftas)))) - SUM(orebs))) possessions_2022
FROM all_star_break
GROUP BY team;

--- Effective Field Goal Percentage Differential---
SELECT t2.team, (t2.avg_efg_2023 - t2.avg_efg_2022) efg_differential
FROM
(SELECT t1.team, AVG(t1.efg_2022) * 100 avg_efg_2022, AVG(t1.efg_2023) * 100 avg_efg_2023
FROM(
SELECT team,((fgms + (.5*tpm))/(fga)) efg_2023 ,
	((fgms + (.5*tpms))/(fgas)) efg_2022
FROM all_star_break) t1
GROUP BY t1.team) t2


SELECT t1.team, AVG(t1.efg_2022) * 100 avg_efg_2022, AVG(t1.efg_2023) * 100 avg_efg_2023
FROM(
SELECT team,((fgms + (.5*tpm))/(fga)) efg_2023 ,
	((fgms + (.5*tpms))/(fgas)) efg_2022
FROM all_star_break) t1
GROUP BY t1.team;

--- True Shooting Percentage Differential ---
SELECT t2.team, (t2.avg_ts_percentage_2023 - t2.avg_ts_percentage_2022) ts_differential
FROM(
SELECT t1.team, AVG(ts_percentage_2023) avg_ts_percentage_2023 ,
AVG(ts_percentage_2022) avg_ts_percentage_2022
FROM(
SELECT team, (points *100/(2*(fga + .475*fta))) ts_percentage_2023,
	(point *100/(2*(fgas + .475*ftas))) ts_percentage_2022 
FROM all_star_break) t1
GROUP BY t1.team) t2



SELECT t1.team, AVG(ts_percentage_2023) avg_ts_percentage_2023 ,
AVG(ts_percentage_2022) avg_ts_percentage_2022
FROM(
SELECT team, (points *100/(2*(fga + .475*fta))) ts_percentage_2023,
	(point *100/(2*(fgas + .475*ftas))) ts_percentage_2022 
FROM all_star_break) t1
GROUP BY t1.team;


--- Average Point Differential---
SELECT team, (AVG(points) - AVG(point)) avg_point_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_point_differential;

SELECT team, AVG(points) avg_2023_points, AVG(point) avg_2022_points
FROM all_star_break
GROUP BY team;

-- Average Field Goal Percentage Differential---
SELECT team, (AVG(fg_percent) - AVG(fg_percentage)) avg_fg_percent_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_fg_percent_differential;

SELECT team, AVG(fg_percent) avg_2023_fg_percentage, AVG(fg_percentage) avg_2022_fg_percentage
FROM all_star_break
GROUP BY team;

--- 2 Point Field Goal Frequency Differnetial---
SELECT t1.team, (t1.two_2023_fg_frequency-t1.two_2022_fg_frequency) two_point_fg_frequency_differential
FROM(
SELECT team, (SUM(fga)-SUM(tpa))*100/ SUM(fga) two_2023_fg_frequency,
(SUM(fgas)-SUM(tpas))*100/ SUM(fgas) two_2022_fg_frequency
FROM all_star_break
GROUP BY team) t1

SELECT team, (SUM(fga)-SUM(tpa))*100/ SUM(fga) two_2023_fg_frequency,
(SUM(fgas)-SUM(tpas))*100/ SUM(fgas) two_2022_fg_frequency
FROM all_star_break
GROUP BY team;

---2 Point Field Goal Percentage Differential---
SELECT t1.team, t1.two_2023_fg_percentage - t1.two_2022_fg_percentage
FROM(
SELECT team, (SUM(fgm)-SUM(tpm))*100/(SUM(fga)-SUM(tpa)) two_2023_fg_percentage,
(SUM(fgms)-SUM(tpms))*100/(SUM(fgas)-SUM(tpas)) two_2022_fg_percentage
FROM all_star_break
GROUP BY team) t1


SELECT team, (SUM(fgm)-SUM(tpm))*100/(SUM(fga)-SUM(tpa)) two_2023_fg_percentage,
(SUM(fgms)-SUM(tpms))*100/(SUM(fgas)-SUM(tpas)) two_2022_fg_percentage
FROM all_star_break
GROUP BY team;

---2 Point Field Goal Attempts Differential---
SELECT t1.team, (AVG(two_2022_point_attempts)-
AVG(two_2023_point_attempts)) two_point_attempts_differential
FROM(
SELECT team, fga-tpa two_2023_point_attempts,
	fgas-tpas two_2022_point_attempts
FROM all_star_break) t1
GROUP BY t1.team;


SELECT t1.team, AVG(two_2022_point_attempts) avg_two_2022_point_attempts,
AVG(two_2023_point_attempts) avg_two_2022_point_attempts
FROM(
SELECT team, fga-tpa two_2023_point_attempts,
	fgas-tpas two_2022_point_attempts
FROM all_star_break) t1
GROUP BY t1.team;

--- The Percentage of 2 Point Baskets That Contribute To The Overall Teams Points Differential---
SELECT t1.team, (t1.two_points_scored_2023-t1.two_points_scored_2022) two_point_contribution_differential
FROM
(SELECT team, ((SUM(fgm)-SUM(tpm))*2)*100/SUM(points) two_points_scored_2023,
((SUM(fgms)-SUM(tpms))*2)*100/SUM(point) two_points_scored_2022
FROM all_star_break
GROUP BY team) t1


SELECT team, ((SUM(fgm)-SUM(tpm))*2)*100/SUM(points) two_points_scored_2023,
((SUM(fgms)-SUM(tpms))*2)*100/SUM(point) two_points_scored_2022
FROM all_star_break
GROUP BY team;


--- 3 Point Field Goal Frequency Differnetial---
SELECT t1.team, (t1.three_2023_fg_frequency-t1.three_2022_fg_frequency) three_point_fg_frequency_differential
FROM(
SELECT team, SUM(tpa)*100/ SUM(fga) three_2023_fg_frequency,
SUM(tpas)*100/ SUM(fgas) three_2022_fg_frequency
FROM all_star_break
GROUP BY team) t1

SELECT team, SUM(tpa)*100/ SUM(fga) three_point_fg_frequency_2023,
SUM(tpas)*100/ SUM(fgas) three_point_fg_frequency_2022
FROM all_star_break
GROUP BY team;


---3 Point Field Goal Percentage Differential---
SELECT team, (AVG(tp_percent) - AVG(tp_percents)) avg_3_point_percentage_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_3_point_percentage_differential;

SELECT team, AVG(tp_percent) avg_2023_tp_percent, AVG(tp_percents) avg_2022_tp_percents
FROM all_star_break
GROUP BY team;

--- 3 Point Field Goal Attempts Differential---
SELECT team, (AVG(tpa) - AVG(tpas)) avg_3_point_attempts_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_3_point_attempts_differential;

SELECT team, AVG(tpa) avg_2023_tp_attempts, AVG(tpas) avg_2022_tp_attempts
FROM all_star_break
GROUP BY team;

--- The Percentage of 3 Point Baskets That Contribute To The Overall Teams Points Differential---
SELECT t1.team, (t1.three_points_scored_2023-t1.three_points_scored_2022) three_point_contribution_differential
FROM
(SELECT team, ((SUM(tpm))*3)*100/SUM(points) three_points_scored_2023,
((SUM(tpms))*3)*100/SUM(point) three_points_scored_2022
FROM all_star_break
GROUP BY team) t1


SELECT team,((SUM(tpm))*3)*100/SUM(points) three_points_scored_2022 ,
((SUM(tpms))*3)*100/SUM(point) three_points_scored_2022
FROM all_star_break
GROUP BY team;

---Free Throw Rate Differential---
SELECT t1.team, (t1.ftr_2023-t1.ftr_2022)free_throw_rate_differential
FROM(
SELECT team, (SUM(fta)/SUM(fga)) ftr_2023,
(SUM(ftas)/SUM(fgas)) ftr_2022
FROM all_star_break
GROUP BY team) t1


SELECT team, (SUM(fta)/SUM(fga)) ftr_2023,
(SUM(ftas)/SUM(fgas)) ftr_2022
FROM all_star_break
GROUP BY team;

--- Free Throw Attempts Differenital--
SELECT team, AVG(ftas) avg_free_throw_attempts
FROM all_star_break_2022
GROUP BY team
ORDER BY avg_free_throw_attempts DESC;

--- Free Throw Percentage Differential ---
SELECT t1.team, (t1.avg_free_throw_percent_2023 - t1.avg_free_throw_percent_2022) free_throw_percent_differential
FROM(
SELECT team, AVG(ft_percent) avg_free_throw_percent_2023,
AVG(ft_percents) avg_free_throw_percent_2022
FROM all_star_break
GROUP BY team) t1

SELECT team, AVG(ft_percent) avg_free_throw_percent_2023,
AVG(ft_percents) avg_free_throw_percent_2022
FROM all_star_break
GROUP BY team;


--- The Percentage of Free Throw Baskets That Contribute To The Overall Teams Points Differential---
SELECT t1.team, (t1.free_throw_points_scored_2023 - t1.free_throw_points_scored_2022) free_throw_point_contribution_differential
FROM
(SELECT team,(SUM(ftm))*100/SUM(points) free_throw_points_scored_2023 ,
(SUM(ftms))*100/SUM(point) free_throw_points_scored_2022
FROM all_star_break
GROUP BY team) t1

SELECT team,(SUM(ftm))*100/SUM(points) free_throw_points_scored_2023 ,
(SUM(ftms))*100/SUM(point) free_throw_points_scored_2022
FROM all_star_break
GROUP BY team;


--- Turnover differential from 2022 to 2023---
SELECT team, (AVG(turnovers) - AVG(turnover)) avg_turnover_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_turnover_differential;

SELECT team, AVG(turnovers) avg_2023_turnover, AVG(turnover) avg_2022_turnover
FROM all_star_break
GROUP BY team;

--- Turnover Percentage Differential ---
SELECT t1.team, (t1.tov_2023_percentage - t1.tov_2022_percentage) tov_percentage_differential
FROM(
SELECT team, SUM(turnover) *100/(SUM(fgas) + (.44*SUM(ftas)) + SUM(turnover)) tov_2022_percentage,
SUM(turnovers) *100/(SUM(fga) + (.44*SUM(fta)) + SUM(turnovers)) tov_2023_percentage
FROM all_star_break
GROUP BY team) t1


SELECT team, SUM(turnover) *100/(SUM(fgas) + (.44*SUM(ftas)) + SUM(turnover)) tov_2022_percentage,
SUM(turnovers) *100/(SUM(fga) + (.44*SUM(fta)) + SUM(turnovers)) tov_2023_percentage
FROM all_star_break
GROUP BY team;

---Assist/Turnover Ratio Differential---
SELECT t1.team, (t1.ast_tov_2023_ratio - t1.ast_tov_2022_ratio) ast_tov_ratio_differential
FROM(
SELECT team, (SUM(ast)/SUM(turnovers)) ast_tov_2023_ratio, 
(SUM(asts)/SUM(turnover)) ast_tov_2022_ratio
FROM all_star_break
GROUP BY team) t1



SELECT team, (SUM(ast)/SUM(turnovers)) ast_tov_2023_ratio, 
(SUM(asts)/SUM(turnover)) ast_tov_2022_ratio
FROM all_star_break
GROUP BY team;

--- Overall Rebound Differential--
SELECT team, (AVG(reb) - AVG(rebs)) avg_rebound_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_rebound_differential;

SELECT team, AVG(reb) avg_2023_rebound, AVG(rebs) avg_2022_rebound
FROM all_star_break
GROUP BY team;

-- Offensive Rebound Differential---
SELECT team, (AVG(oreb) - AVG(orebs)) avg_offensive_rebound_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_offensive_rebound_differential;

SELECT team, AVG(oreb) avg_2023_offensive_rebound, AVG(orebs) avg_2022_offensive_rebound
FROM all_star_break
GROUP BY team;

--- The Percentage of Offensive Rebounds That Contribute To The Overall Teams Rebound Differential ---
SELECT t1.team, (t1.oreb_percentage_2023 - t1.oreb_percentage_2022) oreb_percentage_differential
FROM(
SELECT team, (SUM(oreb)*100/SUM(reb)) oreb_percentage_2023,
(SUM(orebs)*100/SUM(rebs)) oreb_percentage_2022
FROM all_star_break
GROUP BY team) t1

SELECT team, (SUM(oreb)*100/SUM(reb)) oreb_percentage_2023,
(SUM(orebs)*100/SUM(rebs)) oreb_percentage_2022
FROM all_star_break
GROUP BY team;

-- Defensive Rebound differential from 2022 to 2023---
SELECT team, (AVG(dreb) - AVG(drebs)) avg_defensive_rebound_differential
FROM all_star_break
GROUP BY team
ORDER BY avg_defensive_rebound_differential;

SELECT team, AVG(dreb) avg_2023_defensive_rebound, AVG(drebs) avg_2022_defensive_rebound
FROM all_star_break
GROUP BY team;

--- The Percentage of Defensive Rebounds That Contribute To The Overall Teams Rebound Differential ---
SELECT t1.team, (t1.dreb_percentage_2023 - t1.dreb_percentage_2022) dreb_percentage_differential
FROM(
SELECT team, (SUM(dreb)*100/SUM(reb)) dreb_percentage_2023,
(SUM(drebs)*100/SUM(rebs)) dreb_percentage_2022
FROM all_star_break
GROUP BY team) t1

SELECT team, (SUM(dreb)*100/SUM(reb)) oreb_percentage_2023,
(SUM(drebs)*100/SUM(rebs)) oreb_percentage_2022
FROM all_star_break
GROUP BY team;