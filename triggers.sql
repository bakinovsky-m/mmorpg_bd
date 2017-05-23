use mmorpg;
go

--1
if OBJECT_ID ('skill_class_and_lvl_check', 'tr') is not null
	drop trigger skill_class_and_lvl_check;
go

create trigger skill_class_and_lvl_check
on skills_on_char
for insert, update
as 
begin
	declare @char int, @skill int

	declare cur cursor for (select char_, skill from inserted)
	open cur
	fetch next from cur into @char, @skill
	while @@FETCH_STATUS=0
	begin
		declare @char_class int, @char_lvl int, @skill_min_lvl int
		set @char_class = (select class from characters where id = @char)
		set @char_lvl = (select level_ from characters where id = @char)
		set @skill_min_lvl = (select min_lvl from skills where id = @skill)

		if (not exists (select * from skills_on_class where (skill = @skill and class = @char_class)) or @skill_min_lvl > @char_lvl)
			rollback tran

		fetch next from cur into @char, @skill
	end
	close cur
end
go
--1 end

--2
if OBJECT_ID ('profession_skills_null_lvl_auto_add', 'tr') is not null
	drop trigger profession_skills_null_lvl_auto_add;
go

create trigger profession_skills_null_lvl_auto_add
on profs_on_char
for insert
as 
begin
	declare @prof int, @char int

	declare cur1 cursor for (select profession, char_ from inserted)
	open cur1
	fetch next from cur1 into @prof, @char
	while @@FETCH_STATUS=0
	begin
		declare @sk int, @pr int
		declare cur2 cursor for (select skill, profession from skills_on_profession)
		open cur2
		fetch next from cur2 into @sk, @pr
		while @@FETCH_STATUS = 0
		begin
			if @pr = @prof
			begin
				declare @min_lvl int
				set @min_lvl = (select min_lvl from skills where id = @sk)
				if @min_lvl <= 1
				begin
					insert into skills_on_char(char_, skill) values
					(@char, @sk)
				end
			end
			fetch next from cur2 into @sk, @pr	
		end
		close cur2
		fetch next from cur1 into @prof, @char
	end
	close cur1
end
go
--2 end

--3.1
if OBJECT_ID ('inventory_space_check_and_item_add', 'tr') is not null
	drop trigger inventory_space_check_and_item_add;
go

create trigger inventory_space_check_and_item_add
on items_in_inventory
for insert
as 
begin
	declare @inv int

	declare cur cursor for (select inv from inserted)
	open cur
	fetch next from cur into @inv
	while @@FETCH_STATUS=0
	begin
		declare @inv_fullness int, @inv_capacity int
		set @inv_capacity = (select size from inventories where id = @inv)
		set @inv_fullness = (select fullness from inventories where id = @inv)

		set @inv_fullness += 1
		if (@inv_fullness >= @inv_capacity)
			rollback tran
		else
		begin
			update inventories
				set fullness = @inv_fullness where id = @inv
		end

		fetch next from cur into @inv
	end
	close cur
end
go
--3.1 end

--3.2
if OBJECT_ID ('inventory_item_delete', 'tr') is not null
	drop trigger inventory_item_delete;
go

create trigger inventory_item_delete
on items_in_inventory
for delete
as 
begin
	declare @inv int

	declare cur cursor for (select inv from deleted)
	open cur
	fetch next from cur into @inv
	while @@FETCH_STATUS=0
	begin
		declare @inv_fullness int
		set @inv_fullness = (select fullness from inventories where id = @inv)

		set @inv_fullness -= 1
		if (@inv_fullness <= 0)
			rollback tran
		else
		begin
			update inventories
				set fullness = @inv_fullness where id = @inv
		end

		fetch next from cur into @inv
	end
	close cur
end
go
--3.2 end
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

--6
if OBJECT_ID ('char_class_skills_add', 'tr') is not null
	drop trigger char_class_skills_add;
go

