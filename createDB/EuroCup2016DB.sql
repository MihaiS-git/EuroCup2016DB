if not exists (select name from sys.databases where name = 'EuroCup2016') create database  EuroCup2016;

use [EuroCup2016];

/*
The sample database represents some of the data storage and retrieval 
about a soccer tournament based on EURO CUP 2016. You might love football,
and for all the football lovers we are providing a detail information about a 
football tournament. This design of database will make it easier to understand
the various questions comes in your mind about a soccer tournament.
*/

/*
soccer_country:
country_id – this is a unique ID for each country
country_abbr – this is the sort name of each country
country_name – this is the name of each country
*/
create table soccer_country(
country_id bigint not null primary key,
country_abbr char(3),
country_name varchar(120)
);

/*
soccer_city:
city_id – this is a unique ID for each city
city – this is the name of the city
country_id – this is the ID of the country where the cities are located and only those countries will be available which are in soccer_country table
*/
create table soccer_city(
city_id bigint not null primary key,
city varchar(120),
country_id bigint,
foreign key (country_id) references soccer_country(country_id)
);

/*
soccer_venue:
venue_id – this is a unique ID for each venue
venue_name – this is the name of the venue
city_id – this is the ID of the city where the venue is located and only those cities will be available which are in the soccer_city table
aud_capicity – this is the capacity of audience for each venue
*/
create table soccer_venue(
venue_id bigint not null primary key,
venue_name varchar(120),
city_id bigint,
aud_capicity bigint,
foreign key (city_id) references soccer_city(city_id)
);

/*
soccer_team:
team_id – this is the ID for each team. Each teams are representing to a country which are referencing the country_id column of soccer_country table
team_group – the name of the group in which the team belongs
match_played – how many matches a team played in group stage
won – how many matches a team won
draw – how many matches a team draws
lost – how many matches a team lose
goal_for – how many goals a team conceded
goal_agnst – how many goals a team scored
goal_diff – the difference of goal scored and goal conceded
points – how many points a team achieved from their group stage matches
group_position – in which position a team finished their group stage matches
*/
create table soccer_team(
team_id bigint not null primary key,
team_group char(1),
match_played int,
won int,
draw int,
lost int,
goal_for int,
goal_agnst int,
goal_diff int,
points int,
group_position int
);

/*
playing_position:
position_id – this is a unique ID for each position where a player played
position_desc – this is the name of the position where a player played
*/
create table playing_position(
position_id char(2) not null primary key,
position_desc varchar(120)
);

/*
player_mast:
player_id – this is a unique ID for each player
team_id – this is the team where a player played, and only those teams which referencing the country_id column of the table soccer_country
jersey_no – the number which labeled on the jersey for each player
player_name – name of the player
posi_to_play – the position where a player played, and the positions are referencing the position_id column of playing_position table
dt_of_bir – date of birth of each player
age – approximate age at the time of playing the tournament
playing_club – the name of the club for which a player was playing at the time of the tournament
*/
create table player_mast(
player_id bigint not null primary key,
team_id bigint,
jersey_no int,
player_name varchar(120),
posi_to_play char(2),
dt_of_bir date,
age int,
playing_club varchar(120),
foreign key(team_id) references soccer_team(team_id),
foreign key(posi_to_play) references playing_position(position_id)
);

/*
referee_mast:
referee_id – this is the unique ID for each referee
referee_name – name of the referee
country_id – the country, where a referee belongs and the countries are those which referencing the country_id column of soccer_country table
*/
create table referee_mast(
referee_id bigint not null primary key,
referee_name varchar(120),
country_id bigint,
foreign key(country_id) references soccer_country(country_id)
);

