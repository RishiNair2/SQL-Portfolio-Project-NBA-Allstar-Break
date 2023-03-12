--- 2022-2023 Before All-Star Break Queries---
--- Scoring/Shooting Stats---
SELECT *
FROM all_star_break_2023

--- Possessions: Estimates number of possessions a team has---
--- .5 * (FGA + .475 * FTA - ORB + TOV)---
SELECT team, .5 * (SUM(fga) +(.475 * SUM(fta)) - (SUM(oreb) + SUM(turnovers)))
FROM all_star_break_2023
GROUP BY team

--

