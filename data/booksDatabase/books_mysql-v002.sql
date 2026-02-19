# NOTE:
# If the tables don't already exist the DROP TABLE statements
# will fail with an error. 
# You can avoid those errors by changing commands such as 
#    DROP TABLE authors;
# to
#    DROP TABLE IF EXISTS authors;
#
# The "IF EXISTS" version of the command will not fail if the
# table doesn't exist. However, be aware that this is DANGEROUS.
# It's often better to get an Error than to 
# remove a table by mistake.

DROP TABLE authors;
CREATE TABLE authors
  (
  au_id    CHAR(3)     NOT NULL,
  au_fname VARCHAR(15) NOT NULL,
  au_lname VARCHAR(15) NOT NULL,
  phone    VARCHAR(12)         ,
  address  VARCHAR(20)         ,
  city     VARCHAR(15)         ,
  state    CHAR(2)             ,
  zip      CHAR(5)             ,
  CONSTRAINT pk_authors PRIMARY KEY (au_id)
  );

DROP TABLE publishers;
CREATE TABLE publishers
  (
  pub_id   CHAR(3)     NOT NULL,
  pub_name VARCHAR(20) NOT NULL,
  city     VARCHAR(15) NOT NULL,
  state    CHAR(2)             ,
  country  VARCHAR(15) NOT NULL,
  CONSTRAINT pk_publishers PRIMARY KEY (pub_id)
  );

DROP TABLE titles;
CREATE TABLE titles
  (
  title_id   CHAR(3)      NOT NULL,
  title_name VARCHAR(40)  NOT NULL,
  type       VARCHAR(10)          ,
  pub_id     CHAR(3)      NOT NULL,
  pages      INTEGER              ,
  price      DECIMAL(5,2)         ,
  sales      INTEGER              ,
  pubdate    DATE                 ,
  contract   SMALLINT     NOT NULL,
  CONSTRAINT pk_titles PRIMARY KEY (title_id)
  );

DROP TABLE title_authors;
CREATE TABLE title_authors
  (
  title_id      CHAR(3)      NOT NULL,
  au_id         CHAR(3)      NOT NULL,
  au_order      SMALLINT     NOT NULL,
  royalty_share DECIMAL(5,2) NOT NULL,
  CONSTRAINT pk_title_authors PRIMARY KEY (title_id, au_id)
  );

DROP TABLE royalties;
CREATE TABLE royalties
  (
  title_id     CHAR(3)      NOT NULL,
  advance      DECIMAL(9,2)         ,
  royalty_rate DECIMAL(5,2)         ,
  CONSTRAINT pk_royalties PRIMARY KEY (title_id)
  );

INSERT INTO authors VALUES('A01','Sarah','Buchman','718-496-7223',
  '75 West 205 St','Bronx','NY','10468');
INSERT INTO authors VALUES('A02','Wendy','Heydemark','303-986-7020',
  '2922 Baseline Rd','Boulder','CO','80303');
INSERT INTO authors VALUES('A03','Hallie','Hull','415-549-4278',
  '3800 Waldo Ave, #14F','San Francisco','CA','94123');
INSERT INTO authors VALUES('A04','Klee','Hull','415-549-4278',
  '3800 Waldo Ave, #14F','San Francisco','CA','94123');
INSERT INTO authors VALUES('A05','Christian','Kells','212-771-4680',
  '114 Horatio St','New York','NY','10014');
INSERT INTO authors VALUES('A06','','Kellsey','650-836-7128',
  '390 Serra Mall','Palo Alto','CA','94305');
INSERT INTO authors VALUES('A07','Paddy','O''Furniture','941-925-0752',
  '1442 Main St','Sarasota','FL','34236');

INSERT INTO publishers VALUES('P01','Abatis Publishers','New York','NY','USA');
INSERT INTO publishers VALUES('P02','Core Dump Books','San Francisco','CA','USA');
INSERT INTO publishers VALUES('P03','Schadenfreude Press','Hamburg',NULL,'Germany');
INSERT INTO publishers VALUES('P04','Tenterhooks Press','Berkeley','CA','USA');

