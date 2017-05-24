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