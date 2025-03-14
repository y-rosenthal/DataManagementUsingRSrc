###############################################################################.
#
# "going beyond sqldf"   -   Connecting to databases through R  -  
#
# In this section we will go beyond using sqldf to manipulate dataframes in R.
# We will learn about how to interact with an actual database management system
# from within R.
#
###############################################################################.

###############################################################################.
#
# Resources for learning more about working with databases in R
#
# Best Practices in Working with Databases (in RStudio)
#    https://solutions.posit.co/connections/db/
#
# Datacamp Tutorial
#    https://www.datacamp.com/community/tutorials/sqlite-in-r
#
# vignette("spec", package="DBI")
#
# help(package="DBI")
#
# Functions we will use:
#    dbConnect
#    dbExecute    # create table, insert , update, delete, etc.
#
#    dbGetQuery   # select (interactive work)
#
#    dbSendQuery  # select (batched work)
#    dbFetch
#    dbClearResult
###############################################################################.


#-------------------------------------
# sqldf is not enough
#-------------------------------------

# As you have already learned, SQL is a standard language for manipulating data
# that is stored in a relational database. There are many different relational
# database management system products and each one uses SQL to manipulate the
# data in the database.

# We started learning about the SQL select statement by using the sqldf
# function from the sqldf package to manipulate R dataframes with 
# SQL select statements. However, sqldf does NOT allow you to manipulate
# data that is stored in an actual database. The purpose for sqldf is to allow
# R programmers who are familiar with SQL SELECT statements 
# to use their knowledge to manipulate R dataframes. This is very useful as 
# SQL is an extremely popular language that is widely known and understood.
# However, in order to use SQL to manipulate data in an ACTUAL database, R programers
# must use functions from packages other than sqldf. 


#-------------------------------------------------------------------
# More about Relational Database Management System (RDBMS) software
#-------------------------------------------------------------------

# Relational database management system (RDBMS) products aim to provide a highly
# efficient mechanism to store and retrieve data. Depending on the specific
# RDBMS product, the type of computer (and many other details) a relational
# database management system may able to read and write thousands or even
# millions or billions of data values per second. To achieve this level of
# efficiency often requires these products to integrate tightly with the
# underlying computer in technical ways that go beyond what many other software
# products require. Therefore installing and getting these products to work
# correctly can sometimes be a little complex and require more than just running
# a simple install program.
#
# Relational Database Management Systems differ from programs such as Excel that
# are designed for people to interact with them directly. Relational Database
# Management System (RDBMS) software products are designed to allow other
# computer programs to store and retrieve data from them. For example a program
# written in R (or any other language) can store and retrieve data from an
# RDBMS. These other computer programs (such as an R program) are in turn used
# by business people to do their work. Typically, data technologists (e.g.
# programmers data analysts, etc) write the programs (e.g. in R) that are used
# by business people (e.g. traders, accountants). The data technologists use SQL
# and R (or another programming language) to create easy to use tools for the
# business people. In our class we will learn how to write R programs to send
# and retrieve data from an RDBMS.

#--------------------------------------------------------------------------
# CLIENTS AND SERVERS
#
#   - client programs
#   - server programs
#
#   - client computers
#   - server computers
#--------------------------------------------------------------------------

# An RDBMS software program is known as a "server program" (it "serves up"
# information). The computer programs that send and retrieve data from the RDBMS
# program are known as "client programs". In a similar way, the programs that 
# run websites are known as "(web) server programs" (they also serve up information)
# while web browsers are known as "client programs".

# Most relational database management systems are intended to be used
# "remotely". In other words, the relational database management system is
# installed one computer and the computer programs that send and retrieve data
# from the RDBMS are located on other computers. The computer that the RDBMS is
# installed on is known as a "server computer" (the "server program" is
# installed on the "server computer"). A computer that has software installed on
# it that interacts with the RDBMS is known as a "client computer" (a "client
# program" is installed on a "client computer"). The client program and server
# program may communicate over the Internet or over a local computer network
# (e.g. a network of computers in a company that is not accessible from the
# larger Internet).
#
# It is also possible for client programs and server programs to be
# installed on the same computer. The details as to which computer each 
# program is installed on (whether the same computer or different computers)
# is a detail that should not affect the way client programs are written.
# Often when creating a new program (e.g. an R program) the developer has 
# both the server program (e.g. the RDBMS software) and the client program
# (e.g. the program they are creating) installed on their personal computer.
# When the program is eventually used by business users, the program could 
# then be configured to communicate with a different server computer. The
# specifics of how exactly this is done is beyond the scope of what we are learning
# in this class. 
#