create trigger char_class_skills_add
on characters
for insert
as 
begin
	declare @id int, @class int

	declare cur1 cursor for (select id, class from inserted)
	open cur1
	fetch next from cur1 into @id, @class
	while @@FETCH_STATUS=0
	begin
		declare @skill int, @cl int
		declare cur2 cursor for (select skill, class from skills_on_class)
		open cur2
		fetch next from cur2 into @skill, @cl
		while @@FETCH_STATUS = 0
		begin
			if @cl = @class
			begin
				declare @min_lvl int
				set @min_lvl = (select min_lvl from skills where id = @skill)
				if @min_lvl <= 0
				begin
					insert into skills_on_char(char_, skill) values
					(@id, @skill)
				end
			end
			fetch next from cur2 into @skill, @cl	
		end
		close cur2
		fetch next from cur1 into @id, @class
	end
	close cur1
end
go
--6 end

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
		if (@char_count > @max_char)
		begin
			--rollback transaction
			raiserror('account new char error', 11, 1)
			rollback tran
		end
		fetch next from cur into @login, @password
	end
	close cur
end
go
--7 end

--8
if OBJECT_ID ('account_character_deleter', 'tr') is not null
	drop trigger account_character_deleter
go

create trigger account_character_deleter
on chars_on_account
for insert
as 
begin
	declare @account int, @char int

	declare cur cursor for (select account, character_ from inserted)
	open cur
	fetch next from cur into @account, @char
	while @@FETCH_STATUS=0
	begin
		begin try
			update accounts
				set characters_count += 1
		end try
		begin catch
			rollback tran
			delete from chars_on_account where account = @account and character_ = @char
			delete from characters where id = @char
		end catch

		fetch next from cur into @account, @char
	end
	close cur
end
go
--8 end

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

--11
if OBJECT_ID ('item_add_min_level_check', 'tr') is not null
	drop trigger item_add_min_level_check
go

create trigger item_add_min_level_check
on items_in_inventory
for insert
as 
begin
	declare @item int, @inventory int

	declare cur cursor for (select item, inv from inserted)
	open cur
	fetch next from cur into @item, @inventory
	while @@FETCH_STATUS=0
	begin
		declare @item_min_lvl int, @char_lvl int
		set @item_min_lvl = (select min_lvl from items where id = @item)
		set @char_lvl = (select level_ from characters where inventory = @inventory)

		if @item_min_lvl > @char_lvl
			rollback tran

		fetch next from cur into @item, @inventory
	end
	close cur
end
go
--11 end

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

--13
if OBJECT_ID ('quest_auto_increment', 'tr') is not null
	drop trigger quest_auto_increment
go

create trigger quest_auto_increment
on quests
for insert
as 
begin
	declare @id int, @quest_line int, @number_in_quest_line int

	declare cur cursor for (select id, quest_line, number_in_quest_line from inserted)
	open cur
	fetch next from cur into @id, @quest_line, @number_in_quest_line
	while @@FETCH_STATUS=0
	begin
		declare @last_number int
		if (@quest_line is not null and @number_in_quest_line is null)
		begin
			set @last_number = (select top(1) number_in_quest_line from quests where quest_line = @quest_line order by number_in_quest_line desc)
			update quests
				set number_in_quest_line = (@last_number + 1) where id = @id
		end

		fetch next from cur into @id, @quest_line, @number_in_quest_line
	end
	close cur
end
go

--13 end

--14
if OBJECT_ID ('item_wore_check', 'tr') is not null
	drop trigger item_wore_check
go

create trigger item_wore_check
on items_in_inventory
for insert, update
as 
begin
	declare @this_id int, @inv int, @item int, @on_char bit

	declare cur1 cursor for (select id, inv, item, on_char from inserted)
	open cur1
	fetch next from cur1 into @this_id, @inv, @item, @on_char
	while @@FETCH_STATUS=0
	begin
		if @on_char = 1
		begin
			declare @this_item_type int
			set @this_item_type = (select type_ from items where id = @item)

			declare @id int, @it int, @in int, @onc bit
			declare cur2 cursor for (select id, item, inv, on_char from items_in_inventory)
			open cur2
			fetch next from cur2 into @id, @it, @in, @onc
			while @@FETCH_STATUS = 0
			begin
				declare @it_type int
				set @it_type = (select type_ from items where id = @it)
				if (@it_type = @this_item_type and @in = @inv and @onc = 1)
				begin
					update items_in_inventory
						set on_char = 0 where (id = @id and id <> @this_id)
				end
				fetch next from cur2 into @id, @it, @in, @onc
			end
			close cur2
		end

		fetch next from cur1 into @this_id, @inv, @item, @on_char
	end
	close cur1
