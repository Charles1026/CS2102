/* Matric Number: A0235422N */
/* Q01 */
(
SELECT t.name AS team
FROM team t INNER JOIN participate p ON t.name = p.team
WHERE p.year = 2023

EXCEPT

SELECT t.name AS team
FROM team t INNER JOIN participate p ON t.name = p.team
WHERE p.year = 2024
)

ORDER BY team ASC;

/* Q02 */
SELECT t.name AS team, p.solve
FROM team t INNER JOIN participate p ON t.name = p.team
WHERE p.site = 'Central Europe' AND p.year = 2023
ORDER BY p.solve DESC, p.time ASC, p.last ASC, t.name ASC;


/* Q03 */
SELECT t.name AS team, u.name as university

FROM university u INNER JOIN team t ON u.name = t.univ
  INNER JOIN participate p ON t.name = p.team
  INNER JOIN (
  SELECT p.site, p.year, MAX(p.solve) AS max_solve
  FROM team t INNER JOIN participate p ON t.name = p.team
  GROUP BY p.site, p.year
) i ON p.site = i.site AND p.year = i.year AND p.solve = i.max_solve

ORDER BY u.name DESC, t.name ASC;

/* Q04 */
SELECT t.name AS team

FROM university u INNER JOIN team t ON u.name = t.univ
  INNER JOIN participate p ON t.name = p.team
  INNER JOIN (
  SELECT q.site, q.year, COUNT(*) AS total_score 
  FROM question q
  GROUP BY q.site, q.year
) contest ON p.site = contest.site AND p.year = contest.year

WHERE p.solve = contest.total_score
GROUP BY t.name
HAVING COUNT(*) > 0

ORDER BY t.name ASC;

/* Q05 */
SELECT outer_uni_teams.region, outer_uni_teams.name AS university, outer_uni_teams.num_teams AS count
FROM (
  SELECT u.name, u.region, COUNT(DISTINCT t.name) AS num_teams
  FROM university u INNER JOIN team t ON u.name = t.univ
    INNER JOIN participate p ON t.name = p.team
  GROUP BY u.name, u.region
) outer_uni_teams
INNER JOIN (
  SELECT uni_teams.region, MAX(uni_teams.num_teams) AS max_teams
  FROM (
    SELECT u.name, u.region, COUNT(DISTINCT t.name) AS num_teams
    FROM university u INNER JOIN team t ON u.name = t.univ
      INNER JOIN participate p ON t.name = p.team
    GROUP BY u.name, u.region
  ) uni_teams
  GROUP BY uni_teams.region
) region_teams ON outer_uni_teams.region = region_teams.region
WHERE outer_uni_teams.num_teams = region_teams.max_teams
ORDER BY outer_uni_teams.num_teams DESC;