/*
match_mast:
match_no – this if the unique ID for a match
play_stage – this indicates that in which stage a match is going on, i.e. G for Group stage, R for Round of 16 stage, Q for Quarter final stage, S for Semi Final stage, and F for Final
play_date – date of the match played
results – the result of the match, either win or draw
decided_by – how the result of the match has been decided, either N for by normally or P for by penalty shootout
goal_score – score for a match
venue_id – the venue where the match played and the venue will be one of the venue referencing the venue_id column of soccer_venue table
referee_id – ID of the referee who is selected for the match which referencing the referee_id column of referee_mast table
audence – number of audience appears to watch the match
plr_of_match – this is the player who awarded the player of a particular match and who is selected a 23 men playing squad for a team which referencing the player_id column of player_mast table
stop1_sec – how many stoppage time ( in second) have been added for the 1st half of play
stop2_sec – how many stoppage time ( in second) have been added for the 2nd half of play
*/
create table match_mast(
match_no bigint not null primary key,
play_stage char(1),
play_date date,
results varchar(10),
decided_by char(1),
goal_score varchar(5),
venue_id bigint,
referee_id bigint,
audence bigint,
plr_of_match bigint,
stop1_sec int,
stop2_sec int,
foreign key(venue_id) references soccer_venue(venue_id),
foreign key(referee_id) references referee_mast(referee_id),
foreign key(plr_of_match) references player_mast(player_id)
);

/*
coach_mast:
coach_id – this is the unique ID for a coach
coach_name – this is the name of the coach
*/
create table coach_mast(
coach_id bigint not null primary key,
coach_name  varchar(255)
);

/*
asst_referee_mast:
ass_ref_id – this is the unique ID for each referee assists the main referee
ass_ref_name – name of the assistant referee
country_id – the country where an assistant referee belongs and the countries are those which are referencing the country_id column of soccer_country table
*/

create table asst_referee_mast(
ass_ref_id bigint not null primary key,
ass_ref_name  varchar(255),
country_id bigint,
foreign key(country_id) references soccer_country(country_id)
);

/*
match_details:
match_no – number of the match which is referencing the match_no column of match_mast table
play_stage - stage of the match, i.e. G for group stage, R for Round of 16, Q for Quarter Final, S for Semi final and F for final
team_id – the team which is one of the playing team and it is referencing the country_id column of soccer_country table
win_lose – team either win or lose or drawn indicated by the character W, L, or D
decided_by - how the result achieved by the team, indicated N for normal score or P for penalty shootout
goal_score – how many goal scored by the team
penalty_score – how many goal scored by the team in penalty shootout
ass_ref – the assistant referee assist the referee which are referencing the ass_ref_id column of asst_referee_mast table
player_gk - the player who is keeping the goal for the team, is referencing the player_id column of player_mast table
*/
create table match_details(
match_no bigint, 
play_stage char(1),
team_id  bigint not null, 
win_lose char(1),
decided_by char(1),
goal_score int,
penalty_score int,
ass_ref bigint,
player_gk bigint,
foreign key(match_no) references match_mast(match_no),
foreign key(team_id) references soccer_country(country_id),
foreign key(ass_ref) references asst_referee_mast(ass_ref_id),
foreign key(player_gk) references player_mast(player_id),
primary key(match_no, team_id)
);

/*
goal_details:
goal_id – this is the unique ID for each goal
match_no – this is match_no which is referencing the match_no column of match_mast table
player_id - this is the ID of a player who is selected for the 23 men squad of a team for the tournament and which is referencing the player_id column of player_mast table
team_id – this is the ID of each team who are playing in the tournament and referencing the country_id column of soccer_country table
goal_time – this is the time when the goal scored
goal_type – this is the type of goal which came in normally indicated by N or own goal indicating by O and goal came from penalty indicated by P
play_stage – this is the play stage in which goal scored, indicated by G for group stage, R for round of 16 stage, Q for quarter final stage, S for semifinal stage and F for final match
goal_schedule – when the goal came, is it normal play session indicated by NT or in stoppage time indicated by ST or in extra time indicated by ET
goal_half – in which half of match goal came
*/
create table goal_details(
goal_id bigint not null primary key, 
match_no bigint,
player_id bigint,
team_id bigint,
goal_time int,
goal_type char(1),
play_stage char(1),
goal_schedule char(2),
goal_half int,
foreign key(match_no) references match_mast(match_no),
foreign key(player_id) references player_mast(player_id),
foreign key(team_id) references soccer_country(country_id)
);

