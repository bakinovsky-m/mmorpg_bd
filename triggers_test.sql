use mmorpg

--1
insert into skills_on_char(skill, char_) values
(3, 2)
--1 end

--2
select * from skills_on_char
insert into characters(name, race, class, health, attack, defense, experience, level_, inventory, guild, fraction) values
('TopOdinPaladin1', 1, 1, 10000, 5000, 5000, 2694536178, 50, 1, 3, 1)
insert into skills(name, min_lvl) values
('test', 0)
insert into skills_on_class(skill, class) values
(6, 1)
insert into skills_on_profession(profession, skill) values
(1, 6)
insert into profs_on_char(char_, profession) values
(6, 1)
select * from skills_on_char
--2 end

--3.1
insert into inventories(size, fullness) values
(10,10)
insert into items_in_inventory(inv, item) values
(6, 1)
--3.1 end

--3.2
insert into inventories(size, fullness) values
(15,10)
select * from inventories where id = 6
insert into items_in_inventory(inv, item) values (6, 5)
select * from inventories where id = 6
delete from items_in_inventory where id = 6 
select * from inventories where id = 6
--3.2 end

--4
select * from characters
update characters
	set	experience = 74 where id = 3
select * from characters
--4 end

--5
insert into chars_in_raid(char_, raid) values
(1, 3)
--5 end

--6
select * from skills_on_char
insert into skills(name, min_lvl) values
('test', 0)
insert into skills_on_class(class, skill) values
(1, 6)
insert into characters(name, race, class, health, attack, defense, experience, level_, inventory, guild, fraction) values
('TopOdinPaladin1', 1, 1, 10000, 5000, 5000, 2694536178, 50, 1, 3, 1)
select * from skills_on_char
--6 end

--7
select * from accounts
update accounts
	set characters_count = 11 where id = 3
--7 end

--8
-- tables in output should be equal after test
update accounts
	set characters_count = 10 where id = 3
select * from accounts
select * from chars_on_account
insert into characters(name, race, class, health, attack, defense, experience, level_, inventory, guild, fraction) values
('TopOdinPaladin1', 1, 1, 10000, 5000, 5000, 2694536178, 50, 1, 3, 1)
insert into chars_on_account(account, character_) values
(3, 6)
go
select * from accounts
select * from chars_on_account
--8 end

--9
select * from items_in_inventory
insert into items_in_inventory(item, inv, durability_) values
(1, 2, 100)
select * from items_in_inventory
update items_in_inventory
	set durability_ = 0 where id = 6 
select * from items_in_inventory
--9 end

--10
select * from races_classes_compatibility
select * from characters
insert into characters(name, race, class, health, attack, defense, experience, level_, inventory, guild, fraction) values
('TopOdinPaladin1', 2, 3, 10000, 5000, 5000, 2694536178, 50, 1, 3, 1)
select * from characters
--10 end

--11
insert into inventories(size, fullness) values (10, 5)
insert into characters(name, race, class, health, attack, defense, experience, level_, inventory, guild, fraction) values
('test', 1, 3, 10000, 5000, 5000, 0, 1, 6, 3, 1)
insert into items_in_inventory(item, inv, durability_) values
(2, 6, 100)
--11 end

--12
insert into items_on_auction(auction, item, start_price, current_price, ransom_price, last_better, owner_) values
(1,1,   2   ,1,   2   ,2,1)
--12 end

--13
select * from quests
insert into quests(name, description_, quest_line) values
('test', 'test', 1)
select * from quests
--13 end

--14
select * from items_in_inventory
insert into items_in_inventory(inv, item, on_char) values
(5, 2, 1)
select * from items_in_inventory
--14 end

--15
--will work
insert into banks(name, net_name, multifraction, city) values
('test', '', 1, 1)
--won't work
insert into banks(name, net_name, multifraction, city) values
('test2', 'hordes banks', 0, 3)
--15 end

--16
select * from accounts
insert into achievements(name) values
('test')
select * from accounts
--16 end

--17
insert into raid_groups(name, dungeon, leader) values
('test', 5, 2)
--17 end

--18
select * from items_in_inventory
select * from items_in_cell
delete from banks where id = 1
select * from items_in_inventory
select * from items_in_cell
--18 end

--19
select * from items_in_inventory
insert into items_on_auction(item,auction,start_price,current_price,ransom_price,last_better,owner_) values
(1,1,1,1,2,5,2)
delete from items_on_auction where owner_ = 2
select * from items_in_inventory
--19 end

--20
insert into quest_lines(name, description_) values
('test', 'test')

insert into quests(name, description_, quest_line) values
('test', 'test', 6),
('test', 'test', 6),
('test', 'test', 6)

delete from quest_lines where id = 6
--20 end