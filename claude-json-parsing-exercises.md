---
title: "JSON Parsing Practice in R"
format: html
---

## Exercise 1: Basic JSON Object Access

Consider the following JSON response from an API that has been parsed using `jsonlite::fromJSON()`:

```r
# API response stored in variable 'weather_data'
weather_data <- fromJSON('{
  "location": "Seattle",
  "current": {
    "temperature": 12.5,
    "conditions": "Cloudy",
    "wind": {
      "speed": 15.5,
      "direction": "NW"
    }
  },
  "forecast": [
    {"day": "Monday", "high": 14, "low": 8},
    {"day": "Tuesday", "high": 16, "low": 9},
    {"day": "Wednesday", "high": 15, "low": 7}
  ]
}')
```

**Question 1.1**: Write R code to extract the current temperature.

<details>
<summary>Click for answer</summary>
```r
weather_data$current$temperature
# or alternatively
weather_data[["current"]][["temperature"]]
```
</details>

**Question 1.2**: Write R code to create a vector of all forecasted high temperatures.

<details>
<summary>Click for answer</summary>
```r
weather_data$forecast$high
# or
sapply(weather_data$forecast, function(x) x$high)
```
</details>

## Exercise 2: Nested Arrays

Parse the following JSON response from a book API:

```r
# API response stored in variable 'library_data'
library_data <- fromJSON('{
  "library": {
    "name": "Central Library",
    "books": [
      {
        "title": "Data Science Basics",
        "authors": ["Smith, J.", "Jones, K."],
        "categories": ["programming", "statistics"],
        "ratings": [4.5, 4.8, 4.2]
      },
      {
        "title": "R Programming Guide",
        "authors": ["Wilson, M."],
        "categories": ["programming", "R"],
        "ratings": [4.7, 4.6, 4.9, 4.5]
      }
    ]
  }
}')
```

**Question 2.1**: Write code to create a vector of all unique book categories across all books.

<details>
<summary>Click for answer</summary>
```r
unique(unlist(library_data$library$books$categories))
```
</details>

**Question 2.2**: Calculate the average rating for each book and store it in a named vector where names are book titles.

<details>
<summary>Click for answer</summary>
```r
setNames(
  sapply(library_data$library$books$ratings, mean),
  library_data$library$books$title
)
```
</details>

## Exercise 3: Complex Nested Structures

Consider this JSON response from a social media API:

```r
# API response stored in variable 'social_data'
social_data <- fromJSON('{
  "user": {
    "id": "u123",
    "name": "Alex Chen",
    "posts": [
      {
        "id": "p1",
        "content": "Learning R!",
        "timestamp": "2024-02-15",
        "comments": [
          {
            "user": "Bob Smith",
            "text": "Great choice!",
            "likes": 3
          },
          {
            "user": "Carol Wu",
            "text": "Check out tidyverse",
            "likes": 5
          }
        ]
      },
      {
        "id": "p2",
        "content": "JSON parsing is fun",
        "timestamp": "2024-02-16",
        "comments": [
          {
            "user": "David Lee",
            "text": "Try jsonlite",
            "likes": 4
          }
        ]
      }
    ]
  }
}')
```

**Question 3.1**: Write code to create a data frame containing each comment's user and number of likes.

<details>
<summary>Click for answer</summary>
```r
# Method 1: Using do.call to combine list of data frames
do.call(rbind, lapply(social_data$user$posts$comments, function(comments) {
  data.frame(user = sapply(comments, `[[`, "user"),
             likes = sapply(comments, `[[`, "likes"))
}))

# Method 2: Using tidyverse if available
library(tidyverse)
bind_rows(social_data$user$posts$comments)
```
</details>

**Question 3.2**: Create a function that takes the social_data object and a username as parameters, then returns all comments made by that user.

<details>
<summary>Click for answer</summary>
```r
find_user_comments <- function(data, username) {
  # Flatten all comments
  all_comments <- unlist(data$user$posts$comments, recursive = FALSE)
  
  # Filter comments by username
  user_comments <- Filter(function(x) x$user == username, all_comments)
  
  # Extract comment text
  sapply(user_comments, `[[`, "text")
}

# Test the function
find_user_comments(social_data, "Carol Wu")
```
</details>

## Exercise 4: Working with Lists of Data Frames

Parse this JSON response from a fitness tracking API:

```r
# API response stored in variable 'fitness_data'
fitness_data <- fromJSON('{
  "user_id": "f789",
  "tracking_data": {
    "daily_steps": [
      {"date": "2024-02-14", "steps": 8432, "active_minutes": 45},
      {"date": "2024-02-15", "steps": 10234, "active_minutes": 62},
      {"date": "2024-02-16", "steps": 7321, "active_minutes": 38}
    ],
    "workouts": [
      {
        "type": "running",
        "sessions": [
          {"date": "2024-02-14", "duration": 30, "distance": 5.2},
          {"date": "2024-02-16", "duration": 25, "distance": 4.1}
        ]
      },
      {
        "type": "cycling",
        "sessions": [
          {"date": "2024-02-15", "duration": 45, "distance": 15.3}
        ]
      }
    ]
  }
}')
```

**Question 4.1**: Write code to create a data frame showing the total distance covered for each type of workout.

<details>
<summary>Click for answer</summary>
```r
workout_summary <- data.frame(
  type = fitness_data$tracking_data$workouts$type,
  total_distance = sapply(fitness_data$tracking_data$workouts$sessions, 
                         function(x) sum(x$distance))
)
```
</details>

**Question 4.2**: Create a function that takes the fitness_data object and a date as parameters, then returns a list containing all fitness activities (both steps and workouts) for that date.

<details>
<summary>Click for answer</summary>
```r
get_daily_activities <- function(data, target_date) {
  # Get steps for the date
  daily_steps <- subset(data$tracking_data$daily_steps,
                       date == target_date)
  
  # Get workouts for the date
  workouts <- lapply(data$tracking_data$workouts, function(workout) {
    sessions <- subset(workout$sessions, date == target_date)
    if (nrow(sessions) > 0) {
      cbind(type = workout$type, sessions)
    } else {
      NULL
    }
  })
  
  # Remove NULL entries from workouts
  workouts <- Filter(Negate(is.null), workouts)
  
  list(
    steps = daily_steps,
    workouts = workouts
  )
}

# Test the function
get_daily_activities(fitness_data, "2024-02-15")
```
</details>

## Bonus Challenge

Create a function that recursively traverses any JSON object and returns a character vector of all possible access paths to leaf nodes (scalar values). For example:

```r
# Example usage:
get_json_paths(weather_data)
# Should return something like:
# [1] "location"
# [2] "current$temperature"
# [3] "current$conditions"
# [4] "current$wind$speed"
# [5] "current$wind$direction"
# ...
```

<details>
<summary>Click for answer</summary>
```r
get_json_paths <- function(obj, prefix = "") {
  paths <- character()
  
  if (is.list(obj)) {
    for (name in names(obj)) {
      new_prefix <- if (prefix == "") name else paste0(prefix, "$", name)
      paths <- c(paths, get_json_paths(obj[[name]], new_prefix))
    }
  } else if (is.data.frame(obj)) {
    for (col in names(obj)) {
      new_prefix <- if (prefix == "") col else paste0(prefix, "$", col)
      paths <- c(paths, new_prefix)
    }
  } else {
    paths <- prefix
  }
  
  return(paths)
}
```
</details>

This challenge helps students understand the recursive nature of JSON structures and reinforces their understanding of how R represents these nested data structures internally.
