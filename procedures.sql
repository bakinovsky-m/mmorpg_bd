use mmorpg;
go

-- 1
if OBJECT_ID('account_create', 'PR') is not null
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