# Regular Expression Practice with Data Cleaning

## Instructions

In this assignment, you'll practice using regular expressions to identify and clean messy data. The dataset below contains employee expense records with various inconsistencies in formatting. Your task is to write R code using regular expressions to identify different patterns in the data.

You should use the regex functions we covered in class:
- `grep()`: Find patterns and return matching indices or values
- `grepl()`: Find patterns and return TRUE/FALSE for each element
- `sub()`: Replace the first occurrence of a pattern
- `gsub()`: Replace all occurrences of a pattern
- `strsplit()`: Split strings based on a pattern

For each question:
1. First try to solve it yourself
2. If you get stuck, try to break down the pattern you're looking for into smaller pieces
3. Test your solution with the sample data to make sure it catches all cases
4. Click the answer dropdown to check your work or if you need a hint



::: {.cell}

```{.r .cell-code}
library(tibble)
expenses = tribble(
  ~employee,           ~date,          ~amount,          ~category,         ~comments,
  "Sue Smith",         "1/19/2023",    "59.99",         "food",            "lunch with client",
  "Schwartz, Joe",     "01/19/2023",   "$27.00",        "office supplies", "paper for printer",
  "mike david harris", "2023-01-19",   "25",            "Office Stuff",    NA,
  "Dr. A. Davis",      "19/1/2023",    "five hundred",  "FOOD",            "NA",
  "Dr Jones",          "1/19/23",      "1,234.56",      "office suppl.",   "chairs",
  "S. Jones Jr",       "19/1/23",      "1000",          "Office supplies", "desk",
  "Conway, Ella Sr.",  "Jan 19, 2023", "$35.23",        "LUNCH",           "---",
  "Tom Brown",         "2/15/2023",    "42.50",         "food",            "dinner meeting",
  "Williams, Kate",    "02/15/2023",   "$89.99",        "office supplies", "toner cartridge",
  "robert james lee",  "2023-02-15",   "75",            "Office Stuff",    NA,
  "Dr. B. Wilson",     "15/2/2023",    "two hundred",   "FOOD",            "NA",
  "Dr Smith",          "2/15/23",      "2,345.67",      "office suppl.",   "monitor",
  "R. Brown Jr",       "15/2/23",      "750",           "Office supplies", "filing cabinet",
  "Martinez, Ana Sr.", "Feb 15, 2023", "$48.75",        "LUNCH",           "---",
  "Mary Johnson",      "3/22/2023",    "63.45",         "food",            "team lunch",
  "Cooper, Sam",       "03/22/2023",   "$156.00",       "office supplies", "office decoration",
  "peter michael wu",  "2023-03-22",   "50",            "Office Stuff",    NA,
  "Dr. C. Taylor",     "22/3/2023",    "one thousand",  "FOOD",            "NA",
  "Dr Chen",           "3/22/23",      "3,456.78",      "office suppl.",   "laptop",
  "T. Wilson Jr",      "22/3/23",      "500",           "Office supplies", "printer",
  "Rodriguez, Eva Sr.","Mar 22, 2023", "$92.45",        "LUNCH",           "---"
)
```
:::



## Names Format Questions

### Question 1
Write R code using regex to identify all names that are in "last, first" format (e.g., "Schwartz, Joe").

::: {.callout-tip collapse="true"}
## Answer
Solution using backreferences:


::: {.cell}

```{.r .cell-code}
# Using backreferences
grep("^([A-Za-z]+), ([A-Za-z]+ ?([A-Za-z]+\\.?)?)$", expenses$employee, value=TRUE)
```

::: {.cell-output .cell-output-stdout}

```
[1] "Schwartz, Joe"      "Conway, Ella Sr."   "Williams, Kate"    
[4] "Martinez, Ana Sr."  "Cooper, Sam"        "Rodriguez, Eva Sr."
```


:::
:::



Solution without backreferences:


::: {.cell}

