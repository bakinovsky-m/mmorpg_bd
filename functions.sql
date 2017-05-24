use mmorpg;
go

--1
if object_id('finished_achievements_percent_count', 'FN') is not null
	drop function finished_achievements_percent_count
go

create function finished_achievements_percent_count(@account int)
returns float
as
begin
	declare @all_avhieves_count int, @finished_achieves_count int
	set @all_avhieves_count = (select count(*) from achievements)
	set @finished_achieves_count = (select count(*) from achievs_on_account where account = @account)
	declare @res int
	set @res = (@finished_achieves_count* 100)/@all_avhieves_count
	return @res
end
go

--1 end