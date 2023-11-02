use [EuroCup2016];

if exists (select * from sys.procedures where name = 'createGroupATable')
drop procedure createGroupATable;
go

create procedure createGroupATable
as
begin
	if exists (select * from sys.tables where name = 'GroupA')
	drop table GroupA;
	create table GroupA(
		the_group char(1),
		team varchar(120),
		coach varchar(120)
	);
	insert into GroupA (the_group, team, coach) (
		select  st.team_group as 'Group', sc.country_name as 'Team', cm.coach_name as 'Coach'
		from soccer_country sc
		join team_coaches tc on sc.country_id = tc.team_id
		join coach_mast cm on tc.coach_id = cm.coach_id
		join soccer_team st on sc.country_id = st.team_id
		where st.team_group = 'A'
		);
		select * from GroupA
end;
go

exec createGroupATable;
go

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
drop trigger  if exists InsertIntoLogTable;
drop table if exists log_table;
go

create table log_table(
log_id int primary key identity,
date date,
time time(0),
operation_type varchar(10),
table_name varchar(100),
rows_affected int
);
go

create or alter trigger InsertIntoLogTable
on GroupA
after insert, update, delete
as 
begin
	declare @operation_type varchar(10);
	if exists(select * from inserted)
	begin
		if exists(select * from deleted)		
		begin
			set @operation_type = 'UPDATE';
		end
		else
		begin
			set @operation_type = 'INSERT';
		end
	end
	else
	begin
		set @operation_type = 'DELETE';
	end

	insert into log_table(date, time, operation_type, table_name, rows_affected)
	select 
		convert(date, getdate()), 
		convert(time(0), 
		getdate()), 
		@operation_type,
		'GroupA', 
		case @operation_type
					when 'INSERT' then count(*)
					when 'DELETE' then count(*)
					when 'UPDATE' then count(*) / 2
		end as rows_affected
	from (select * from inserted union all select * from deleted) as RowsAffected;
end;
go
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
insert into GroupA values('B', 'Moldova', 'Popescu Ion');
delete from GroupA where team = 'Moldova';

update GroupA
set the_group = 'A' 
where team = 'Albania';
--------------------------------------------------------------------------
select * from log_table;
select * from GroupA;
--------------------------------------------------------------------------