#--------------------------------------------------------------------
# Different RDBMS software packages
#--------------------------------------------------------------------
# Some popular RDBMS packages that can be downloaded and installed on your
# computer for free are:
#
#   - MySQL available for Windows/Mac/Linux https://www.mysql.com/
#
#     The installation of MySql can be somewhat complex. There are multiple
#     different products to choose between and may require "administrator privileges"
#     to install correctly. Nevertheless, it should be possible for you to install
#     and use MySql without too much hassle. However, the complications in my mind
#     do not make this an ideal solution for use in a classroom setting.
#
#   - PostgreSQL available for Windows/Mac/Linux https://www.postgresql.org/
#
#   - Microsoft SQL Server Express 
#     available for Windows/Linux (not for Mac)
#     https://www.microsoft.com/en-us/sql-server/sql-server-downloads
#     NOTE: There are many different versions of "Microsoft SQL Server" software
#           the "Express" version is the "free" version.
#
#     For Windows users, this is a wonderful product that is much easier to use
#     than MySql. However, Microsoft SQL Server is  NOT available "out of the box" for Mac. 
#     While, you can find information online about how to install SQL Server on Macs,
#     this requires using Docker software - which itself has a learning curve.
#     If you own a mac and want to try it anyway
#     you can see this page - https://database.guide/how-to-install-sql-server-on-a-mac/
#     or search online for many other websites that have similar information.
#
#
#   - SQLite (https://www.sqlite.org/)
#
#     This is a "simple" relational database management system. It is designed
#     to be used only "locally", not over a computer network. In other words,
#     the client program (e.g. an R program) that interacts with the RDBMS is
#     expected to be installed on the same computer as the SQLite software. This
#     software lacks many of the more sophisticated features found in other
#     products. SQLite is not designed to be used with tremendous amounts of
#     information. However, SQLite does allow programs that communicate via SQL
#     to store their information in a database without too much hassle. This
#     product is often used by computer programs and apps that don't require
#     tremendous amounts of data to store and retrieve data in a relational
#     database.
#
#
#     DIFFERENT OPTIONS TO INSTALL SQLite
#
#     Installation of SQLite is relatively straight forward. The entire SQLite
#     program is contained in a single "executable file" that can be downloaded
#     from the SQLite website. This software does NOT have a "graphical user
#     interface (GUI)". Rather the program presents a simple "command line"
#     interface - similar to R - in which you can type commands and see the
#     results.
#
#     In addition to the "plain vanilla" SQLite that is distributed by
#     sqlite.org, there are other add-on programs that you can download to
#     provide a more "friendly" GUI user interface. One such program is "SQLite
#     Studio" (https://sqlitestudio.pl/). The latest version of SQLite Studio
#     also does not come with an installation program. Just a zip file that
#     contains all the files that the program needs to run. To use this program,
#     unzip the downloaded file and run the program that is in the file named
#     SQLiteStudio.exe.
#
#     To use SQLite from within R does not require downloading any files from
#     the SQLite website or any other website. Rather the RSQLite package in R
#     has all of the functionality needed to use SQLite built into it. In our
#     class we will be using the RSQLite package to interface with the SQLite
#     database.
#--------------------------------------------------------------------.

