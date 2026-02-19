BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "authors" (
	"au_id"	TEXT,
	"au_fname"	TEXT,
	"au_lname"	TEXT,
	"phone"	TEXT,
	"address"	TEXT,
	"city"	TEXT,
	"state"	TEXT,
	"zip"	TEXT,
	PRIMARY KEY("au_id")
);
CREATE TABLE IF NOT EXISTS "publishers" (
	"pub_id"	TEXT,
	"pub_name"	TEXT,
	"city"	TEXT,
	"state"	TEXT,
	"country"	TEXT,
	PRIMARY KEY("pub_id")
);
CREATE TABLE IF NOT EXISTS "royalties" (
	"title_id"	TEXT,
	"advance"	REAL,
	"royalty_rate"	REAL,
	PRIMARY KEY("title_id")
);
CREATE TABLE IF NOT EXISTS "title_authors" (
	"title_id"	TEXT,
	"au_id"	TEXT,
	"au_order"	INTEGER,
	"royalty_share"	REAL,
	PRIMARY KEY("title_id","au_id")
);
CREATE TABLE IF NOT EXISTS "titles" (
	"title_id"	TEXT,
	"title_name"	TEXT,
	"type"	TEXT,
	"pub_id"	TEXT,
	"pages"	INTEGER,
	"price"	REAL,
	"sales"	INTEGER,
	"pubdate"	TEXT,
	PRIMARY KEY("title_id")
);
INSERT INTO "authors" VALUES ('A01','Sarah','Buchman','718-496-7223','75 West 205 St','Bronx','NY','10468');
INSERT INTO "authors" VALUES ('A02','Wendy','Heydemark','303-986-7020','2922 Baseline Rd','Boulder','CO','80303');
INSERT INTO "authors" VALUES ('A03','Hallie','Hull','415-549-4278','3800 Waldo Ave, #14F','San Francisco','CA','94123');
INSERT INTO "authors" VALUES ('A04','Klee','Hull','415-549-4278','3800 Waldo Ave, #14F','San Francisco','CA','94123');
INSERT INTO "authors" VALUES ('A05','Christian','Kells','212-771-4680','114 Horatio St','New York','NY','10014');
INSERT INTO "authors" VALUES ('A06','Harvey','Kellsey','650-836-7128','390 Serra Mall','Palo Alto','CA','94305');
INSERT INTO "authors" VALUES ('A07','Paddy','O''Furniture','941-925-0752','1442 Main St','Sarasota','FL','34236');
INSERT INTO "publishers" VALUES ('P01','Abatis Publishers','New York','NY','USA');
INSERT INTO "publishers" VALUES ('P02','Core Dump Books','San Francisco','CA','USA');
INSERT INTO "publishers" VALUES ('P03','Schadenfreude Press','Hamburg',NULL,'Germany');
INSERT INTO "publishers" VALUES ('P04','Tenterhooks Press','Berkeley','CA','USA');
INSERT INTO "royalties" VALUES ('T01',10000.0,0.05);
INSERT INTO "royalties" VALUES ('T02',1000.0,0.06);
INSERT INTO "royalties" VALUES ('T03',15000.0,0.07);
INSERT INTO "royalties" VALUES ('T04',20000.0,0.08);
INSERT INTO "royalties" VALUES ('T05',100000.0,0.09);
INSERT INTO "royalties" VALUES ('T06',20000.0,0.08);
INSERT INTO "royalties" VALUES ('T07',1000000.0,0.11);
INSERT INTO "royalties" VALUES ('T08',0.0,0.04);
INSERT INTO "royalties" VALUES ('T09',0.0,0.05);
INSERT INTO "royalties" VALUES ('T10',NULL,NULL);
INSERT INTO "royalties" VALUES ('T11',100000.0,0.07);
INSERT INTO "royalties" VALUES ('T12',50000.0,0.09);
INSERT INTO "royalties" VALUES ('T13',20000.0,0.06);
INSERT INTO "title_authors" VALUES ('T01','A01',1,1.0);
INSERT INTO "title_authors" VALUES ('T02','A01',1,1.0);
INSERT INTO "title_authors" VALUES ('T03','A05',1,1.0);
INSERT INTO "title_authors" VALUES ('T04','A03',1,0.6);
INSERT INTO "title_authors" VALUES ('T04','A04',2,0.4);
INSERT INTO "title_authors" VALUES ('T05','A04',1,1.0);
INSERT INTO "title_authors" VALUES ('T06','A02',1,1.0);
INSERT INTO "title_authors" VALUES ('T07','A02',1,0.5);
INSERT INTO "title_authors" VALUES ('T07','A04',2,0.5);
INSERT INTO "title_authors" VALUES ('T08','A06',1,1.0);
INSERT INTO "title_authors" VALUES ('T09','A06',1,1.0);
INSERT INTO "title_authors" VALUES ('T10','A02',1,1.0);
INSERT INTO "title_authors" VALUES ('T11','A03',2,0.3);
INSERT INTO "title_authors" VALUES ('T11','A04',3,0.3);
INSERT INTO "title_authors" VALUES ('T11','A06',1,0.4);
INSERT INTO "title_authors" VALUES ('T12','A02',1,1.0);
INSERT INTO "title_authors" VALUES ('T13','A01',1,1.0);
INSERT INTO "titles" VALUES ('T01','1977!','history','P01',107,21.99,566,'2000-08-01');
INSERT INTO "titles" VALUES ('T02','200 Years of German Humor','history','P03',14,19.95,9566,'1998-04-01');
INSERT INTO "titles" VALUES ('T03','Ask Your System Administrator','computer','P02',1226,39.95,25667,'2000-09-01');
INSERT INTO "titles" VALUES ('T04','But I Did It Unconsciously','psychology','P04',510,12.99,13001,'1999-05-31');
INSERT INTO "titles" VALUES ('T05','Exchange of Platitudes','psychology','P04',201,6.95,201440,'2001-01-01');
INSERT INTO "titles" VALUES ('T06','How About Never?','biography','P01',473,19.95,11320,'2000-07-31');
INSERT INTO "titles" VALUES ('T07','I Blame My Mother','biography','P03',333,23.95,1500200,'1999-10-01');
INSERT INTO "titles" VALUES ('T08','Just Wait Until After School','children','P04',86,10.0,4095,'2001-06-01');
INSERT INTO "titles" VALUES ('T09','Kiss My Boo-Boo','children','P04',22,13.95,5000,'2002-05-31');
INSERT INTO "titles" VALUES ('T10','Not Without My Faberge Egg','biography','P01',NULL,NULL,NULL,NULL);
INSERT INTO "titles" VALUES ('T11','Perhaps It''s a Glandular Problem','psychology','P04',826,7.99,94123,'2000-11-30');
INSERT INTO "titles" VALUES ('T12','Spontaneous, Not Annoying','biography','P01',507,12.99,100001,'2000-08-31');
INSERT INTO "titles" VALUES ('T13','What Are The Civilian Applications?','history','P03',802,29.99,10467,'1999-05-31');
COMMIT;
