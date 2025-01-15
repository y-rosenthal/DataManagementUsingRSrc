##############################################################################.
##############################################################################.
# dplyr homework - SOLUTION
#
# There could be other valid solutions.
#
# The code below shows solutions to questions 1-14 in BOOKS DATABASE questions
# in both SQL and dplyr format.
##############################################################################.
##############################################################################.


require(tidyverse)
require(sqldf)

#############################################################################.
#############################################################################.
# Read in the data
#############################################################################.
#############################################################################.

titles = read_csv("titles.csv", na="NULL", show_col_types=FALSE)
authors = read_csv("authors.csv", na="NULL", show_col_types=FALSE)
publishers = read_csv("publishers.csv", na="NULL", show_col_types=FALSE)
title_authors = read_csv("title_authors.csv", na="NULL", show_col_types=FALSE)
royalties = read_csv("royalties.csv", na="NULL", show_col_types=FALSE)


#############################################################################.
#############################################################################.
# Answers to the questions
#############################################################################.
#############################################################################.

#---------------------------------------------------------------------------.
# Question 1
#
# List all books (title and number sold) that sold more than 1000 copies. List
# the books with the most sales at the top.
#---------------------------------------------------------------------------.

sqlAnswer = 
  sqldf("
  select title_name, sales
  from titles
  where sales > 1000
  order by sales desc
  ")

dplyrAnswer = 
titles %>%
  filter(sales > 1000) %>%
  select(title_name, sales) %>%
  arrange(desc(sales))

sqlAnswer
dplyrAnswer


#---------------------------------------------------------------------------.
# Question 2.
#
# List all authors who are live either in NY or CA and whose last name begins
# with a "K".
#---------------------------------------------------------------------------.

sqlAnswer = 
  sqldf("
  select au_fname, au_lname
  from authors
  where (state = 'NY' or state='CA')  and  substr(au_lname,1,1) = 'K';  
  ")

dplyrAnswer = 
  authors %>%
  filter((state == 'NY' | state == 'CA') & substr(au_lname, 1, 1) == 'K') %>%
  select(au_fname, au_lname)

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 3.	
#
# List the first and last names of all authors whose last name starts with a
# letter from A through J
#
# (HINT: In the where clause, make sure that the first
# letter of the last name is both  >="A" and also <"K") 
#
# (HINT: another possible solution is to use the LIKE several times - once
#  for A, once for B, once for C, etc up to J. Each LIKE should be separated 
#  from the others by OR's)
#---------------------------------------------------------------------------.

sqlAnswer = 
sqldf("
  select au_fname, au_lname
  from authors
  where substr(au_lname,1,1) >= 'A' and substr(au_lname,1,1) < 'K';
  ")

dplyrAnswer = 
  authors %>%
  filter(substr(au_lname, 1, 1) >= 'A' & substr(au_lname, 1, 1) < 'K') %>%
  select(au_fname, au_lname)

sqlAnswer
dplyrAnswer

#3 - another answer

sqlAnswer = 
  sqldf("
  select au_fname, au_lname
  from authors
  where 	au_lname like 'A%' or au_lname like 'B%' or au_lname like 'C%' or 
          au_lname like 'D%' or au_lname like 'E%' or au_lname like 'F%' or 
          au_lname like 'G%' or au_lname like 'H%' or au_lname like 'I%' or 
          au_lname like 'J%'
  ")

dplyrAnswer = 
  authors %>%
  filter(grepl("^[A-J]", au_lname)) %>%
  select(au_fname, au_lname)

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 4.	
#
# For each author, show their first initial, followed by a period and a space,
# followed by their last name. In the 2nd column show the author's state. Show
# the column heading for the first column as 'AuthorName'.  Order the results in
# alphabetical order based on the full name of the person.
#---------------------------------------------------------------------------.

sqlAnswer = 
sqldf("
  select substr(au_fname,1,1) || '. ' || au_lname  as   'AuthorName',  state
  from authors
  order by au_lname, au_fname;
  ")

dplyrAnswer = 
  authors %>%
  arrange(au_lname, au_fname) %>%
  mutate(AuthorName = paste0(substr(au_fname, 1, 1), ". ", au_lname)) %>%
  select(AuthorName, state)

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 5.	
#
# Show the titles of all books. Also show the length of the title, i.e. how many
# characters, including spaces and punctuation. Display the 2nd column with the
# name 'TitleLength'.  Sort the output so that the shortest titles are listed
# first. If two titles are the same length then sort those titles
# alphabetically.
#---------------------------------------------------------------------------.

sqlAnswer = 
  sqldf("
  select title_name, length(title_name) as 'TitleLength'
  from titles
  order by length(title_name), title_name;
  ")

dplyrAnswer = 
  titles %>%
  mutate(TitleLength = nchar(title_name)) %>%
  select(title_name, TitleLength) %>%
  arrange(TitleLength, title_name)

#############################################################################.
# Single table queries with aggregate functions but no “group by”
# (i.e. these will return EXACTLY one row for each query). 
#############################################################################.

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 6.	
#
# List the average price of all books.
#---------------------------------------------------------------------------.

sqlAnswer = 
sqldf("
  select avg(price) 
  from titles;
  ")

dplyrAnswer = 
  titles %>%
  summarize(AveragePrice = mean(price, na.rm = TRUE))

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 7.	
#
# List the average price of history books.
#---------------------------------------------------------------------------.

sqlAnswer = 
  sqldf("
  select avg(price) 
  from titles
  where type = 'history';
  ")

dplyrAnswer = 
  titles %>%
  filter(type == 'history') %>%
  summarize(AveragePrice = mean(price, na.rm = TRUE))

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 8.	
#
# List the number of pages in the longest and shortest books (don't list the
# actual title of the book).
#---------------------------------------------------------------------------.

sqlAnswer = 
sqldf("
  select min(pages) , max(pages) from titles;
  ")

dplyrAnswer = 
  titles %>%
  summarize(MinPages = min(pages, na.rm = TRUE),
            MaxPages = max(pages, na.rm = TRUE))

sqlAnswer
dplyrAnswer

#############################################################################.
# Single table queries with calculated values
#############################################################################.

#---------------------------------------------------------------------------.
# Question 9.
#
# List the title_name and total revenue for each book. (Revenue for a book is
# the number sold times the price of the book.)
#---------------------------------------------------------------------------.

sqlAnswer = 
  sqldf("
  select title_name,   sales * price   as   'Total  Revenue'
  from titles;
")

dplyrAnswer = 
  titles %>%
  mutate(TotalRevenue = sales * price) %>%
  select(title_name, TotalRevenue)

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 10.
#
# List title of each book and the sale price for the book where the sale price
# is 10% off of the original price.
#---------------------------------------------------------------------------.

sqlAnswer = 
sqldf("
  select title_name, price * 0.90 as 'Sale Price'
  from titles;
")

dplyrAnswer = 
  result <- titles %>%
  mutate(SalePrice = price * 0.90) %>%
  select(title_name, SalePrice)

sqlAnswer
dplyrAnswer

#############################################################################.
# Single table queries with “group by”.
# These can use aggregate functions but will return at most one 
# row in the output for each “group” of rows as defined in the “group by”
#############################################################################.

#---------------------------------------------------------------------------.
# Question 11.
#
# For each "type" of book (e.g. biography, children, etc) list the number of
# pages in the shortest book of that type and the number of pages in the longest
# book of that type. Sort the results alphabetically by the type of book.
#---------------------------------------------------------------------------.

sqlAnswer = 
  sqldf("
  select type, min(pages) AS 'Length of Shortest' ,  max(pages)  as 'Length of Longest'
  from titles
  group by type
  order by type;
  ")

dplyrAnswer = 
  titles %>%
  group_by(type) %>%
  summarize(LengthOfShortest = min(pages, na.rm = TRUE),
            LengthOfLongest = max(pages, na.rm = TRUE)) %>%
  arrange(type)

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 12.	
#
# List the types of books (e.g. history, biography, etc) and the average price
# of those books for which the average price of books in that category is at
# least $12.00.
#---------------------------------------------------------------------------.

sqlAnswer = 
sqldf("
  select type, avg(price)
  from titles
  group by type
  having avg(price) >= 12;
  ")

dplyrAnswer = 
  titles %>%
  group_by(type) %>%
  summarize(AveragePrice = mean(price, na.rm = TRUE)) %>%
  filter(AveragePrice >= 12)

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 13.	
#
# For each type of book (e.g. biography, children, etc), show the number of
# those books that are 450 pages or longer. The column heading should be '# of
# long books'. If there are no titles of a particular type that are so long,
# then don't show that type at all.
#---------------------------------------------------------------------------.

sqlAnswer = 
  sqldf("
  select type, count(*) as '# of long books'
  from titles
  where pages >= 450
  group by type;
  ")

dplyrAnswer = 
  titles %>%
  filter(pages >= 450) %>%
  group_by(type) %>%
  summarize(NumOfLongBooks = n())

sqlAnswer
dplyrAnswer

#---------------------------------------------------------------------------.
# Question 14.
#
# Modify the answer to the previous question so that only those types for which
# there are at least 2 long books are displayed.
#---------------------------------------------------------------------------.

sqlAnswer = 
sqldf("
  select type, count(*) as '# of long books'
  from titles
  where pages >= 450
  group by type
  having count(*) >= 2;  
  ")

dplyrAnswer = 
  titles %>%
  filter(pages >= 450) %>%
  group_by(type) %>%
  summarize(NumOfLongBooks = n()) %>%
  filter(NumOfLongBooks >= 2)

sqlAnswer
dplyrAnswer