```{.r .cell-code}
# Without backreferences - just matching the pattern
grep("^[A-Za-z]+, [A-Za-z]+(( [A-Za-z]+)?\\.?)?$", expenses$employee, value=TRUE)
```

::: {.cell-output .cell-output-stdout}

```
[1] "Schwartz, Joe"      "Conway, Ella Sr."   "Williams, Kate"    
[4] "Martinez, Ana Sr."  "Cooper, Sam"        "Rodriguez, Eva Sr."
```


:::
:::


:::

### Question 2
Write R code using regex to identify all names that begin with "Dr" (with or without a period).

::: {.callout-tip collapse="true"}
## Answer


::: {.cell}

```{.r .cell-code}
grep("^Dr\\.? ", expenses$employee, value=TRUE)
```

::: {.cell-output .cell-output-stdout}

```
[1] "Dr. A. Davis"  "Dr Jones"      "Dr. B. Wilson" "Dr Smith"     
[5] "Dr. C. Taylor" "Dr Chen"      
```


:::
:::


:::

[... continuing with the rest of the questions, each with executable R code chunks and both backreference and non-backreference solutions where applicable ...]

### Question 13 (Challenge)
Write R code to extract just the last name from any name format in the employee column.

::: {.callout-tip collapse="true"}
## Answer
Solution using backreferences:


::: {.cell}

```{.r .cell-code}
# Handle both formats in one pattern
last_names <- gsub("^(([A-Za-z]+),|[A-Za-z]+ ).*$", "\\2\\1", expenses$employee)
# Clean up the trailing comma if it exists
last_names <- gsub(",", "", last_names)
last_names
```

::: {.cell-output .cell-output-stdout}

```
 [1] "Sue "               "SchwartzSchwartz"   "mike "             
 [4] "Dr. A. Davis"       "Dr "                "S. Jones Jr"       
 [7] "ConwayConway"       "Tom "               "WilliamsWilliams"  
[10] "robert "            "Dr. B. Wilson"      "Dr "               
[13] "R. Brown Jr"        "MartinezMartinez"   "Mary "             
[16] "CooperCooper"       "peter "             "Dr. C. Taylor"     
[19] "Dr "                "T. Wilson Jr"       "RodriguezRodriguez"
```


:::
:::



Solution without backreferences:


::: {.cell}

```{.r .cell-code}
# Step 1: Create logical vector for names in "Last, First" format
is_last_first <- grepl("^[A-Za-z]+,", expenses$employee)

# Step 2: Extract last names using different patterns based on format
last_names <- character(length(expenses$employee))

# Handle "Last, First" format
last_names[is_last_first] <- grep("^[A-Za-z]+", 
                                 expenses$employee[is_last_first], 
                                 value=TRUE)

# Handle "First Last" format
last_names[!is_last_first] <- grep(" [A-Za-z]+( Jr\\.?| Sr\\.?)?$",
                                  expenses$employee[!is_last_first],
                                  value=TRUE)
# Clean up by removing everything before the last space
last_names[!is_last_first] <- gsub("^.* ([A-Za-z]+)( Jr\\.?| Sr\\.?)?$", "\\1",
                                  last_names[!is_last_first])

last_names
```

::: {.cell-output .cell-output-stdout}

```
 [1] "Smith"              "Schwartz, Joe"      "harris"            
 [4] "Davis"              "Jones"              "Jr"                
 [7] "Conway, Ella Sr."   "Brown"              "Williams, Kate"    
[10] "lee"                "Wilson"             "Smith"             
[13] "Jr"                 "Martinez, Ana Sr."  "Johnson"           
[16] "Cooper, Sam"        "wu"                 "Taylor"            
[19] "Chen"               "Jr"                 "Rodriguez, Eva Sr."
```


:::
:::


:::

Would you like me to continue with the rest of the questions updated in this format? I can also:
1. Add more detailed explanations for each regex pattern
2. Include additional test cases
3. Add more complex challenge questions
4. Provide more examples of different approaches to solve each problem
