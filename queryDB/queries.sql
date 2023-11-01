use [EuroCup2016];

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

/*
find out who scored the first goal of the 2016 European Championship. 
Return player_name, jersey_no, country_name, goal_time, play_stage, goal_schedule, goal_half.
*/
select player_name, jersey_no, country_name, goal_time, play_stage, goal_schedule, goal_half
from soccer_country sc
join player_mast pm on sc.country_id = pm.team_id
join goal_details gd on pm.player_id = gd.player_id
where gd.goal_id = 1;

/*
find the referee who managed the opening match. 
Return referee name, country name.
*/
select referee_name, country_name
from referee_mast rm
join match_mast mm on rm.referee_id = mm.referee_id
join soccer_country sc on rm.country_id = sc.country_id
where mm.match_no = 1;

/*
find the referee who managed the final match. 
Return referee name, country name
*/
select referee_name, country_name
from referee_mast rm
join match_mast mm on rm.referee_id = mm.referee_id
join soccer_country sc on rm.country_id = sc.country_id
where mm.play_stage = 'F';

/*
find the referee who assisted the referee in the opening match. 
Return associated referee name, country name.
*/
select ass_ref_name, country_name
from asst_referee_mast arm
join soccer_country sc on arm.country_id = sc.country_id
join match_details md on arm.ass_ref_id = md.ass_ref
where md.match_no = 1;

/*
find the referee who assisted the referee in the final match. 
Return associated referee name, country name.
*/
select ass_ref_name, country_name
from asst_referee_mast arm
join soccer_country sc on arm.country_id = sc.country_id
join match_details md on arm.ass_ref_id = md.ass_ref
where md.play_stage = 'F';

/*
find out which stadium hosted the final match of the 2016 Euro Cup. 
Return venue_name, city, aud_capacity, audience.
*/
select sv.venue_name, sc.city, sv.aud_capacity, mm.audience
from soccer_venue sv
join soccer_city sc on sv.city_id = sc.city_id
join match_mast mm on sv.venue_id = mm.venue_id
where mm.play_stage = 'F';

--EXEC sp_rename 'soccer_venue.aud_capicity', 'aud_capacity', 'COLUMN';
--EXEC sp_rename 'match_mast.audence', 'audience', 'COLUMN';

/*
count the number of matches played at each venue. 
Sort the result-set on venue name. 
Return Venue name, city, and number of matches.
*/

select sv.venue_name, sc.city, count(mm.venue_id) as 'match_nb'
from soccer_venue sv
join soccer_city sc on sv.city_id = sc.city_id
join match_mast mm on sv.venue_id = mm.venue_id
group by sv.venue_name, sc.city
order by sv.venue_name;

/*
find the player who was the first player to be sent off at the tournament EURO cup 2016. 
Return match Number, country name and player name.
*/

select match_no, country_name, player_name
from player_booked pb
join player_mast pm on pb.player_id = pm.player_id
join soccer_country sc on pm.team_id = sc.country_id
where match_no = all (
	select min(match_no) 
	from player_booked
	where pb.sent_off = 'Y');

/*
find the teams that have scored one goal in the tournament. 
Return country_name as "Team", team in the group, goal_for.
*/
select country_name as 'Team', team_group, goal_for
from soccer_team st
join soccer_country sc on st.team_id = sc.country_id
where st.goal_for > 0
group by sc.country_name,team_group, goal_for
order by team_group;

/*
count the number of yellow cards each country has received. 
Return country name and number of yellow cards.
*/
select sc.country_name, count(pb.team_id) as 'YellowCardsNb'
from soccer_country sc
join player_booked pb on sc.country_id = pb.team_id
group by sc.country_name;

/*
count the number of goals that have been seen. 
Return venue name and number of goals
*/
select sv.venue_name, count(goal_id) as 'Goals'
from soccer_venue sv
join match_mast mm on sv.venue_id = mm.venue_id
join goal_details gd on mm.match_no = gd.match_no
group by sv.venue_name
order by 'Goals' desc;

/*
find the match where there was no stoppage time in the first half. 
Return match number, country name.
*/
select mm.match_no, sc.country_name 
from match_mast mm
join match_details md on mm.match_no = md.match_no
join soccer_country sc on md.team_id = sc.country_id
where mm.stop1_sec = 0;

/*
find the team(s) who conceded the most goals in EURO cup 2016. 
Return country name, team group and match played.
*/
select  country_name, team_group, st.goal_agnst 
from soccer_country sc 
join soccer_team st on sc.country_id = st.team_id
where st.goal_agnst  = (
select max(goal_agnst )
from soccer_team
);

/*
find those matches where the highest stoppage time was added in 2nd half of play. 
Return match number, country name, stoppage time(sec.).
*/
select mm.match_no, sc.country_name, mm.stop2_sec
from match_details md
join match_mast mm on md.match_no = mm.match_no
join soccer_country sc on md.team_id = sc.country_id
where mm.stop2_sec = (
	select max(stop2_sec)
	from match_mast
);