INSERT INTO titles VALUES('T01','1977!','history','P01',
  107,21.99,566,DATE '2000-08-01',1);
INSERT INTO titles VALUES('T02','200 Years of German Humor','history','P03',
  14,19.95,9566,DATE '1998-04-01',1);
INSERT INTO titles VALUES('T03','Ask Your System Administrator','computer','P02',
  1226,39.95,25667,DATE '2000-09-01',1);
INSERT INTO titles VALUES('T04','But I Did It Unconsciously','psychology','P04',
  510,12.99,13001,DATE '1999-05-31',1);
INSERT INTO titles VALUES('T05','Exchange of Platitudes','psychology','P04',
  201,6.95,201440,DATE '2001-01-01',1);
INSERT INTO titles VALUES('T06','How About Never?','biography','P01',
  473,19.95,11320,DATE '2000-07-31',1);
INSERT INTO titles VALUES('T07','I Blame My Mother','biography','P03',
  333,23.95,1500200,DATE '1999-10-01',1);
INSERT INTO titles VALUES('T08','Just Wait Until After School','children','P04',
  86,10.00,4095,DATE '2001-06-01',1);
INSERT INTO titles VALUES('T09','Kiss My Boo-Boo','children','P04',
  22,13.95,5000,DATE '2002-05-31',1);
INSERT INTO titles VALUES('T10','Not Without My Faberge Egg','biography','P01',
  NULL,NULL,NULL,NULL,0);
INSERT INTO titles VALUES('T11','Perhaps It''s a Glandular Problem','psychology','P04',
  826,7.99,94123,DATE '2000-11-30',1);
INSERT INTO titles VALUES('T12','Spontaneous, Not Annoying','biography','P01',
  507,12.99,100001,DATE '2000-08-31',1);
INSERT INTO titles VALUES('T13','What Are The Civilian Applications?','history','P03',
  802,29.99,10467,DATE '1999-05-31',1);

INSERT INTO title_authors VALUES('T01','A01',1,1.0);
INSERT INTO title_authors VALUES('T02','A01',1,1.0);
INSERT INTO title_authors VALUES('T03','A05',1,1.0);
INSERT INTO title_authors VALUES('T04','A03',1,0.6);
INSERT INTO title_authors VALUES('T04','A04',2,0.4);
INSERT INTO title_authors VALUES('T05','A04',1,1.0);
INSERT INTO title_authors VALUES('T06','A02',1,1.0);
INSERT INTO title_authors VALUES('T07','A02',1,0.5);
INSERT INTO title_authors VALUES('T07','A04',2,0.5);
INSERT INTO title_authors VALUES('T08','A06',1,1.0);
INSERT INTO title_authors VALUES('T09','A06',1,1.0);
INSERT INTO title_authors VALUES('T10','A02',1,1.0);
INSERT INTO title_authors VALUES('T11','A03',2,0.3);
INSERT INTO title_authors VALUES('T11','A04',3,0.3);
INSERT INTO title_authors VALUES('T11','A06',1,0.4);
INSERT INTO title_authors VALUES('T12','A02',1,1.0);
INSERT INTO title_authors VALUES('T13','A01',1,1.0);

INSERT INTO royalties VALUES('T01',10000,0.05);
INSERT INTO royalties VALUES('T02',1000,0.06);
INSERT INTO royalties VALUES('T03',15000,0.07);
INSERT INTO royalties VALUES('T04',20000,0.08);
INSERT INTO royalties VALUES('T05',100000,0.09);
INSERT INTO royalties VALUES('T06',20000,0.08);
INSERT INTO royalties VALUES('T07',1000000,0.11);
INSERT INTO royalties VALUES('T08',0,0.04);
INSERT INTO royalties VALUES('T09',0,0.05);
INSERT INTO royalties VALUES('T10',NULL,NULL);
INSERT INTO royalties VALUES('T11',100000,0.07);
INSERT INTO royalties VALUES('T12',50000,0.09);
INSERT INTO royalties VALUES('T13',20000,0.06);