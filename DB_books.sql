-------------------- 1.	Створити базу даних за індивідуальним варіантом.
create database books
use books;

create table books.dbo.book
 (id_book int IDENTITY(1,1) not null primary key,
 nazva nvarchar(40) constraint nazva_format check (nazva like '[А-яA-z"-"\s]%'),
 author nvarchar(40) constraint author_format check (author like '[А-яA-z"-"\s]%'),
 price decimal(6, 2),
 amount int,
 yearPubl int,
 ); 

 create table books.dbo.reader
 (ticket_number int IDENTITY(1,1) not null primary key,
 name_reader nvarchar(40) constraint name_format check (Name_reader like '[А-яA-z"-"\s]%'),
 surName_reader nvarchar(40) constraint surName_format check (surName_reader like '[А-яA-z"-"\s]%'),
 address_reader nvarchar(60) constraint add_format check (address_reader like '[0-9А-яA-z","\s"-""."]%'),
 mark_disposal int constraint mark check (mark_disposal like '[0-1]'),
 PhoneNum char(12) check (PhoneNum like '([0-9][0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
 );

 create table books.dbo.issued
 (id_issue int IDENTITY(1,1) not null primary key,
 issue_date DateTime,
 return_date DateTime,
 real_return_date DateTime,  
 id_book int not null foreign key (id_book) references books.dbo.book(id_book) on delete cascade on update no action,
 id_reader int not null foreign key (id_reader) references books.dbo.reader(ticket_number) on delete cascade on update no action
 );

 ------------------ 2.	Внети тестові записи.

SET IDENTITY_INSERT [dbo].book ON
 INSERT INTO books.dbo.book(id_book, nazva, author, price, amount, yearPubl)
	VALUES('0', 'The Bible', 'God', '600.00', '500', '1500'),
	('1', 'The case for Christ', 'Lee Strobel', '300.00', '300', '1998'),
	('2', 'David and Goliath', 'Malkolm Gladwell', '250.00', '235', '2013'),
	('3', 'Rejection Proof', 'Jia Jiang', '458.00', '467', '2015');
SET IDENTITY_INSERT [dbo].book OFF
 select * 
	from book;

update book
	set amount='501'
		where id_book=1

SET IDENTITY_INSERT [dbo].reader ON
 INSERT INTO books.dbo.reader(ticket_number, name_reader, surName_reader, PhoneNum, address_reader, mark_disposal)
	VALUES('1', 'Maria', 'Strelchenko', '(095)4789095', '1232 Seletska str, 20 Zhytomyr', '0'),
	('2', 'Anna', 'Sirach', '(068)4789988', '1222 Shevchenka str, 18 Zhytomyr', '0'),
	('3', 'Valya', 'Overchuk', '(097)1449988', '2222 Berdichivska str, 11 Zhytomyr', '0'),
	('4', 'Angelina', 'Savenko', '(050)1569979', '2222 Zarichna str, 9 Zhytomyr', '0');
SET IDENTITY_INSERT [dbo].reader OFF
select *
	from reader;

SET IDENTITY_INSERT [dbo].issued ON
INSERT INTO books.dbo.issued(id_issue, id_reader, id_book, issue_date, return_date, real_return_date)
	VALUES('0', '1', '1', '20210203', '20210305', '20210306'),
	('1', '2', '1', '20201003', '20201103', '20210403'),
	('2', '3', '3', '20200913', '20201015', '20210415'),
	('3', '4', '1', '20200902', '20201003', '20210103'),
	('4', '1', '2', '20210203', '20210305', '20210306'),
	('5', '2', '3', '20210203', '20210305', '20210306'),
	('6', '2', '3', '20000304', '20000404', '20000404'),
	('7', '4', '2', '20000404', '20000504', '20000504'),
	('8', '3', '3', '20000504', '20000530', '20000530');
SET IDENTITY_INSERT [dbo].issued OFF
delete
	from issued;

---- 3.	Створити представлення та процедури обробки даних у відповідності до індивідуального завдання.
--	Выбрать книгу, для которой наибольшее количество экземпляров находится "на полках". 
create proc MaxAmountOfCopies as
	select nazva, amount
		from book
			where amount = (select max(amount) from book)
		
exec
	 MaxAmountOfCopies

---6.	Выбрать читателей, которые имеют задолженность более 4 месяцев. 
CREATE PROC expired_mt_4mth as
select name_reader, surName_reader, return_date, real_return_date, 
			DATEDIFF(MONTH, return_date, real_return_date) as 'Expired months'
	from reader INNER JOIN issued ON reader.ticket_number = issued.id_reader
		where ABS(DATEDIFF(MONTH, real_return_date, return_date)) > 4


---7.	Определить книгу, которая была наиболее популярной весной 2000 года. 
SELECT nazva, COUNT(book.id_book) as 'Times issued'
	from book inner join issued on book.id_book = issued.id_book
		where issue_date BETWEEN '2000.03.01' AND '2000.05.31'
			GROUP BY nazva
				HAVING COUNT(book.id_book) =( 
					SELECT MAX(mycount) 
						FROM (SELECT book.id_book, COUNT(book.id_book) mycount 
									from book inner join issued on book.id_book = issued.id_book
										where issue_date BETWEEN '2000.03.01' AND '2000.05.31'
											GROUP BY book.id_book)p 
									);
								
---8.	Определить читателей, у которых на руках находятся книги на общую сумму более 100 грн. 
CREATE VIEW TotalPrices as
	select name, sum(price) as Suma
		from issued inner join book on issued.id_book=book.id_book
			group by id_reader;

CREATE PROC HAS_MORE_100 as
	select surName_reader, name_reader,  Suma
		from TotalPrices inner join reader on TotalPrices.id_reader= reader.ticket_number
			where Suma > 100		
		

-----4.	Створити наступні статистичні процедури:
--	процедуру, що визначає кількість рядків в таблицях БД і заносить результат в нову таблицю. 
CREATE PROCEDURE RowCountT
AS
BEGIN
	drop table if exists RowCounts;		
	DECLARE @readers NVARCHAR(40);
	DECLARE @books NVARCHAR(40);
	DECLARE @issued NVARCHAR(40);
	SELECT  @readers=count(*)  FROM reader
	SELECT  @books=count(*)  FROM book
	SELECT  @issued=count(*)  FROM issued
	
	DECLARE @SQLString NVARCHAR(MAX);
	SET @SQLString = 'CREATE TABLE RowCounts (TableName NVARCHAR(40), NumberOfRows NVARCHAR(40))'+
		'INSERT INTO RowCounts VALUES(''reader''  , '''+@readers+'''), (''book''  , '''+@books+'''), (''issued''  , '''+@issued+''')'+ 
		'select * from RowCounts; ';
	EXEC (@SQLString)
END

EXEC RowCountT;



CREATE PROCEDURE ColCountProc
AS
BEGIN
	DECLARE @readers NVARCHAR(40);
	DECLARE @books NVARCHAR(40);
	DECLARE @issued NVARCHAR(40);
	
	select @readers=COUNT(column_name) from information_schema.columns where table_name='reader' 
	select @books=COUNT(column_name) from information_schema.columns where table_name='book' 
	select @issued=COUNT(column_name) from information_schema.columns where table_name='issued' 
	DECLARE @SQLString NVARCHAR(MAX);
	SET @SQLString = 'CREATE TABLE newTable (TableName NVARCHAR(40), NumberOfCols NVARCHAR(40)) '+
		'INSERT INTO newTable VALUES(''reader''  , '''+@readers+'''), (''book''  , '''+@books+'''), (''issued''  , '''+@issued+''')'+ 
		'select * from newTable; ';
	EXEC (@SQLString)
	drop table if exists newTable
END

EXEC ColCountProc;


--------------
--- 	процедуру, що визначає для кожного поля таблиці, кількість значень, що не повторюються.
CREATE PROCEDURE CountDistinctValues
@table NVARCHAR(40)
AS BEGIN
DECLARE @sql varchar(4000) = (
								SELECT string_agg('select ''' + column_name  + ''' as ColumnName, COUNT(DISTINCT '+
								column_name+') as DistinctValuesCount from ' + @table, ' union ') as Query
								FROM (
									select column_name
									from information_schema.columns 
									where table_name = @table
									) p
									);
	exec(@sql)
END

EXEC CountDistinctValues @table='reader' ;


--	Тригер, що оновлює одночасно дані в двох таблицях
CREATE TRIGGER UpdateIssues ON reader AFTER UPDATE AS
SET IDENTITY_INSERT [dbo].issued ON
UPDATE issued
	set id_reader = ticket_number
		FROM INSERTED
			WHERE id_reader=ticket_number;

UPDATE reader 
	SET [name_reader]='Maria'
		WHERE [ticket_number]=2

CREATE TRIGGER OnUpdate ON reader INSTEAD OF UPDATE AS
BEGIN
	if NOT EXISTS(SELECT * FROM issued LEFT JOIN reader on reader.ticket_number=issued.id_reader WHERE reader.ticket_number is NULL)
		UPDATE reader
			set address_reader=INSERTED.address_reader, mark_disposal=INSERTED.mark_disposal, 
				name_reader=INSERTED.name_reader, surName_reader=INSERTED.surName_reader, PhoneNum=INSERTED.PhoneNum
				FROM INSERTED
					WHERE reader.ticket_number=INSERTED.ticket_number;

END

select *
FROM reader

UPDATE reader 
	SET [name_reader]='Anna'
		WHERE [ticket_number]=2
		
--	Тригер, що знищує зв’язані дані одночасно в двох таблицях
CREATE TRIGGER DelTr1 ON reader AFTER DELETE AS
BEGIN
	if EXISTS(SELECT * FROM issued LEFT JOIN reader on reader.ticket_number=issued.id_reader WHERE reader.ticket_number is NULL)
		BEGIN
			DELETE 
				FROM issued
					FROM INSERTED
					WHERE id_reader=INSERTED.ticket_number;
		END
END

select *
from issued
DELETE 
	FROM reader
		WHERE ticket_number=4;
select *
from issued

-- 	Тригер, що при знищенні перевіряє наявність в іншій таблиці даних, що відповідають заданій умові і відхиляє знищення даних
CREATE TRIGGER DelTri2 ON reader INSTEAD OF DELETE AS
BEGIN
	if EXISTS(SELECT * FROM issued INNER JOIN reader on reader.ticket_number=issued.id_reader WHERE YEAR(issued.issue_date) < YEAR(CURRENT_TIMESTAMP))
		BEGIN
			DELETE 
				FROM reader
					FROM reader INNER JOIN issued on issued.id_reader=reader.ticket_number
						WHERE YEAR(issued.issue_date) < YEAR(CURRENT_TIMESTAMP);
		END
END

select *
from reader;

DELETE 
	FROM reader;

select *
from reader;

-- 	Створити тригер, що реалізує вставку даних і зміну кількості рядків в таблиці (дані про кількість рядків в таблицях містяться в окремій таблиці).
CREATE TRIGGER InsertTrigger ON book AFTER INSERT AS
BEGIN
	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'RowCounts')
		BEGIN
			exec RowCountT;
		END
	ELSE
		BEGIN
			update RowCounts
				SET NumberOfRows = (SELECT COUNT(*) FROM book)
					WHERE TableName='book'
		END
END

SELECT *
	FROM RowCounts

SET IDENTITY_INSERT [dbo].book ON
 INSERT INTO books.dbo.book(id_book, nazva, author, price, amount, yearPubl)
	VALUES('4', 'Programming LifeHacks', 'Oleksii Chyzhmotria', '500.00', '123', '2022'), 
	('5', 'Junior Programming', 'Strelchenko John', '400.00', '400', '2021');
SET IDENTITY_INSERT [dbo].book OFF

SELECT *
	FROM RowCounts

use books
/*Створення користувача*/
create login anna with password = '1111'
create user kr_user for login  anna
--
grant select on book to kr_user
grant select on issued to kr_user
grant select on reader to kr_user



