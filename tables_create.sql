use mmorpg;
go

--drop proc tables_create
--go

--create proc tables_create
--as
--begin

exec drop_all_tables

create table races(
id int primary key identity(1,1),
name varchar(max) not null
);
--go

create table fractions(
id int primary key identity(1,1),
name varchar(max) not null
);
--go

create table talants(
id int primary key identity(1,1),
name varchar(max) not null,
min_lvl int
);
--go

create table skills(
id int primary key identity(1,1),
name varchar(max) not null,
min_lvl int
);
--go

create table inventories(
id int primary key identity(1,1),
size int not null,
fullness int
);
--go

create table item_types(
id int primary key identity(1,1),
type_ varchar(max),
feauture_name varchar(max)
);
--go

create table achievements (
id int primary key identity(1,1),
name varchar(max) not null,
--percentage_of_completion int
);
--go

create table quest_lines(
id int primary key identity(1,1),
name varchar(max) not null,
description_ varchar(max) not null
);
--go

create table accounts (
id int primary key identity(1,1),
login_ varchar(max) not null,
password_ varchar(max) not null,
characters_count int,
max_characters int not null,
percentage_of_achievements float
);
--go

create table monsters (
id int primary key identity(1,1),
name varchar(max) not null,
lvl int not null,
health int not null,
attack int,
defense int,
--location int not null,

--constraint fk_monsters_location foreign key(location) references locations(id)
);
--go

-- —¬≈–’” ¬—® ¡≈« ——€ÀŒ 


create table items(
id int primary key identity(1,1),
name varchar(max) not null,
type_ int not null,
feature_value int,
min_lvl int,

constraint fk_items_type foreign key(type_) references item_types(id)
--constraint fk_items_type foreign key(type_) references item_types(type_)
);
--go

create table quests (
id int primary key identity(1,1),
name varchar(max) not null,
description_ varchar(max) not null,
reward_item int,
reward_money int,
lvl int,
quest_line int,
number_in_quest_line int,

constraint fk_quests_reward_item foreign key(reward_item) references items(id),
constraint fk_quests_quest_line foreign key(quest_line) references quest_lines(id)
--foreign key(quest_line) references quest_lines(id)
);
--go

create table locations(
id int primary key identity(1,1),
name varchar(max) not null,
x_coord int not null,
y_coord int not null,
fraction int not null,

constraint fk_locations_fraction foreign key(fraction) references fractions(id)
);
--go

create table cities (
id int primary key identity(1,1),
name varchar(max) not null,
location int not null,
fraction int not null,

constraint fk_cities_location foreign key(location) references locations(id),
constraint fk_cities_fraction foreign key(fraction) references fractions(id)
);
--go

-- Œ“—ﬁƒ¿ ÃŒ∆ÕŒ ¬—® — √Œ–Œƒ¿Ã» » ÀŒ ¿÷»ﬂÃ»


create table npc (
id int primary key identity(1,1),
name varchar(max) not null,
lvl int not null,
location int,

constraint fk_npc_location foreign key(location) references locations(id)
);
--go

create table auctions(
id int primary key identity(1,1),
name varchar(max) not null,
city int

constraint fk_auctions_city foreign key(city) references cities(id)
);
--go

create table shops(
id int primary key identity(1,1),
name varchar(max) not null,
city int

constraint fk_shop_city foreign key(city) references cities(id)
);
--go

create table banks (
id int primary key identity(1,1),
name varchar(max) not null,
net_name varchar(max) not null,
multifraction bit,
city int not null,

constraint fk_banks_city foreign key(city) references cities(id)
);
--go

create table dungeons (
id int primary key identity(1,1),
name varchar(max) not null,
min_lvl int,
location int,
achievement int,

constraint fk_dungeons_location foreign key(location) references locations(id),
constraint fk_dungeons_achievement foreign key(achievement) references achievements(id)
);
--go

create table teachers(
id int primary key identity(1,1),
name varchar(max) not null,
lvl int not null,
city int not null,

constraint fk_teachers_city foreign key(city) references cities(id)
);
--go

create table professions (
id int primary key identity(1,1),
name varchar(max) not null,
teacher int not null,

constraint fk_professions_teacher foreign key(teacher) references teachers(id)
);
--go

create table classes(
id int primary key identity(1,1),
name varchar(max),
teacher int not null

constraint fk_classes_teacher foreign key(teacher) references teachers(id)
);
--go

create table races_classes_compatibility (
race int not null,
class int not null,

constraint fk_r_c_comp_race foreign key(race) references races(id),
constraint fk_r_c_comp_class foreign key(class) references classes(id),
);
--go

create table guilds(
id int primary key identity(1,1),
name varchar(max) not null,
fraction int not null,

constraint fk_guild_fraction foreign key(fraction) references fractions(id)
);
--go

create table characters (
id int primary key identity(1,1),
name varchar(max) not null,
race int not null,
class int not null,

health int not null,
attack int,
defense int,

experience bigint,
level_ int not null,
inventory int not null,
guild int,
fraction int,

constraint fk_characters_race foreign key(race) references races(id),
constraint fk_characters_class foreign key(class) references classes(id),
constraint fk_characters_inventory foreign key(inventory) references inventories(id),
constraint fk_characters_guild foreign key(guild) references guilds(id),
constraint fk_characters_fraction foreign key(fraction) references fractions(id),
);
--go

