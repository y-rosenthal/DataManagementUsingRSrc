###############################################################
# This is the 2nd version of the file
# This version attempts to make the code easier to read by 
# breaking up the code into multiple functions.
###############################################################

# When developing code you should make sure that your entire
# file runs correctly from start to finish. 
# 
# Therefore, every time you test your code you should:
#   1. select the ENTIRE file ie. cmd-a (mac) or ctrl-a (win)
#   2. press ctrl-ENTER to run the entire code
#
# Also, to make sure that your code works it's a good idea to 
# remove all variables before running the code. 
# This guarantees that your variables are defined in your file 
# and that your code is not dependent on variables that you might have 
# created in the console but not included in the code in the file.

rm(list=ls())


# We will be using these packages. Make sure they are installed and loaded.
if(!require(tibble)){install.packages("tibble");require(tibble);}
if(!require(stringr)){install.packages("stringr");require(stringr);}

# This is the sample data that was shown in the assignment. 
# This data is just an example. 
# Your function must work for other data too, not just this exact data.

expenses = tribble(
  ~employee,           ~date,          ~amount,          ~category,         ~comments,
  "Sue Smith",         "1/19/2023",    "59.99",         "food",            "lunch with client",
  "Schwartz, Joe",     "01/19/2023",   "$27.00",        "office supplies", "paper for printer",
  "mike david harris", "2023-01-19",   "25",            "Office Stuff",    NA,
  "Dr. A. Davis",      "19/1/2023",    "five hundred",  "FOOD",            "NA",
  "Dr Jones",          "1/19/23",      "1,234.56",      "office suppl.",   "chairs",
  "S. Jones Jr",       "19/1/23",      "1000",          "Office supplies", "desk",
  "Conway, Ella Sr.",  "Jan 19, 2023", "$35.23",        "LUNCH",           "---",
)

# The command above creates a tibble, which is just a better version of a dataframe.
# If you're more familiar with dataframes than tibbles, you can convert 
# the data into a dataframe with the following line. 
#
# Note that tibbles are very compatible with dataframes so it shouldn't be 
# necessary to convert into a dataframe. However, if you're more comfortable
# with working with a dataframe, you can.

expenses = as.data.frame(expenses)

# Function to fix up a vector of employee names.
#
# Returns a dataframe that contains the columns : 
#       title, firstName, middleNames, lastName, suffix
fixEmployeeNames = function(
    expenses   # dataframe (or tibble) with all the data
    )
{
  # Create a vector with just the employee names column.
  employeeCol = expenses[ , "employee"]
  
  # Pull out the titles from the employeeCol into a separate vector
  # named employeeTitles that just contains the titles for the employees.
  # Then we will modify employeeCol to remove the titles.

  # We're going to create a pattern such as the following:
  #
  #      "^(Mr|Mrs|Dr)[\\s.].*"
  #
  # The actual pattern will include all of the titles shown below and not
  # just Mr,Mrs,Dr
  titles = c("Mr","Mrs","Miss","Ms","Dr","Admiral",
             "Ambassador",
             "Baron",
             "Baroness",
             "Brigadier",
             "Brother",
             "Canon",
             "Capt",
             "Chief",
             "Col")
  x = paste(titles, sep="", collapse="|")
  patternForTitles = paste0("^(" , x , ")[ .](.*)")
  
  rowsWithTitles = grep(pattern=patternForTitles, x=employeeCol)
  employeeTitles = character(length(employeeCol))
  employeeTitles[rowsWithTitles] = 
    gsub(pattern=patternForTitles, replacement="\\1", x=employeeCol)[rowsWithTitles]
  
  # Modify the employeeCol data to remove the titles
  employeeCol = gsub(pattern=patternForTitles, replacement="\\2", x=employeeCol)
  
  employeeFirstMidLastSuffix = character(length(employeeCol))
  
  
  
  
  #################################################
  
  # Pattern for "first last"
  pattern = "^\\s*([a-zA-Z]+)\\s+([a-zA-Z]+)\\s*$"
  
  employeesAfterSub = sub(pattern = pattern, 
                          replacement = "\\1,,\\2,", 
                          x = employeeCol)
  
  rowNumbers = grep(pattern = pattern, x = employeeCol)
  
  employeeFirstMidLastSuffix[rowNumbers] = employeesAfterSub[rowNumbers]
  
  ###################################################  

  # pattern for "last, first"
  
  pattern = "^\\s*([a-zA-Z]+)\\s*,\\s*([a-zA-Z]+)\\s*$"
  
  employeesAfterSub = sub(pattern = pattern, 
                          replacement = "\\2,,\\1,", 
                          x = employeeCol)
  
  rowNumbers = grep(pattern = pattern, x = employeeCol)
  
  employeeFirstMidLastSuffix[rowNumbers] = employeesAfterSub[rowNumbers]
  
  
  ############################################  
    
  listOfNames = str_split(employeeFirstMidLastSuffix, ",")
  
  mat = do.call(rbind, args = listOfNames)
  
  # We actually want a dataframe, not a matrix, so convert the result to a dataframe.
  df = as.data.frame(mat)
  
  # Add on the titles
  df = cbind(employeeTitles, df)
  
  # Modify the names of the columns in the dataframe.
  names(df) = c("title","first","middle","last","suffix")
  
  # Return the resulting dataframe
  df
}

# Create a "cleanup" function. 
cleanup = function(expenses){
  
  ################################
  # Fix up the employee column
  ################################

  employeeNamesDf = fixEmployeeNames(expenses)

  # combine the different dataframes 
  cbind(employeeNamesDf, expenses)
}

# call the function using the data
cleanup(expenses)