#--------------------------------------------------------------------.
# sqlfiddle.com
#--------------------------------------------------------------------.
# sqlfiddle.com - you can use this website to try different flavors of sql.
# You can choose the flavor of SQL to use from a dropdown list, (e.g.
# MySQL, PostgreSQL, SQLite, Oracle)
#
# On the left side of the sqlfiddle.com screen you create tables and 
# and insert and modify data by using CREATE TABLE, INSERT, UPDATE and DELETE
# SQL statements.
#
# On the right side of the sqlfiddle.com screen you can enter 
# SELECT statements that manipulate the data.
#
# EXAMPLE - click on the following URL:
#            http://sqlfiddle.com/#!17/8efb57/8
# To see the following database tables and sample data running in the
# sqlfiddle.com website.
#   
#   +---------------------+           +----------------------+
#   |  venues             |           |  parties             |
#   +---------------------+           +----------------------+
#   | PK   venueId        |           | PK  partyId          |
#   |                     |           |                      |
#   |      venueName      |           | FK  venueId          | 
#   |                     | |        /|                      |
#   |      city           +-+---------+     numGuests        |
#   |                     | |        \|                      |
#   |      state          |           |     cuisine          |
#   |                     |           |                      |
#   |      kosherKitchen  |           |     customerFirstName|
#   |                     |           |                      |
#   |                     |           |     customerLastName |
#   |                     |           |                      |
#   |                     |           |     partyDate        |
#   |                     |           |                      |
#   +---------------------+           |     durationInHours  |  
#                                     +----------------------+                    
#                                               \|/
#                                                |
#                                                |
#                                                |
#                                               ---
#                                                |
#   +---------------------+           +----------------------+
#   |  waiters            |           |  parties_waiters     |
#   +---------------------+           +----------------------+
#   | PK   waiterId       |           | PK,FK1  partyId      |
#   |                     |           |                      |
#   |      firstName      |           | PK,FK2  waiterId     | 
#   |                     | |        /|                      |
#   |      lastName       +-+---------+         hourlyWage   |
#   |                     | |        \|                      |
#   |      gender         |           |                      |
#   |                     |           |                      |
#   +---------------------+           +----------------------+
#
#--------------------------------------------------------------------.

#----------------------------------------------------------------------------.
# DDL vs DML statements
#
# SQL statements that create or modify the structure of the database 
# tables are known collectively as Data Definition Language (DDL) SQL statements. 
# These include commands such as 
#
#     CREATE TABLE (that creates the table structures),
#     DROP TABLE (that destroys an entire table, including the structure), 
#     ALTER TABLE (that alters or changes the structure of tables, e.g. add columns)
#     other similar commands 
#
# SQL statements such as SELECT, INSERT, UPDATE and DELETE that create, modify
# retrieve and delte "data" in the tables are collectively known as 
# Data Manipulation Language (DML) SQL statements.
#
#
# NOTE: (not very important, but may clarify something ...)
#
# sqlfiddle.com instructs you to put DDL statements in the left hand side
# of the window and SELECT statements in the right hand side. The website
# (incorrectly, IMHO) refers to INSERT, UPDATE and DELETE statemens as DDL 
# statements. I believe most people in the industry refer to these as DML
# statements.
#----------------------------------------------------------------------------.




#-----------------------------------------------------------------------.
# More about SQLite databases.
#
# SQLite is designed to be used without the need for a server program.
# All the data in a SQLite database is packed into a single file.
# To connect to a SQLite database, you need to know the path to the 
# SQLite file for the database.
#
# The extension for a SQLite file is not standardized - sometimes
# you will see .db  sometimes .sqlite  sometimes other extensions
#-----------------------------------------------------------------------.


#########################################################################.
# Using DBI to connect to a database from R
#------------------------------------------------------------------------.
# To connect to a database from R, you can use functions from the 
# DBI package. You will also need to use an additional package that is
# specific for the type of database software you are going to connect to. 
#
# For example:
#   - to connect to a sqlite database you will need to use
#     functions from both the DBI package, as well as the RSQLite package. 
#
#   - to connect to a PostgreSQL database you will need to use
#     functions from both the DBI package, as well as the RPostgreSQL package. 
#
# Fortunately, the code to write for both types of database software products
# as well as many other database software products is VERY similar.
#
# Below, we will demonstrate how to connect to both a sqlite database and a
# PostgreSQL database using the DBI package. 
#
# NOTE: There is an alternative to the DBI approach described above.
#       Another popular alternative to connect to a database from R is to 
#       use the RODBC package. You can research that on your own if 
#       you like. The approach we take here with the DBI package
#       is just as powerful as ODBC - just an alternative. They are both
#       popular approaches. 
#########################################################################.


#------------------------------------------------------------------------.
# How to connect to a sqlite database using the DBI package.
#------------------------------------------------------------------------.
# Use R's DBI package to establish a "connection" with a database.
# You also need to use a package for the particular database software 
# you are going to be connecting with. For example, the RSQLite package
# is used for the sqlite database.
#
# The DBI package contains a function called dbConnect. 
# The DBMS specific packages, such as RSQLite also contain a dbConnect function.
# The DBMS specific version of the dbConnect function, calls the DBI version
# of the dbConnect function as part of its processing.
#
# The RSQLite package also provides the SQLite() function. This function
# returns a "driver" object that knows the specifics of how to work with
# sqlite databases. 
#
# The dbConnect function in the DBI package takes a "driver" as a first
# argument. The other arguments to dbConnect depend on the type of
# database software you are trying to connect to. 
#
# See the code below for more info.
#########################################################################.

