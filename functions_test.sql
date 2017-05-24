use mmorpg;
go

--1
select dbo.finished_achievements_percent_count(2) as 'fin'
--1 end

--2
select dbo.full_def_on_char(1) as 'def'
--2 end

--4
-- strong char, weak monster
select dbo.char_monster_fight_calc(1, 1) as 'fight'
-- weak char, strong monster
select dbo.char_monster_fight_calc(2, 5) as 'fight'
--4 end

--5
insert into items_in_inventory(inv, on_char, item) values
(1, 0, 1),
(1, 0, 1),
(1, 0, 1)
select dbo.full_unwore_items_cost_on_auction(1, 1) as 'price'
--5 end