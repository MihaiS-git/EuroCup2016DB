use [EuroCup2016];

-- create function that returns players over 30
if exists (select * from sys.objects where name = 'selectPlayersOverThirty')
drop function selectPlayersOverThirty;
go

create function selectPlayersOverThirty()
returns table
as return
(select * 
from player_mast 
where age > 30);
go

-- create procedure that creates a new table
if exists (select * from sys.procedures where name = 'createTablePlayersOverThirty')
drop procedure createTablePlayersOverThirty;
go

create proc createTablePlayersOverThirty 
as
begin
	create table players_over_thirty(
	player_id bigint not null primary key,
	team_id bigint,
	jersey_no int,
	player_name varchar(120),
	posi_to_play char(2),
	dt_of_bir date,
	age int,
	playing_club varchar(120),
	)
end;
go

--create procedure that inserts the players into the new table
if exists (select * from sys.procedures where name = 'InsertPlayersInOverThirtyTable')
drop procedure InsertPlayersInOverThirtyTable;
go

create procedure InsertPlayersInOverThirtyTable
as 
begin 
	execute createTablePlayersOverThirty;
	if exists (select * from sys.tables where name = 'players_over_thirty')
	insert into players_over_thirty
	select * from selectPlayersOverThirty();
end;
go

--create a general procedure to take the whole responsability
if exists(select * from sys.procedures where name = 'doTheWork')
drop procedure doTheWork;
go

create proc doTheWork
as
begin
	if exists (select * from sys.tables where name = 'players_over_thirty')
	drop table players_over_thirty;
	
	execute InsertPlayersInOverThirtyTable;

	select * from players_over_thirty;
end;
go


-- run the final procedure
execute doTheWork;