use mmorpg
go

--1
exec dbo.account_create 'admina', 'admin_pass'
--1 end

--2
exec dbo.character_create 1, 'newchar', 1, 1
--2 end

--3
select top 1 * from characters
exec dbo.mmmmonster_kill 1, 1
select top 1 * from characters
--3 end