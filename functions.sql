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

--3
--3. Подсчёт количества персонажей с заданным классом старше заданного уровня
--Вход: класс, уровень
--Выход: число
--Использует: “Персонаж”
if object_id('chars_count_with_class_and_lvl', 'FN') is not null
	drop function chars_count_with_class_and_lvl
go

create function chars_count_with_class_and_lvl(@class int, @lvl int)
returns int
as
begin
	declare @res int
	set @res = (select count(*) from characters where class = @class and level_ >= @lvl)
	return @res
end
go
--3 end

--4
--4. Расчёт, успеет ли персонаж убить монстра раньше, чем монстр убьёт его
--Вход: персонаж, монстр
--Выход: да/нет
--Использует: “Персонаж”, “Монстр”
if object_id('char_monster_fight_calc', 'FN') is not null
	drop function char_monster_fight_calc
go

create function char_monster_fight_calc(@char int, @monster int)
returns bit
as
begin
	declare @c_attack int, @c_defense int, @c_health int
	declare @m_attack int, @m_defense int, @m_health int
	declare @res bit

	set @c_attack = (select attack from characters where id = @char)
	set @c_defense = (select defense from characters where id = @char)
	set @c_health = (select health from characters where id = @char)

	set @m_attack = (select attack from monsters where id = @monster)
	set @m_defense = (select defense from monsters where id = @monster)
	set @m_health = (select health from monsters where id = @monster)

	while @c_health >= 0 and @m_health >= 0
	begin
		set @c_health = @c_health - (@m_attack - @c_defense)
		set @m_health = @m_health - (@c_attack - @m_defense)
	end
	if @c_health <= 0
		set @res = 0
	else
		set @res = 1
	return @res
end
go
--4 end

--5

if object_id('full_unwore_items_cost_on_auction', 'FN') is not null
	drop function full_unwore_items_cost_on_auction
go

create function full_unwore_items_cost_on_auction(@char int, @auction int)
returns int
as
begin
	declare @price int

	declare @item int
	
	set @price = 0
	declare curs cursor for (select item from items_in_inventory where inv = (select inventory from characters where id = @char) and on_char = 0)
	open curs
	fetch next from curs into @item
	while @@FETCH_STATUS = 0
	begin
		declare @temp int
		set @temp = (select min(current_price) from items_on_auction where item = @item and auction = @auction)
		set @price += @temp

		fetch next from curs into @item
	end

	return @price
end
go

--5 end