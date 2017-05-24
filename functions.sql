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

--2
if object_id('full_def_on_char', 'FN') is not null
	drop function full_def_on_char
go

create function full_def_on_char(@char int)
returns int
as
begin
	declare @inv int, @item int, @res int
	set @res = 0
	set @inv = (select inventory from characters where id = @char)
	declare cur cursor for (select item from items_in_inventory where inv = @inv)
	open cur
	fetch next from cur into @item
	while @@FETCH_STATUS = 0
	begin
		declare @type varchar(max)
		--set @type = (select feature_value from items where id = @item)
		set @type = (select feauture_name from item_types where id = (select type_ from items where id = @item))
		if @type = 'defense'
		begin
			set @res = @res + (select feature_value from items where id = @item)
		end

		fetch next from cur into @item
	end
	close cur
	return @res
end
go
--2 end