#---------------------------------------------------------------------.
# Establish a connection to the SQLite database:
#---------------------------------------------------------------------.

# You will need both the DBI and RSQLite packages
if(!require(DBI)) {install.packages("DBI"); require(DBI)}
if(!require(RSQLite)) {install.packages("RSQLite"); require(RSQLite)}
help(package="DBI")
help(package="RSQLite")

# Create a connection to the Books database
sqliteBooksFile = "C:/Users/yrose/Dropbox (Personal)/website/yu/ids1020-MIS/67-spr19-ids1020-MIS/db/databaseFiles/booksDatabase/oldFiles/books.sqlite"
conBooks <- dbConnect(RSQLite::SQLite(), dbname = sqliteBooksFile)     # packages DBI, odbc

#---------------------------------------------------------------------.
# Show the tables in the database
#---------------------------------------------------------------------.

dbListTables(conBooks)

#---------------------------------------------------------------------.
# The following functions from the DBI package can be used to 
# run SQL statements in the database:
#
# FOR SELECT STATEMENTS USE
#      dbGetQuery() or     # use to get entire results all at once
#      dbSendQuery()       # use for retrieving large amounts of info a few rows at a time
# 
# FOR OTHER SQL STATEMENTS USE 
#      dbExecute() or dbSendStatement() 
#---------------------------------------------------------------------.

#......................................
# Get everything all at once
#......................................

dbGetQuery(conBooks, "select * from authors")

