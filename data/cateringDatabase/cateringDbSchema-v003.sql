drop table if exists venues;
create table venues (
  venueId varchar(4) primary key not null,
  venueName varchar(50),
  city varchar(10),
  state char(2),
  kosherKitchen integer);

drop table if exists parties;
create table parties (
  partyId varchar(4) primary key not null,
  venueId varchar(4),
  numGuests integer,
  cuisine varchar(20),
  customerFirstName varchar(10),
  customerLastName varchar(10),
  partyDate date,
  durationInHours integer);

drop table if exists parties_waiters;
create table parties_waiters (
  partyId varchar(4) not null,
  waiterId varchar(4) not null,
  hourlyWage numeric,
  primary key (partyId, waiterId));

drop table if exists waiters;
create table waiters (
  waiterId varchar(4) primary key not null,
  firstName varchar(10),
  lastName varchar(10),
  gender char(1));


insert into venues values('v01', 'mabrook', 'brooklyn', 'ny', 1);
insert into venues values('v02', 'mazal tov', 'brooklyn', 'ny', 1);
insert into venues values('v03', 'party place', 'new york', 'ny', 0);
insert into venues values('v04', 'happy times', 'new york', 'ny', 1);
insert into venues values('v05', 'zanzabar', 'brooklyn', 'fl', 0);

insert into parties values('p01', 'v01', 300, 'italian', 'al', 'gindy', '2019-01-01', 3);
insert into parties values('p02', 'v01', 200, 'italian', 'al', 'gindy', '2020-01-01', 2);
insert into parties values('p03', 'v01', 175, 'syrian', 'moshe', 'gindy', '2020-02-01', 2);
insert into parties values('p04', 'v01', 100, 'italian', 'ralph', 'jones', '2020-03-01', 3);
insert into parties values('p05', 'v02', 175, 'italian', 'gavriel', 'cohen', '2020-04-01', 1);
insert into parties values('p06', 'v02', 125, 'chinese', 'yoel', 'schwartz', '2020-05-01', 1);
insert into parties values('p07', 'v03', 75, NULL, 'mike', 'smith', '2020-06-01', 3);
insert into parties values('p08', 'v05', 50, 'chinese', 'larry', 'cohen', '2019-07-01', 4);
insert into parties values('p09', 'v05', 50, 'italian', 'mike', 'schatz', '2020-07-01', 4);
insert into parties values('p10', 'v05', 50, 'chinese', 'ping', 'sez', '2020-08-01', 4);

insert into parties_waiters values ('p01', 'w01', 10);
insert into parties_waiters values ('p01', 'w02', 12);
insert into parties_waiters values ('p01', 'w03', 14);
insert into parties_waiters values ('p02', 'w01', 11);
insert into parties_waiters values ('p02', 'w02', 13);
insert into parties_waiters values ('p02', 'w03', 9);
insert into parties_waiters values ('p03', 'w01', 20);
insert into parties_waiters values ('p03', 'w02', 15);
insert into parties_waiters values ('p05', 'w04', 22);

insert into waiters values('w01', 'steve', 'cohen', 'm');
insert into waiters values('w02', 'larry', 'jones', 'm');
insert into waiters values('w03', 'clara', 'jones', 'f');
insert into waiters values('w04', 'julie', 'cohen', 'f');
insert into waiters values('w05', 'frank', 'smith', 'm');
insert into waiters values('w06', 'bob', 'cohen', 'm');

select * from venues;
select * from parties;
select * from waiters;
select * from parties_waiters;

-- use update to change values in rows in a table
update venues
set venuename = 'iyH by you'
where venuename='mazal tov';

-- you can write an update command that modifies multiple rows
-- give all waiters a 10% increase in their hourly wage
update parties_waiters
set hourlywage = hourlywage * 1.1;

select * 
from parties join parties_waiters on 
     parties.partyId = parties_waiters.partyId
where customerFirstName = 'moshe' and
      customerLastName = 'gindy';
	  
-- update the hourwage of workers who are working on moshe gindy's party
-- give them a 20% raise
update parties_waiters
set hourlywage = hourlywage * 1.2 
where partyid = (  
	   select partyId
	   from parties
	   where customerFirstName = 'moshe' and 
	         customerLastName = 'gindy'
    );

select * from parties;


-- the delete SQL command deletes specific rows from a table
-- delete is different from drop
-- the drop table command drops (i.e. destroys) an entire table - i.e. the data and the structure

insert into parties (partyid, venueid, numguests, cuisine, customerFirstName, customerLastName) 
values( 'p99', 'v05', 100, NULL, 'yitz', 'rosenthal');

delete from parties
where partyid = 'p99';

-- Command that create and destroy the structure of a database are called
-- Data Definition Language commands (DDL), eg. create table, drop table



