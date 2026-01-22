setwd("/cloud/project/sql")

require(readr)
require(sqldf)
titles = read_csv("titles.csv", na="NULL")
publishers = read_csv("publishers.csv", na="NULL")
authors = read_csv("authors.csv", na="NULL")
title_authors = read_csv("title_authors.csv", na="NULL")
royalties = read_csv("royalties.csv", na="NULL")


sqldf("select * 
       from publishers left join titles on titles.pub_id = publishers.pub_id")

sqldf("select pub_name, title_name
       from publishers left join titles on titles.pub_id = publishers.pub_id")

sqldf("select pub_name, coalesce(title_name, '((no titles for this publisher))')
       from publishers left join titles on titles.pub_id = publishers.pub_id")


# Show the avg price of each type of book and how much that differs
# from the overall avg price of all books

# start with getting the avg price of each type of book
sqldf("select type, avg(price)
       from titles
       group by type
       order by type
       ")

# get overall avg price for all books
sqldf("select avg(price) from titles")



# Final answer

# start with getting the avg price of each type of book
sqldf("select type, avg(price), avg(price) - (select avg(price) from titles) as 'diff from overall avg'
       from titles
       group by type
       order by type
       ")


# Show authors who published more than 2 titles 
sqldf("select au_fname, au_lname
      from authors
      where 
         (select count(*)
          from title_authors
          where authors.au_id = title_authors.au_id) > 2
      order by au_lname, au_fname")


# same as outer query without the where clause (also added au_id)
sqldf("select au_fname, au_lname, au_id
      from authors
      order by au_lname, au_fname")


sqldf("select authors.au_fname, authors.au_lname, title_id
          from authors cross join title_authors
          where authors.au_id = title_authors.au_id")

sqldf("select * from title_authors order by au_id")