dbGetQuery(conBooks, "select * from titles 
                                  where type='biography'")

#.................................................
# To get large amounts of data a few rows at a time use the following functions:
# 
#  # Call dbSendQuery to get a "handle"
#
#  RESULT_HANDLE = dbSendQuery( conn = CONNECTION ,
#                               statement = SOME_SELECT_STATEMENT )
#
#  # Call dbFetch multiple times.
#  # Each time you get back a dataframe with a few rows.
#  # You could also call dbFetch in a loop
#
#  ROWS      = dbFetch( res = RESULT_HANDLE , n = NUMBER_OF_ROWS)
#  MORE_ROWS = dbFetch( res = RESULT_HANDLE , n = NUMBER_OF_ROWS)
#  MORE_ROWS = dbFetch( res = RESULT_HANDLE , n = NUMBER_OF_ROWS)
#  MORE_ROWS = dbFetch( res = RESULT_HANDLE , n = NUMBER_OF_ROWS)
#  etc. 
#
#  # It is a very good idea to call dbClearResult when you are done processing
#  # all the rows. That will free up any computer memory that was allocated
#  # to processing the results. Also most DBMS products have a limited number
#  # of queries that can be processed simultaneously. dbClearResult
#  # will free up the resources used by this query so that there are 
#  # more resources available in the database for others who might be trying
#  # to access the database simultaneously.
#
#  dbClearResult( RESULT_HANDLE )
#.................................................

# Get the rows from the titles table 5 at a time.
# You can see a summary of where you're up to in the entire result set 
# by displaying the results variable.

results <- dbSendQuery(conBooks, "select * from titles")

dbFetch(results, n=5)   # get first 5 rows
results                 # show a summary of where we are up to

dbFetch(results, n=5)   # get the next 5 rows
results                 # show a summary of where we are up to

dbFetch(results, n=5)   # get the next 5 rows
results                 # show a summary of where we are up to

dbClearResult(results)   # we're done so free up any "resources" (e.g. memory or connections to database)

# Let's do that again ...
# You can also use the following functions to return specific info about the 
# results, by passing the function the RESULTS_HANDLE that you got back from 
# the dbSendQuery function.
#
#   dbGetRowCount(RESULTS_HANDLE)  # return the # of rows returned so far
#   dbHasCompleted(RESULTS_HANDLE) # FALSE if more rows to be retrieved, TRUE otherwise
#
# There are other functions that could be used with the RESULTS_HANDLE too.
# See the documentation for more info.

results <- dbSendQuery(conBooks, "select * from titles")

dbFetch(results, n=5)   # get first 5 rows
dbGetRowCount(results)  # 5
dbHasCompleted(results) # FALSE

dbFetch(results, n=5)   # get the next 5 rows
dbGetRowCount(results)  # 10
dbHasCompleted(results) # FALSE

dbFetch(results, n=5)   # try to get the next 5 rows (but there are only 3 more)
dbGetRowCount(results)  # 13
dbHasCompleted(results) # TRUE

dbClearResult(results)   # we're done so free up any "resources" (e.g. memory or connections to database)


# You can do that in a loop to get back 5 rows at a time, 
# do some processing and then continue.

# Start the query and get the first few rows.
results <- dbSendQuery(conBooks, "select * from titles")
rows = dbFetch(results, n=5)   # get first 5 rows

# Keep looping until we get all of the rows.
while ( dbHasCompleted(results) == FALSE ){
  newRows = dbFetch(results, n=5)   # get first 5 rows
  rows = rbind(rows, newRows)
}

# We're done getting all the rows so clear the results handle.
# This releases any memory or other database "resources" that were being used
# to process the results.
dbClearResult(results)   

# These are all the rows
rows 



# The default for dbFetch is to retrieve ALL of the records.
# In the following examples all of the records are retrieved at once.

results <- dbSendQuery(conBooks, "select * from titles 
                                  where type='biography'")
results           # This is NOT the actual data - it is a "handle" that you need to use with other functions

dbFetch(results)  # get all of the data
dbFetch(results)  # can't get it again
dbClearResult(results)  # clear the computer memory/resources after you're finished

# You can also retrieve the rest of the rows that haven't been retrieved yet.
results <- dbSendQuery(conBooks, "select * from authors")
dbFetch(results, n=2)  # get the first 2 rows 
dbFetch(results, n=-1)  # get the rest of the rows 
dbClearResult(results)  # clear the computer memory/resources after you're finished




dbListTables(conBooks)    # packages DBI, odbc


# create a table
dbExecute(conBooks, 'CREATE TABLE test_table(id int, name text)') # packages DBI
dbListTables(conBooks)                                            # packages DBI, odbc

# insert a row
dbExecute(conBooks, "insert into test_table values (1, 'hello')")

# query the data in the table
dbGetQuery(conBooks, "select * from test_table")


# drop the table
dbExecute(conBooks, 'DROP TABLE IF EXISTS test_table') 

dbListTables(conBooks)      


#---------------------------------------------------------------------.
# Connecting to a PostgreSQL database
#
# See the info here:  https://hevodata.com/learn/rpostgresql/
#---------------------------------------------------------------------.
# Many RDBMS (Relational Database Management System) software products
# are designed for use with massive amounts of data. They are
# often more complicated software products that have many options for optimizing
# how they work. These types of RDBMS products are often run on a separate
# computer. PostgreSQL is such a product. Connecting to it requires
# knowledge of the following info:
#
#   - The name of the database. A database is a collection of tables
#     The same PostgreSQL software can manage several different databases.
#
#   - The "name" of the computer that is running the PostgreSQL software.
#     This could be in the form of
#
#         *  a "domain name", e.g. somedomain.com,
#         *  an IP address, e.g. 192.168.15.1
#         * "domain name", e.g. somedomain.com,
#     
#     Every website on the internet is running on a computer. The 
#     domain name 
#
#
dsn_database = "catering"   # Specify the name of your Database

# Specify host name e.g.:"aws-us-east-1-portal.4.dblayer.com"
# 127.0.0.1 is an IP address that refers to your computer
dsn_hostname = "127.0.0.1"  

# see: https://dba.stackexchange.com/questions/41458/changing-postgresql-port-using-command-line
#  or: https://stackoverflow.com/questions/15100368/postgresql-port-confusion-5433-or-5432
#
# find the file "postgresql.conf" 
# on my Windows computer it is in the following folder:
#   \Program Files\PostgreSQL\15\data
# There should be a line in that file that says: port = SOME_NUMBER
dsn_port = "5432"     # Specify your port number. e.g. 98939
#dsn_port = "5050"     # Specify your port number. e.g. 98939
#dsn_port = "65335"     # Specify your port number. e.g. 98939

# this is the default user id
dsn_uid = "postgres"         # Specify your username. e.g. "admin"
#dsn_uid = "pgadmin4"         # Specify your username. e.g. "admin"
#dsn_uid = "pgadmin4"         # Specify your username. e.g. "admin"

# this is whatever you set your password to
dsn_pwd = "password"        # Specify your password. e.g. "xxx"
#
# On March 30, 2023,
# I got the following error when trying to connect R 
# to postgres 15.2 on Windows 10 Home:
#
#      SCRAM authentication requires libpq version 10 or above
#
# This webpage:
#   https://stackoverflow.com/questions/62807717/how-can-i-solve-postgresql-scram-authentication-problem
# says the following:
#
#   > Your application uses an API that is linked with the PostgreSQL client C library libpq.
#   > The version of that library must be 9.6 or older, and SCRAM authentication was introduced in v10.
#   > Upgrade libpq on the application end and try again.
#   > 
#   > If you don't need scram-sha-256 authentication, you can revert to md5:
#   > 
#   > * set password_encryption = md5 in postgresql.conf
#   > * change the authentication method to md5 in pg_hba.conf
#   > * reload PostgreSQL
#   > * change the password of the user to get an MD5 encrypted password
#
# I followed the 2nd suggestion - i.e. 
#   > * set password_encryption = md5 in postgresql.conf
#   > * change the authentication method to md5 in pg_hba.conf
#   > * reload PostgreSQL
#   > * change the password of the user to get an MD5 encrypted password
#
# -YR 
#---------------------------------------------------------------------.

# You will need both the DBI and RPostgreSQL packages

if(!require(DBI)) {install.packages("DBI"); require(DBI)}
if(!require(RPostgreSQL)) {install.packages("RPostgreSQL"); require(RPostgreSQL)}
help(package="DBI")
help(package="RPostgreSQL")


dsn_database = "catering"   # Specify the name of your Database

# Specify host name e.g.:"aws-us-east-1-portal.4.dblayer.com"
# 127.0.0.1 is an IP address that refers to your computer
dsn_hostname = "127.0.0.1"  

# see: https://dba.stackexchange.com/questions/41458/changing-postgresql-port-using-command-line
#  or: https://stackoverflow.com/questions/15100368/postgresql-port-confusion-5433-or-5432
#
# find the file "postgresql.conf" 
# on my Windows computer it is in the following folder:
#   \Program Files\PostgreSQL\15\data
# There should be a line in that file that says: port = SOME_NUMBER
dsn_port = "5432"     # Specify your port number. e.g. 98939
#dsn_port = "5050"     # Specify your port number. e.g. 98939
#dsn_port = "65335"     # Specify your port number. e.g. 98939

# this is the default user id
dsn_uid = "postgres"         # Specify your username. e.g. "admin"
#dsn_uid = "pgadmin4"         # Specify your username. e.g. "admin"
#dsn_uid = "pgadmin4"         # Specify your username. e.g. "admin"

# this is whatever you set your password to
dsn_pwd = "password"        # Specify your password. e.g. "xxx"

# Call dbConnect to connect to the database
tryCatch({
  drv <- dbDriver("PostgreSQL")      
  print("Connecting to Database…")
  conCatering <- dbConnect(drv, 
                      dbname = dsn_database,
                      host = dsn_hostname, 
                      port = dsn_port,
                      user = dsn_uid, 
                      password = dsn_pwd)
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
  print(cond)
})

# You can now use any of the DBI functions by passing the connection
# object for the catering database.

# Use dbGetQuery to get instant results from select statements.
dbGetQuery(conCatering, "select * from waiters")

# Use dbSendQuery, dbFetch, dbClearResult to get only some rows at a time.
results <- dbSendQuery(conCatering, "select * from parties") 
dbFetch(results, n=2)  # get first two rows
dbFetch(results)       # get the rest of the rows
dbClearResult(results)  # clear the computer memory/resources after you're finished

# Use dbListTables to see the tables in the database
# Use dbExecute to run other SQL commands - eg. create or drop a table
dbListTables(conCatering)      
dbExecute(conCatering, 'CREATE TABLE test_table(id int, name text)') # packages DBI
dbListTables(conCatering)                                            # packages DBI, odbc

# insert a row, query the row, then drop the table
dbExecute (conCatering, "insert into test_table values (1, 'hello')")
dbGetQuery(conCatering, "select * from test_table")
dbExecute (conCatering, 'DROP TABLE IF EXISTS test_table') 
dbListTables(conCatering)      # the table is gone



# SQL WINDOW FUNCTIONS

# SQL COMMON TABLE EXPRESSIONS (CTE)  - very much related to subqueries
