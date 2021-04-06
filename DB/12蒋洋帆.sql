--�������ݿ�
USE master
GO
-- Drop the database if it already exists
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'ExampleDB')
DROP DATABASE ExampleDB
GO
create database ExampleDB
on primary
(name=LoginDB_data, 
 filename='d:\data\ExampleDB_data.mdf',
 size=5,
 filegrowth=20%)
 log on
 (name=LoginDB_log,
  filename='d:\data\ExampleDB_log.ldf',    size=2mb,
  filegrowth=1mb)
GO

--������
Use ExampleDB
GO
--������־��
go
if OBJECT_ID('Syslog','U')is not null
	drop table SysLog
GO
create table  Syslog(
userid bigint,
dtime nchar(50),
daction nchar(50),
)




if OBJECT_ID('Users','U')is not null
	drop table Users
GO

create table  Users(
userid  bigint primary key identity(1,1),--��½�˺�
username varchar(30) not null unique,
role	varchar(30) default '����Ա',
userpassword varchar(30) not null,
userlevel tinyint
)
go

if OBJECT_ID('student','U')is not null
	drop table student
GO
create table student(
stuxuehao bigint primary key identity(2021,1),--ѧ�ţ�Ĭ��Ϊѧ����¼�˺ţ�
stuname nvarchar(10),
stupasswd   bigint not null,
stugrade varchar(30),
stubanji varchar(30),
stusex varchar(2) ,
role	varchar(30) default 'ѧ��',
)
go

go


if OBJECT_ID('class','U')is not null
	drop table class
GO
create table class
(	claid bigint primary key identity(1,1),
	claname nvarchar(30) not null,
	teacherid varchar(30),
	teachername varchar(30),
	term varchar(30) not null,
	condition varchar(30)
)


if OBJECT_ID('sctime','U')is not null
	drop table sctime
GO
create table  sctime(
sctimeid bigint primary key identity(1,1),--�Ͽ�ʱ��id
claid bigint,--�γ̵�id
teacherid bigint,
sctime varchar(30),--�Ͽ�ʱ��
location varchar(30),--�Ͽεص�
term varchar(30) not null
)

go


if OBJECT_ID('sc','U')is not null--��¼ѡ�ε�ѧ��ѧ�ţ��γ̺ţ�ѧ�ڣ��ɼ�
	drop table sc
GO
create table  sc(
scid  bigint primary key identity(1,1),
stuxuehao bigint,
claid bigint,
grades bigint,
term varchar(30) not null
)

GO
if OBJECT_ID('Teacher','U')is not null
	drop table Teacher
GO
create table Teacher(
teachbm  bigint primary key identity(2021,1),--��ʦ�ţ�Ĭ��Ϊ��¼�˺ţ�
tname nvarchar(10),
teachpasswd bigint not null,
telephone varchar(30),
addr varchar(60),
teachsort varchar(10),
tsex varchar(2) ,
role	varchar(30) default '��ʦ',
)
go

insert into Users values('001','����Ա','admin',0)


GO
--�����洢����
--UserLogin
--1 �û����Ϳ������ȷ������1
--2 �û�����ȷ�����ȷ������2
--3 �û�������ȷ������3

IF OBJECT_ID('UserLogin','p') is not null
	DROP PROCEDURE UserLogin
GO

create procedure [dbo].[userLogin]
	@userID nchar(6),
	@password nchar(6)
as
if exists(select * from Users where username=@userID and userpassword =@password)
	return 1;
if exists(select * from Users where username=@userID and userpassword  <>@password)
	return 2;
if exists(select * from Users where username<>@userID  )
	return 3;
GO





IF OBJECT_ID('stuLogin','p') is not null--ѧ����¼
	DROP PROCEDURE stuLogin
GO

create procedure [dbo].[stuLogin]
	@stuID nchar(30),
	@password nchar(30)
as
if exists(select * from student where stuxuehao=@stuID and stupasswd =@password)
	return 1;
if exists(select * from student where stuxuehao=@stuID and stupasswd  <>@password)
	return 2;
if exists(select * from student where stuxuehao<>@stuID  )
	return 3;
GO


IF OBJECT_ID('teachLogin','p') is not null--��ʦ��¼
	DROP PROCEDURE teachLogin
GO

create procedure [dbo].[teachLogin]
	@teachID nchar(30),
	@password nchar(30)
as
if exists(select * from Teacher where teachbm=@teachID and teachpasswd =@password)
	return 1;
if exists(select * from Teacher where teachbm=@teachID and teachpasswd  <>@password)
	return 2;
if exists(select * from Teacher where teachbm<>@teachID  )
	return 3;
GO



select * from mycourse5
--������ͼ �ҵĿα�
CREATE VIEW mycourse5 AS
SELECT class.claid,class.claname,class.teachername,location,sctime.term,sc.stuxuehao,sctime.sctime
FROM class,sctime,sc
where sc.claid=class.claid and class.claid=sctime.claid
go
--������ͼ ������ʦ����Ŀγ�
CREATE VIEW allcourse AS
SELECT class.claid,class.claname,sctime,location,sctime.term,class.teachername
FROM class,sctime
where class.claid=sctime.claid 
go
/*---��ͼ������ɾ��
IF (EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME=N'd'))
DROP VIEW d
go*/
--������ͼ  �鿴�ҵ�ѧ��
CREATE VIEW ownstu2 AS
SELECT student.stuxuehao,student.stuname,student.stugrade,student.stubanji,student.stusex,class.claname,class.teacherid,sc.grades,class.term,class.claid
FROM class,sc,student
where class.claid=sc.claid and sc.stuxuehao=student.stuxuehao
go


--������ͼ �鿴��ʦ�α�
CREATE VIEW teachclass1 AS
SELECT class.claid,class.claname,class.teacherid,Teacher.tname,class.term,Teacher.teachsort,Teacher.tsex
FROM class,Teacher
where class.teacherid=Teacher.teachbm
go
select * from teachclass1
go
--������ͼ �鿴ѡ�γɼ�
CREATE VIEW mygrades AS
SELECT class.claname,class.teachername,class.term,sc.stuxuehao,sc.grades
FROM class,sc
where class.claid=sc.claid
go
select * from mygrades


go
--������ͼ ��ʦ�鿴�Լ��α�
CREATE VIEW mywork1 AS
SELECT class.claname,sctime.location,sctime.sctime,class.term,sctime.teacherid
FROM class,sctime
where class.claid=sctime.claid
go
select * from mywork1
go
--����������--ɾ��sctime��Ŀ�֮��ɾ��class��Ӧ�Ŀγ�
CREATE TRIGGER d
ON sctime
after delete
as 
begin
declare @id int
select @id=claid from deleted
delete from class where claid=(@id)
end
go

--����������--ɾ��teacher��Ľ�ʦ֮��ɾ����Ӧ�Ŀγ�
CREATE TRIGGER dt
ON Teacher
after delete
as 
begin
declare @id int
select @id=teachbm from deleted
delete from class where teacherid=(@id)
delete from sctime where teacherid=(@id)
end
go



select * from Teacher
select * from class

select * from sctime
select * from sc
select * from student
delete from sc where scid=2

select claname as �γ���,teachername as �ο���ʦ,term as ѧ�� from mygrades

update student set stugrade="�����꼶",stugrade="�����꼶",stugrade="�ѱ�ҵ" where stugrade="��һ�꼶"