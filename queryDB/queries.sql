/*
find out where the final match of the EURO cup 2016 was played. Return venue name, city
*/
select venue_name, city
from soccer_venue sv
join soccer_city sc 
on sv.city_id = sc.city_id
join match_mast mm
on sv.venue_id = mm.venue_id
where mm.play_stage='F';

/*
find the total number of goals scored by each team. Return match number, country name and goal score
*/
select distinct country_name, sum(goal_score) as 'Goals Nb' 
from match_details md
join soccer_country sc on md.team_id = sc.country_id
group by country_name
order by 'Goals Nb' desc;

/*
find the number of goals scored by each team in each match during normal play. Return match number, country name and goal score
*/
select match_no,  country_name, goal_score 
from match_details md
join soccer_country sc on md.team_id = sc.country_id
where md.decided_by = 'N'
group by country_name, match_no, goal_score ;

/*
count the number of goals scored by each player within a normal play schedule. 
Group the result set on player name and country name and sorts the result-set 
according to the highest to the lowest scorer. 
Return player name, number of goals and country name.
*/
select pm.player_name, count(gd.player_id) as 'Goals Nb', sc.country_name
from goal_details gd
join player_mast pm on gd.player_id = pm.player_id
join soccer_country sc on pm.team_id = sc.country_id
group by pm.player_name,gd.player_id, sc.country_name
order by 'Goals Nb' desc;

/*
find out who scored the most goals in the 2016 Euro Cup.
Return player name, country name and highest individual scorer.
*/
select pm.player_name, count(gd.player_id) as 'goals_number', sc.country_name
from goal_details gd
join player_mast pm on gd.player_id = pm.player_id
join soccer_country sc on pm.team_id = sc.country_id
group by pm.player_name,  sc.country_name
having count(gd.player_id) >= all (
	select count(gd.player_id)
	from goal_details gd
	join player_mast pm on gd.player_id = pm.player_id
	join soccer_country sc on pm.team_id = sc.country_id
	group by pm.player_name,  sc.country_name
)

/*
find out who scored in the final of the 2016 Euro Cup. 
Return player name, jersey number and country name.
*/

select player_name, jersey_no, country_name
from goal_details gd
join player_mast pm on gd.player_id = pm.player_id
join soccer_country sc on pm.team_id = sc.country_id
where play_stage = 'F'

/*
find out which country hosted the 2016 Football EURO Cup. 
Return country name.
*/
select country_name 
from soccer_country sc
join soccer_city soc on sc.country_id = soc.country_id
join soccer_venue sv on soc.city_id = sv.city_id
group by country_name;
