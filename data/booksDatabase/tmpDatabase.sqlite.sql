BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "abc" (
	"stuff"	text,
	"num"	numeric,
	"i"	integer,
	"r"	real,
	"id"	numeric,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "authors" (
	"au_id"	TEXT,
	"au_fname"	TEXT,
	"au_lname"	TEXT,
	"phone"	TEXT,
	"address"	TEXT,
	"city"	TEXT,
	"state"	TEXT,
	"zip"	INTEGER
);
INSERT INTO "abc" VALUES ('a',1,2,3.0,4);
INSERT INTO "abc" VALUES ('b',5,6,7.0,8);
INSERT INTO "authors" VALUES ('A01','Sarah','Buchman','718-496-7223','75 West 205 St','Bronx','NY',10468);
INSERT INTO "authors" VALUES ('A02','Wendy','Heydemark','303-986-7020','2922 Baseline Rd','Boulder','CO',80303);
INSERT INTO "authors" VALUES ('A03','Hallie','Hull','415-549-4278','3800 Waldo Ave, #14F','San Francisco','CA',94123);
INSERT INTO "authors" VALUES ('A04','Klee','Hull','415-549-4278','3800 Waldo Ave, #14F','San Francisco','CA',94123);
INSERT INTO "authors" VALUES ('A05','Christian','Kells','212-771-4680','114 Horatio St','New York','NY',10014);
INSERT INTO "authors" VALUES ('A06','Harvey','Kellsey','650-836-7128','390 Serra Mall','Palo Alto','CA',94305);
INSERT INTO "authors" VALUES ('A07','Paddy','O''Furniture','941-925-0752','1442 Main St','Sarasota','FL',34236);
COMMIT;
