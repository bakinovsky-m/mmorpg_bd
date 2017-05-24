use mmorpg;
go

-- 1
drop proc account_create
go

create proc account_create(@login varchar(max), @password varchar(max))
as begin
	declare @existing_login varchar(max), @error bit
	set @error = 0
	declare curs cursor for (select login_ from accounts)
	open curs
	fetch next from curs into @existing_login
	while @@FETCH_STATUS = 0
	begin
		if @existing_login = @login
		begin
			raiserror('user with this login already exists', 10, 1)
			set @error = 1
		end

		fetch next from curs into @existing_login
	end
	close curs
	if @error = 0
	begin
		insert into accounts(login_, password_, max_characters) values
			(@login, @password, 5)
	end
end
go
--1 end

--2
drop proc character_create
go

create proc character_create(@account int, @name varchar(max), @class int, @race int)
as begin
	insert into inventories(size, fullness) values
	(10, 0)

	insert into characters(name, race, class, inventory) values
	(@name, @race, @class, (select top 1 id from inventories order by id desc))

	insert into chars_on_account(account, character_) values
	(@account, (select top 1 id from characters order by id desc))
end
go
--2 end

--3
drop proc mmmmonster_kill
go

create proc mmmmonster_kill(@char int, @monster int)
as begin
	declare @fight_result bit
	set @fight_result = (select dbo.char_monster_fight_calc(@char, @monster))
	if @fight_result = 1
	begin
		declare @monster_item int, @char_inv int

		set @char_inv = (select inventory from characters where id = @char)

		declare curs_m cursor local for (select item from items_on_monster)
		open curs_m
		fetch next from curs_m into @monster_item
		while @@FETCH_STATUS = 0
		begin
			insert into items_in_inventory(inv, item) values
			(@char_inv, @monster_item)

			update characters
				set experience += (select lvl from monsters where id = @monster) * 10
				where id = @char
			

			fetch next from curs_m into @monster_item
		end
		close curs_m
	end
end
go
--3 end

--4
drop proc raid
go

create proc raid(@raid int)
as begin
	declare @dung int, @monster int, @win_flag bit, @leader int
	set @win_flag = 1
	set @dung = (select dungeon from raid_groups where id = @raid)
	set @leader = (select leader from raid_groups where id = @raid)

	declare cur_m1 cursor local for (select monster from monsters_in_dungeon where dungeon = @dung)
	open cur_m1
	fetch next from cur_m1 into @monster
	while @@FETCH_STATUS = 0
	begin
		if not exists (select * from chars_in_raid where raid = @raid and exists (select dbo.char_monster_fight_calc(@monster, char_)))
			set @win_flag = 0

		fetch next from cur_m1 into @monster
	end
	close cur_m1

	if @win_flag = 1
	begin
		declare cur_m2 cursor local for (select monster from monsters_in_dungeon where dungeon = @dung)
		open cur_m2
		fetch next from cur_m2 into @monster
		while @@FETCH_STATUS = 0
		begin
			exec mmmmonster_kill @leader, @monster
			fetch next from cur_m2 into @monster
		end
		close cur_m2
	end
end
go
--4 end

--5
drop proc bet_on_auction
go

create proc bet_on_auction(@char int, @pos_on_auction int, @bet int)
as begin
	declare @item int, @current_price int, @ransom_price int
	set @item = (select item from items_on_auction where id = @pos_on_auction)
	set @current_price = (select current_price from items_on_auction where id = @pos_on_auction)
	set @ransom_price = (select ransom_price from items_on_auction where id = @pos_on_auction)

	if @bet > @current_price and @bet < @ransom_price
	begin
		update items_on_auction
			set current_price = @bet, last_better = @char
			where id = @pos_on_auction
		update characters
			set gold -= @bet where id = @char
	end
	else
	begin 
	if @bet > @ransom_price
	begin 
		insert into items_in_inventory(inv, item) values
		((select inventory from characters where id = @char), @item)

		delete from items_on_auction where id = @pos_on_auction

		update characters
			set gold -= @bet where id = @char
	end
	end

end
go
--5 end