/*
penalty_shootout:
kick_id – this is unique ID for each penalty kick
match_no - this is the match_no which is referencing the match_no column of match_mast table
team_id – this is the ID of each team who is playing in the tournament and referencing the country_id column of soccer_country table
player_id - this is the ID of a player who is selected for the 23 men squad of a team for the tournament and which is referencing the player_id column of player_mast table
score_goal – this is the flag Y if able to score the goal or N when not
kick_no – this is the kick number for the kick of an individual match
*/
create table penalty_shootout(
kick_id bigint not null primary key, 
match_no bigint,
team_id bigint,
player_id bigint, 
score_goal char(1),
kick_no int,
foreign key(match_no) references match_mast(match_no),
foreign key(team_id) references soccer_country(country_id),
foreign key(player_id) references player_mast(player_id),
);

/*
player_booked:
match_no - this is the match_no which is referencing the match_no column of match_mast table
team_id – this is the ID of each team who are playing in the tournament and referencing the country_id column of soccer_country table
player_id - this is the ID of a player who is selected for the 23 men squad of a team for the tournament and which is referencing the player_id column of player_mast table
booking_time – this is the time when a player booked
sent_off – this is the flag Y when a player sent off
play_schedule – when a player booked, is it in normal play session indicated by NT or in stoppage time indicated by ST or in extra time indicated by ET
play_half – in which half a player booked
*/
create table player_booked(
match_no bigint,
team_id bigint,
player_id bigint,
booking_time int,
sent_off char(1) default null,
play_schedule char(2),
play_half int
foreign key(match_no) references match_mast(match_no),
foreign key(team_id) references soccer_country(country_id),
foreign key(player_id) references player_mast(player_id),
primary key(match_no, team_id, player_id, booking_time)
);

/*
player_in_out:
match_no - this is the match_no which is referencing the match_no column of match_mast table
team_id – this is the ID of each team who are playing in the tournament and referencing the country_id column of soccer_country table
player_id - this is the ID of a player who is selected for the 23 men squad of a team for the tournament and which is referencing the player_id column of player_mast table
in_out – this is the flag I when a player came into the field or O when go out from the field
time_in_out – when a player come into the field or go out from the field
play_schedule – when a player come in or go out of the field, is it in normal play session indicated by NT or in stoppage time indicated by ST or in extra time indicated by ET
play_half - in which half a player come in or go out
*/
create table player_in_out(
match_no bigint,
team_id bigint,
player_id bigint,
in_out char(1),
time_in_out int,
play_schedule char(2),
play_half int,
foreign key(match_no) references match_mast(match_no),
foreign key(team_id) references soccer_country(country_id),
foreign key(player_id) references player_mast(player_id),
primary key(match_no, team_id, player_id, in_out, time_in_out)
);

/*
match_captain:
match_no - this is the match_no which is referencing the match_no column of match_mast table
team_id – this is the ID of each team who are playing in the tournament and referencing the country_id column of soccer_country table
player_captain - the player who represents as a captain for a team, is referencing the player_id column of player_mast table
*/
create table match_captain(
match_no bigint,
team_id bigint,
player_captain bigint,
foreign key(match_no) references match_mast(match_no),
foreign key(team_id) references soccer_country(country_id),
foreign key(player_captain) references player_mast(player_id),
primary key(match_no, team_id, player_captain)
);

/*
team_coaches:
team_id – this is the ID of a team who is playing in the tournament and referencing the country_id column of soccer_country table
coach_id – a team may be one or more coaches, this indicates the coach(s) who is/are coaching the team is referencing the coach_id column of coach_mast table
*/
create table team_coaches(
team_id bigint,
coach_id  bigint,
foreign key(team_id) references soccer_country(country_id),
foreign key(coach_id) references coach_mast(coach_id),
primary key(team_id, coach_id)
);

/*
penalty_gk:
match_no - this is the match_no which is referencing the match_no column of match_mast table
team_id – this is the ID of each team who are playing in the tournament and referencing the country_id column of soccer_country table
player_gk - the player who kept goal at the time of penalty shootout, is referencing the player_id column of player_mast table
*/
create table penalty_gk(
match_no bigint,
team_id bigint,
player_gk bigint,
foreign key(match_no) references match_mast(match_no),
foreign key(team_id) references soccer_country(country_id),
foreign key(player_gk) references player_mast(player_id),
primary key(match_no, team_id, player_gk)
);


