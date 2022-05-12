-- choisir la DB -- 
USE wild_db_quest;

SHOW TABLES;

SELECT *
FROM school;
SELECT * 
FROM wizard;
SELECT * 
FROM team;
SELECT * 
FROM player;

-- Q1: nom et prenom des sorciers inscrit entre 1995 et 1998

-- player inscrit entre 1995 et 1998 
SELECT *
FROM player
WHERE enrollment_date BETWEEN '1995-01-01' AND '1998-12-31';

-- answer 
SELECT firstname, lastname
FROM wizard
WHERE id IN(
  SELECT wizard_id
  FROM player
  WHERE enrollment_date BETWEEN '1995-01-01' AND '1998-12-31'
  );

-- Q2: nom et prenom des sorciers inscrit entre 1995 et 1998 et qui on un role de keeper

-- player inscrit entre 1995 et 1998 
SELECT *
FROM player
WHERE 1 = 1 
  AND enrollment_date BETWEEN '1995-01-01' AND '1998-12-31'
  AND `role` = 'keeper';

-- answer:
SELECT firstname, lastname
FROM wizard
WHERE id IN(
  SELECT wizard_id
  FROM player
  WHERE 1 = 1 
    AND enrollment_date BETWEEN '1995-01-01' AND '1998-12-31'
    AND `role` = 'keeper'
);

-- Q3: nom, prenom, role des sorciers inscrit entre 1995 et 1998 et qui on un role de keeper

-- test 1: le role n'est pas affiché 
SELECT firstname, lastname
FROM wizard
WHERE wizard.id IN(
  SELECT wizard_id
  FROM player
  WHERE 1 = 1 
    AND enrollment_date BETWEEN '1995-01-01' AND '1998-12-31'
    AND `role` = 'chaser'
);

-- test2: affiche nom, prenom et role 
SELECT w.firstname, w.lastname, p.`role`
FROM wizard w
INNER JOIN player p ON p.wizard_id = w.id;

-- answer: 
SELECT w.firstname, w.lastname, p.`role`
FROM wizard w
INNER JOIN player p ON p.wizard_id = w.id
WHERE w.id IN(
  SELECT wizard_id
  FROM player
  WHERE 1 = 1 
    AND enrollment_date BETWEEN '1995-01-01' AND '1998-12-31'
    AND `role` = 'chaser'
);

-- Q4: nombre de joueur par role et par equipe

-- nombre de joueur par role et par equipe with team_id
SELECT team_id, `role`, COUNT(`role`) AS nb_player
FROM player
GROUP BY team_id, `role`
ORDER BY team_id;

-- put in a view 
CREATE VIEW count_role_per_team AS(
  SELECT team_id, `role`, COUNT(`role`) AS nb_player
  FROM player
  GROUP BY team_id, `role`
  ORDER BY team_id);
SELECT * 
FROM count_role_per_team;

-- answer
CREATE VIEW count_role_per_team_2 AS(
  SELECT team.`name`, `role`, COUNT(`role`) AS nb_player
  FROM player, team
  WHERE player.team_id = team.id
  GROUP BY team_id, `role`
  ORDER BY team_id);
SELECT * 
FROM count_role_per_team_2;

-- Q5: nom, prenom et role pour les chaser de Gryffondor

-- test 1: les joueurs ayant le role de chaser et faisant partie de gryffindor
SELECT team_id, wizard_id, `role`
FROM player
WHERE 1 =1 
  AND `role`= 'chaser'
  AND team_id = 1;
  
-- answer: vue pour récuperer team_id, wizard_id, nom, prenom et role de chaque joueur 
CREATE VIEW player_roles AS(
  SELECT team_id, team.`name`, wizard_id, firstname, lastname, `role`
  FROM player, team, wizard
  WHERE 1 = 1 
    AND player.team_id = team.id 
    AND player.wizard_id = wizard.id
 );

-- afficher seulement equipe, nom, prenom et role du joueur 
SELECT `name`, firstname, lastname, `role`
FROM player_roles
WHERE 1 =1 
  AND `role`= 'chaser'
  AND team_id = 1;

