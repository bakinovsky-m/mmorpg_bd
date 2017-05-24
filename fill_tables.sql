use mmorpg
go

drop proc fill_tables
go

create proc	fill_tables
as
begin

insert into races(name) values
('human'),
('elf'),
('ork'),
('undead'),
('dwarf'),
('halfling')


insert into fractions(name) values
('aliance'),
('horde'),
('neutral'),
('dominion'),
('baknirs')


insert into talants(name, min_lvl) values
('stunning', 1),
('fatty', 2),
('taunt', 0),
('stealthy', 7),
('speedy', 4)


insert into skills(name, min_lvl) values
('firebolt', 2),
('frost nova', 7),
('mind control', 25),
('stealth', 7),
('arcane missiles', 3)


insert into inventories(size, fullness) values
(17, 1),
(25, 7),
(48, 25),
(9, 7),
(14, 3)


insert into item_types(type_, feauture_name) values
('bow', 'attack'),
('sword', 'attack'),
('shield', 'defense'),
('helmet', 'defense'),
('knife', 'attack'),
('chainmail', 'defense')


insert into achievements(name) values
('very rare achievement'),
('easy-peasy'),
('beat em up'),
('100 rats are dead'),
('dranborn')


insert into quest_lines(name, description_) values
('beginning', 'here you start your journey'),
('i hate rats', 'oh dear, all my life is about fighting with rats'),
('runner', 'would you like to work as courier for me?'),
('party needs dd', 'lets  and train your skills in fighting'),
('dranslayer', 'now, ma man, you are trained enought to slay a dran. the Dran, to be clear')


insert into accounts(login_, password_, characters_count, max_characters, percentage_of_achievements) values
('admin', 'admin_pass', 0, 100, 0),
('gamemaster', 'gamemaster_pass', 0, 100, 0),
('thechoosenone', 'alwaysontop', 10, 10, 100),
('noob', '12345', 1, 5, 0),
('gaben', 'hl3confirmed', 2, 5, 24)


insert into monsters(name, lvl, health, attack, defense) values
('rat', 1, 5, 1, 0),
('gnoll', 3, 25, 3, 2),
('angry fairy', 7, 35, 5, 5),
('dranfly', 15, 150, 20, 15),
('Dran', 50, 15000, 3000, 1000)


insert into items(name, type_, feature_value, min_lvl) values
('wooden sword', 2, 1, 0),
('lden sword', 2, 100, 50),
('wooden shield', 3, 1, 0),
('thieves knife', 5, 1, 0),
('copper chainmail', 6, 1, 0),
('bow of eternity', 1, 100, 50)


insert into quests(name, description_, reward_item, reward_money, lvl, quest_line, number_in_quest_line) values
('dirty rat', 'kill one rat and i will reward you', NULL, 25, 1, 1, 1),
('harvesting', 'harvest some wood', 1, 25, 1, 1, 2),
('mining', 'mine 10 copper', 5, 25, 1, 1, 3),
('Ogrimar is waiting for you', 'pls, deliver this package to the Mayor of the Ogrimar', NULL, 100, 5, 3, 1),
('there and back again', 'thx a lot, deliver this ancinet sword back', NULL, 100, 5, 3, 2)


insert into locations(name, x_coord, y_coord, fraction) values
('Hordes territory', 250, 300, 2),
('Crater Unro', 100, 150, 2),
('Fields of lightness', 1000, 1500, 1),
('Fire mountains', 600, 750, 3),
('Iced lakes', 600, 750, 3)


insert into cities(name, location, fraction) values
('Ogrimar', 2, 2),
('Trolden', 2, 2),
('Stormgrad', 3, 1),
('Stalrn', 3, 1),
('Dalaran', 4, 3)




insert into npc(name, lvl, location) values
('Mayor of Ogrimar', 150, 1),
('Mayor of Trolden', 150, 2),
('Blacksmith of Stormgrad', 150, 3),
('Cunning guardian', 50, 5),
('Shy thief', 35, 4)


insert into auctions(name, city) values
('OggAuc', 1),
('TrolAuc', 2),
('StromAcu', 3),
('StalAcu', 4),
('The great auction of Dalaran', 5)


insert into shops(name, city) values
('Staff and food', 1),
('Murrrggglll', 2),
('Lightning', 1),
('Steel and Honor', 1),
('Market', 1)


insert into banks(name, net_name, multifraction, city) values
('OggBank', 'hordes banks', 0, 1),
('TroBank', 'hordes banks', 0, 1),
('Sberbank', 'just banks', 1, 5),
('Alfabank', 'just banks', 1, 4),
('LightOfWisdom', 'aliance banks', 0, 3)


