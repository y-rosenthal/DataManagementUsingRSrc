install.packages("jsonlite")
library(jsonlite)
res <- fromJSON('http://ergast.com/api/f1/2004/1/results.json')
drivers <- res$MRData$RaceTable$Races$Results[[1]]$Driver
colnames(drivers)




#store all pages in a list first
baseurl <- "https://projects.propublica.org/nonprofits/api/v2/search.json?order=revenue&sort_order=desc"
pages <- list()
for(i in 0:10){
  mydata <- fromJSON(paste0(baseurl, "&page=", i), flatten=TRUE)
  message("Retrieving page ", i)
  pages[[i+1]] <- mydata$organizations
}

#combine all into one
organizations <- rbind_pages(pages)

#check output
nrow(organizations)

organizations[1:10, c("name", "city", "strein")]


fromJSON("https://projects.propublica.org/nonprofits/api/v2/search.json?q=propublica")



x=readLines("https://projects.propublica.org/nonprofits/api/v2/search.json?q=propublica")
cat(x)
help(package="jsonlite")
prettify (x)





#search for articles
article_key <- "&api-key=b75da00e12d54774a2d362adddcc9bef"
url <- "http://api.nytimes.com/svc/search/v2/articlesearch.json?q=obamacare+socialism"
req <- fromJSON(paste0(url, article_key))
articles <- req$response$docs
colnames(articles)


# NYT 
# app name: testing1
#
# description
# testing how to use the nyt apis
#
# app id: 4f773522-793d-491f-bbdf-9cd694d4c60a
#
#
# API Keys
#
# key
# 7ybq1aABOSUyKb0wDYTUUAbEKFqGpfhs
#
# secret
# eKGSmmNWLklJXKe9




# Load necessary libraries
library(httr)
library(jsonlite)
library(magrittr)
# Set your API key
api_key <- "7ybq1aABOSUyKb0wDYTUUAbEKFqGpfhs"

# Define the API endpoint and parameters
endpoint <- "https://api.nytimes.com/svc/search/v2/articlesearch.json"
query <- "technology" # Replace with your desired search term
url <- paste0(endpoint, "?q=", query, "&api-key=", api_key)

# Make the API request
response <- GET(url)

# Check if the request was successful
if (status_code(response) == 200) {
  # Parse the JSON response
  articles <- content(response, "text") %>%
    fromJSON(flatten = TRUE)
  
  # Extract relevant information from the articles
  results <- articles$response$docs
  data <- data.frame(
    headline = sapply(results, function(x) x$headline$main),
    abstract = sapply(results, function(x) x$abstract),
    web_url = sapply(results, function(x) x$web_url)
  )
  
  # Display the first few articles
  print(data)
} else {
  cat("Failed to retrieve articles. Status code:", status_code(response), "\n")
}
