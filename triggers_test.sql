use mmorpg

--1
insert into skills_on_char(skill, char_) values
(3, 2)
--1 end

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
--(1, 1),
(1, 3)
--5 end

--7
update accounts
	set characters_count = 11 where id = 3
--7 end

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

--12
insert into items_on_auction(auction, item, start_price, current_price, ransom_price, last_better, owner_) values
(1,1,   2   ,1,   2   ,2,1)
--12 end

--17
insert into raid_groups(name, dungeon, leader) values
('test', 5, 2)
--17 end