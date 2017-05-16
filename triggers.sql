use mmorpg

-- 4
if OBJECT_ID ('exp_lvl_check', 'tr') is not null
	drop trigger exp_lvl_check;
go

create trigger exp_lvl_check
on characters
for update
as 
begin
	declare @ins_exp int, @id int
	set @ins_exp = (select experience from inserted)
	set @id = (select id from inserted)
	if @ins_exp != 0
	begin
		declare @new_lvl int
		set @new_lvl = (select max(lvl) from exp_lvl_relation where exp_ <= @ins_exp)

		update characters
			set level_ = @new_lvl where id = @id
	end
end
go
-- 4 end

-- 5
if OBJECT_ID ('raid_lvl_check', 'tr') is not null
	drop trigger raid_lvl_check
go

create trigger raid_lvl_check
on chars_in_raid
for insert
as 
begin
	declare @char int, @raid int, @char_lvl int, @leader_lvl int
	
	declare cur cursor for (select * from inserted)
	open cur
	fetch next from cur into @char, @raid
	while @@FETCH_STATUS=0
	begin
		set @leader_lvl = (select level_ from characters where id = (select leader from raid_groups where id = @raid))--(select @raid from inserted)))
		set @char_lvl = (select level_ from characters where id = @char)
		if (@char_lvl < @leader_lvl or @char_lvl > (@leader_lvl + 3))
		begin
			rollback transaction
		end
		fetch next from cur into @char, @raid
	end
end
go
-- 5 end

--7
if OBJECT_ID ('account_add_check', 'tr') is not null
	drop trigger account_add_check
go

create trigger account_add_check
on accounts
for insert, update
as 
begin
	declare @login varchar(max), @password varchar(max)

	declare cur cursor for (select login_, password_ from inserted)
	open cur
	fetch next from cur into @login, @password
	while @@FETCH_STATUS=0
	begin
		if (@login = @password)
			rollback transaction

		declare @max_char int, @char_count int
		set @max_char = (select max_characters from accounts where login_ = @login)
		set @char_count = (select characters_count from accounts where login_ = @login)
		if ((@char_count + 1) > @max_char)
			rollback transaction
		fetch next from cur into @login, @password
	end
end
go
--7 end

--9
if OBJECT_ID ('items_in_inventory_durabillity_check', 'tr') is not null
	drop trigger items_in_inventory_durabillity_check
go

create trigger items_in_inventory_durabillity_check
on items_in_inventory
for update
as 
begin
	declare @id int, @dur int

	declare cur cursor for (select id, durability_ from inserted)
	open cur
	fetch next from cur into @id, @dur
	while @@FETCH_STATUS=0
	begin
		if (@dur <= 0)
		begin
			delete from items_in_inventory where id = @id
		end

		fetch next from cur into @id, @dur
	end
	close cur
end
go
--9 end

--10
if OBJECT_ID ('char_create_race_class_compatible', 'tr') is not null
	drop trigger char_create_race_class_compatible
go

create trigger char_create_race_class_compatible
on characters
for insert
as 
begin
	declare @race int, @class int

	declare cur cursor for (select race, class from inserted)
	open cur
	fetch next from cur into @race, @class
	while @@FETCH_STATUS=0
	begin
		if not exists ((select * from races_classes_compatibility where (race = @race and class = @class)))
			rollback transaction

		fetch next from cur into @race, @class
	end
	close cur
end
go
--10 end

--12
if OBJECT_ID ('auction_add_item_min_max_price_check', 'tr') is not null
	drop trigger auction_add_item_min_max_price_check
go

create trigger auction_add_item_min_max_price_check
on items_on_auction
for insert
as 
begin
	declare @start_price int, @ransom_price int

	declare cur cursor for (select start_price, ransom_price from inserted)
	open cur
	fetch next from cur into @start_price, @ransom_price
	while @@FETCH_STATUS=0
	begin
		if (@start_price >= @ransom_price)
			rollback transaction

		fetch next from cur into @start_price, @ransom_price
	end
	close cur
end
go
--12 end