create table exp_lvl_relation(
exp_ bigint,
lvl int not null
);
--go

create table raid_groups (
id int primary key identity(1,1),
name varchar(max) not null,
members_count int,
dungeon int not null,
leader int not null,

constraint fk_raid_dungeon foreign key(dungeon) references dungeons(id),
constraint fk_raid_leader foreign key(leader) references characters(id),
);
--go

-- —¬ﬂ«”ﬁŸ»≈ «ƒ≈—‹
create table talants_on_characters(
character_ int not null,
talant int not null,

constraint fk_tal_on_char_char foreign key(character_) references characters(id),
constraint fk_tal_on_char_tal foreign key(talant) references talants(id)
);
--go

create table quest_line_on_npc(
quest_line int not null,
npc int not null,

constraint fk_qu_l_on_npc_ql foreign key(quest_line) references quest_lines(id),
constraint fk_qu_l_on_npc_npc foreign key(npc) references npc(id)
);
--go

create table achievs_on_account(
account int not null,
achievement int not null,

constraint fk_ach_on_acc_acc foreign key(account) references accounts(id),
constraint fk_ach_on_acc_ach foreign key(achievement) references achievements(id)
);
--go

create table items_on_monster(
monster int not null,
item int not null,

constraint fk_it_on_mon_monster foreign key(monster) references monsters(id),
constraint fk_it_on_mon_item foreign key(item) references items(id)
);
--go

create table cell_in_bank(
id int primary key identity(1,1),
character_ int not null,
bank int not null,

constraint fk_cell_in_bank_char foreign key(character_) references characters(id),
constraint fk_cell_in_bank_bank foreign key(bank) references banks(id)
);
--go

create table items_in_cell(
cell int not null,
item int not null,

constraint fk_items_in_cell_cell foreign key(cell) references cell_in_bank(id),
constraint fk_items_in_cell_item foreign key(item) references items(id)
);
--go

create table items_in_inventory(
id int identity(1,1),
inv int not null,
item int not null,

durability_ int default 100,
on_char bit default 0,

constraint fk_items_in_inv_item foreign key(item) references items(id),
constraint fk_items_in_inv_inv foreign key(inv) references inventories(id)
);
--go

create table chars_on_account(
character_ int not null,
account int not null,

constraint fk_chars_on_account_char foreign key(character_) references characters(id),
constraint fk_chars_on_account_acc foreign key(account) references accounts(id)
);
--go

create table skills_on_char (
char_ int not null,
skill int not null,

constraint fk_skills_on_char_char foreign key(char_) references characters(id),
constraint fk_skills_on_char_skill foreign key(skill) references skills(id),
);
--go

create table skills_on_class (
class int not null,
skill int not null,

constraint fk_skills_on_class_char foreign key(class) references classes(id),
constraint fk_skills_on_class_skill foreign key(skill) references skills(id),
);
--go

create table profs_on_char (
char_ int not null,
profession int not null,

constraint fk_profs_on_char_char foreign key(char_) references characters(id),
constraint fk_profs_on_char_prof foreign key(profession) references professions(id),
);
--go

create table skills_on_teacher(
teacher int not null,
skill int not null,

constraint fk_skills_on_teacher_teacher foreign key(teacher) references teachers(id),
constraint fk_skills_on_teacher_skill foreign key(skill) references skills(id)
);
--go

create table skills_on_profession(
profession int not null,
skill int not null,

constraint fk_skills_on_profession_profession foreign key(profession) references professions(id),
constraint fk_skills_on_profession_skill foreign key(skill) references skills(id)
);
--go

create table items_in_shop(
item int not null,
shop int not null,
price int not null,

constraint fk_items_in_shop_item foreign key(item) references items(id),
constraint fk_items_in_shop_shop foreign key(shop) references shops(id)
);
--go

create table chars_in_raid(
char_ int not null,
raid int not null,

constraint fk_char_on_raid_char foreign key(char_) references characters(id),
constraint fk_char_on_raid_raid foreign key(raid) references raid_groups(id)
);
--go

create table monsters_in_dungeon(
monster int not null,
dungeon int not null,

constraint fk_monsters_in_dungeon_monster foreign key(monster) references monsters(id),
constraint fk_monsters_in_dungeon_dungeon foreign key(dungeon) references dungeons(id)
);
--go

create table items_on_auction(
item int not null,
auction int not null,
start_price int not null,
current_price int not null,
ransom_price int not null,
last_better int,
owner_ int not null,

constraint fk_items_on_auction_item foreign key(item) references items(id),
constraint fk_items_on_auction_autcion foreign key(auction) references auctions(id),
constraint fk_items_on_auction_last_better foreign key(last_better) references characters(id),
constraint fk_items_on_auction_owner foreign key(owner_) references characters(id),
);
--go

exec fill_tables

--end

--exec tables_create