end
go
--14 end

--15
if OBJECT_ID ('bank_fraction_check', 'tr') is not null
	drop trigger bank_fraction_check
go

create trigger bank_fraction_check
on banks
for insert
as 
begin
	declare @multifr bit, @net_name varchar(max), @city int
	declare cur1 cursor for (select multifraction, net_name,city from inserted)
	open cur1
	fetch next from cur1 into @multifr, @net_name, @city
	while @@FETCH_STATUS=0
	begin
		if @multifr != 1
		begin
			declare @fraction int, @city_fraction int
			set @city_fraction = (select fraction from cities where id = @city)
			--set @fraction = (select fra from banks where)
			set @fraction = (select fraction from locations where id = (select location from cities where id = (select top 1 city from banks where net_name = @net_name)))
			if @city_fraction != @fraction
				rollback tran
		end
		fetch next from cur1 into @multifr, @net_name, @city
	end
	close cur1
end
go
--15 end

--16
if OBJECT_ID ('achivements_recalculate', 'tr') is not null
	drop trigger achivements_recalculate
go

create trigger achivements_recalculate
on achievements
for insert, delete
as 
begin
	declare @count int
	set @count = (select count(*) from achievements)
	declare cur1 cursor for (select * from inserted)
	open cur1
	fetch next from cur1
	while @@FETCH_STATUS=0
	begin
		
		declare @account int
		declare cur2 cursor for (select id from accounts)
		open cur2
		fetch next from cur2 into @account
		while @@FETCH_STATUS = 0
		begin
			declare @ach_count int, @res float, @a float, @b float
			set @ach_count = (select count(*) from achievs_on_account where account = @account)
			set @a = (select cast(@ach_count as float))
			set @b = (select cast(@count as float))
			set @res = (@a/@b)

			update accounts
				set percentage_of_achievements = @res where id = @account

			fetch next from cur2 into @account
		end
		close cur2
		fetch next from cur1
	end
	close cur1
end
go
--16 end

--17
if OBJECT_ID ('raid_lvl_dungeon_check', 'tr') is not null
	drop trigger raid_lvl_dungeon_check
go

create trigger raid_lvl_dungeon_check
on raid_groups
for insert, update
as 
begin
	declare @dungeon int, @leader int

	declare cur cursor for (select dungeon, leader from inserted)
	open cur
	fetch next from cur into @dungeon, @leader
	while @@FETCH_STATUS=0
	begin
		declare @d_lvl int, @l_lvl int
		set @d_lvl = (select min_lvl from dungeons where id = @dungeon)
		set @l_lvl = (select level_ from characters where id = @leader)

		if (@l_lvl < @d_lvl)
			rollback tran

		fetch next from cur into @dungeon, @leader
	end
	close cur
end
go
--17 end

--19
if OBJECT_ID ('auction_delete_items_move', 'tr') is not null
	drop trigger auction_delete_items_move
go

create trigger auction_delete_items_move
on items_on_auction
for delete
as 
begin
	declare @item int, @owner int

	declare cur19 cursor for (select item, owner_ from deleted)
	open cur19
	fetch next from cur19 into @item, @owner
	while @@FETCH_STATUS=0
	begin
		declare @inv int
		set @inv = (select inventory from characters where id = @owner)
		insert into items_in_inventory(inv, item) values
		(@inv, @item)
		fetch next from cur19 into @item, @owner
	end
	close cur19
end
go
--19 end

--20
if OBJECT_ID ('quest_line_delete_quest_delete', 'tr') is not null
	drop trigger quest_line_delete_quest_delete
go

create trigger quest_line_delete_quest_delete
on quest_lines
instead of delete
as 
begin
	declare @quest_line int

	declare cur1 cursor for (select id from deleted)
	open cur1
	fetch next from cur1 into @quest_line
	while @@FETCH_STATUS=0
	begin
		declare @quest int
		declare cur2 cursor for (select id from quests where quest_line = @quest_line)
		open cur2
		fetch next from cur2 into @quest
		while @@FETCH_STATUS = 0
		begin
			delete from quests where id = @quest
			fetch next from cur2 into @quest
		end
		delete from quest_lines where id = @quest_line
		close cur2
		fetch next from cur1 into @quest_line
	end
	close cur1
end
go
--20 end