insert into dungeons(name, min_lvl, location, achievement) values
('strange cave', 15, 2, 2),
('very strange cave', 15, 2, null),
('old castle', 25, 3, null),
('old cemetery', 25, 1, null),
('dragons mountain', 50, 4, 5)


insert into teachers(name, lvl, city) values
('master shi-fu', 50, 4),
('witch lady', 50, 1),
('Gendalf', 500, 5),
('Ip Man', 50, 5),
('Tatyana Ivanovna', 500, 1),
('midget dwarf', 15, 1),
('old jew', 15, 1),
('Lelas', 50, 3)


insert into professions(name, teacher) values
('blacksmithing', 6),
('alchemy', 2),
('jewelry', 7),
('mining', 6),
('maths', 5)


insert into classes(name, teacher) values
('mage', 3),
('warrior', 4),
('rogue', 1),
('archer', 8),
('necromancy', 2)


insert into races_classes_compatibility(race, class) values
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 1),
(2, 5),
(3, 2),
(4, 5),
(5, 2),
(6, 3),
(6, 4)


insert into guilds(name, fraction) values
('Newbies', 3),
('For Horde', 1),
('Holy Light', 2),
('PVP only', 3),
('test', 4)


insert into characters(name, race, class, health, attack, defense, experience, level_, inventory, guild, fraction) values
('TopOdinPaladin', 1, 2, 10000, 5000, 5000, 2694536178, 50, 1, 3, 1),
('Nagibator', 1, 2, 150, 11, 24, 74, 7, 2, null, 2),
('Maksim', 6, 3, 150, 11, 24, 74, 7, 3, null, 2),
('AnotherMaksim', 6, 3, 150, 11, 24, 74, 7, 4, 2, 2),
('WhoIsMaksim', 6, 3, 150, 11, 24, 74, 7, 5, 2, 2)


insert into exp_lvl_relation(exp_, lvl) values
(0, 1),
(10, 2),
(15, 3),
(22, 4),
(33, 5),
(49, 6),
(73, 7),
(109, 8),
(163, 9),
(244, 10),
(366, 11),
(549, 12),
(823, 13),
(1234, 14),
(1851, 15),
(2776, 16),
(4164, 17),
(6246, 18),
(9369, 19),
(14053, 20),
(21079, 21),
(31618, 22),
(47427, 23),
(71140, 24),
(106710, 25),
(160065, 26),
(240097, 27),
(360145, 28),
(540217, 29),
(810325, 30),
(1215487, 31),
(1823230, 32),
(2734845, 33),
(4102267, 34),
(6153400, 35),
(9230100, 36),
(13845150, 37),
(20767725, 38),
(31151587, 39),
(46727380, 40),
(70091070, 41),
(105136605, 42),
(157704907, 43),
(236557360, 44),
(354836040, 45),
(532254060, 46),
(798381090, 47),
(1197571635, 48),
(1796357452, 49),
(2694536178, 50)


insert into raid_groups(name, members_count, dungeon, leader) values
('need dd', 1, 1, 1),
('heal?', 1, 1, 2),
('maksims', 3, 3, 3)


insert into talants_on_characters(character_, talant) values
(1, 1),
(1, 3),
(2, 2),
(3, 4),
(3, 5),
(4, 4),
(4, 5),
(5, 4),
(5, 5)


insert into quest_line_on_npc(quest_line, npc) values
(1, 1),
(2, 1),
(3, 3),
(4, 4),
(5, 5)


insert into achievs_on_account(account, achievement) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into items_on_monster(monster, item) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into cell_in_bank(character_, bank) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into items_in_cell(cell, item) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into items_in_inventory(inv, item, durability_, on_char) values
(1, 3, 100, 1),
(2, 1, 100, 1),
(3, 1, 100, 1),
(4, 1, 100, 1),
(5, 1, 100, 1)


insert into chars_on_account(account, character_) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into skills_on_char(char_, skill) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into skills_on_class(class, skill) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into profs_on_char(char_, profession) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into skills_on_teacher(teacher, skill) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into skills_on_profession(profession, skill) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into items_in_shop(shop, item, price) values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5)


insert into chars_in_raid(raid, char_) values
(1, 1),
(2, 2),
(3, 3),
(3, 4),
(3, 5)


insert into monsters_in_dungeon(dungeon, monster) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)


insert into items_on_auction(auction, item, start_price, current_price, ransom_price, last_better, owner_) values
(1,1,1,1,2,2,1),
(1,2,2,2,3,2,1),
(1,3,3,3,4,2,1),
(1,4,4,4,5,2,1),
(1,5,5,5,6,2,1)


end

--exec fill_tables