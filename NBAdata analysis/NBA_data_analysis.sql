-- Query to find the average Assists, Steals , Rebounds of a team between 2017-2021 (5 years)

select gd.team_id,concat(t."CITY",' ',t."NICKNAME") as team_name,g.season,
ROUND(CAST(avg(gd.ast) AS numeric),2) as average_assists,
ROUND(CAST(avg(gd.reb) AS numeric),2) as average_rebounds,ROUND(CAST(avg(gd.stl) AS numeric),2) as average_steals ,
ROUND(CAST(avg(gd.foul) AS numeric),2) as average_fouls
from "NBASchema"."gamedetails" as gd join "NBASchema".games g 
on gd.game_id=g.game_id join "NBASchema"."Teams" t on gd.team_id=t."TEAM_ID"
group by gd.team_id,g.season,team_name having g.season between 2017 and 2021 order by g.season desc;

--Query to find number of games played by a player and list their associated team
Select concat_ws(' ',t."CITY",t."NICKNAME") as team_name, gd.player_name , 
count(*) as num_of_times_played from "NBASchema".gamedetails gd
join "NBASchema"."Teams" t on gd.team_id=t."TEAM_ID"
group by player_id,team_id ,player_name,"CITY","NICKNAME" order by num_of_times_played desc;


-- Query to retrieve count of number oh matches won by home team and list the teams details
select games_data.home_team_id,count(*) as number_of_wins,team_data."ABBREVIATION",
CONCAT_WS(' ',team_data."CITY",team_data."NICKNAME") as TEAM_NAME,
team_data."OWNER",team_data."GENERALMANAGER",team_data."HEADCOACH"
from 
"NBASchema".games games_data join "NBASchema"."Teams" team_data 
on games_data.home_team_id=team_data."TEAM_ID"
where home_team_wins=1
group by home_team_id,"ABBREVIATION","NICKNAME","CITY","OWNER","GENERALMANAGER","HEADCOACH"
order by number_of_wins desc;

--Query to retrieve the teams with lowest win percentage in each season 
select sb2.season,sb2.team_id,concat_ws(' ',t."CITY",t."NICKNAME") as TEAM_NAME from
(select *,rank() over (partition by sb1.season order by sb1.maximum_loss asc ) from
(Select right(cast(season_id as text),4) as SEASON ,max(w_pct*100) as MAXIMUM_LOSS,
team_id from "NBASchema".rankings 
group by team_id,SEASON order by season,maximum_loss desc) as sb1) as sb2
join "NBASchema"."Teams" t on sb2.team_id=t."TEAM_ID"
where sb2.rank=1;

-- Query to retive the most wins for away team by season and list the team details
select sb2.season,sb2.team_id_away as team_id_with_most_away_wins,concat(t."CITY",' ',t."NICKNAME") as
 team_name_with_most_away_wins 
from (select *,row_number() over (partition by sb1.season order by sb1.team_away_wins desc) as rank_on_away_wins from
(select season,team_id_away,count(*) as team_away_wins 
from "NBASchema".games 
where home_team_wins=0
group by season,team_id_away
order by season asc,team_away_wins desc) as sb1)
as sb2 join "NBASchema"."Teams" t on t."TEAM_ID"=sb2.team_id_away
where rank_on_away_wins=1;

-- Query to retive the most wins for home team by season and list the team details

select sb2.season,sb2.home_team_id as  team_id_with_most_home_wins,
sb2.team_name as team_name_with_most_home_wins from
(
select *,row_number() over (partition by sb1.season order by sb1.sum desc) as rank_on_home_wins
from
(select g.season,g.home_team_id,concat(t."CITY",' ',t."NICKNAME") as TEAM_NAME,sum(g.home_team_wins)
 from "NBASchema".games as g 
join "NBASchema"."Teams" t on t."TEAM_ID"=g.home_team_id
group by g.season,g.home_team_id,TEAM_NAME
order by g.season asc,sum(g.home_team_wins) desc) as sb1)
as sb2
where rank_on_home_wins=1;

--Query to retrive top 3 players from each season

select * from 
(select *,
row_number() over (partition by sb1.season order by sb1.sum desc) as p_rank
from 
(select gd.player_name,gd.player_id,g.season,sum(gd.pf) from 
"NBASchema".games g join "NBASchema".gamedetails gd on gd.game_id=g."game_id"
group by gd.player_name,gd.player_id,season 
order by season asc,sum desc) as sb1) as sb2
where sb2.p_rank<4;

--Query to retrieve the top 10 oldest NBA teams
select concat("CITY",' ',"NICKNAME") AS TEAMNAME, "ARENA" AS HOME_ARENA, ("MAX_YEAR"-"MIN_YEAR") AS YEARS_INTO_LEAGUE
FROM "NBASchema"."Teams" 
ORDER BY YEARS_INTO_LEAGUE DESC
LIMIT 10;





