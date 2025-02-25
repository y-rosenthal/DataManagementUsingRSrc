# Resources for this semester - see the file "referenceMaterial.md"

##############################################################################
# Creating a CSV file in Excel
##############################################################################

# To create a CSV file in Excel do the following steps:
# IMPORTANT: If you save an Excel file as a CSV file ...
#    (a) ... you will only retain ONE tab of information in the .CSV file.
#    (b) ... the .csv file will not contain the Excel formulas - just the 
#            results (i.e. the values).
# Therefore, if you don't want to lose the different tabs or the formulas
# MAKE SURE that you've saved the file as a regular Excel (.xlsx) file
# BEFORE you save the file as a .csv file.
#
# 1. Use Excel to create or open a standard Excel file and enter some data.
#
# 2. Choose "save as" from the "File" menu. 
#
# 3. Under the "File name:" there is a drop down menu labeled "Save as type:"
#    Choose one of the CSV options. Depending on your version of Excel you 
#    may see different CSV choices. They are all very similar. The differences
#    are beyond the scope of 
#
#    My version of Excel shows the following 4 different CSV options:
#    (I am using "Excel 2019" on Windows 10)

#       "CSV UTF-8 (Comma delimited) (*.csv)"
#       "CSV (Comma delimited) (*.csv)"
#       "CSV (Macintosh) (*.csv)"
#       "CSV (MS-DOS) (*.csv)"
#
#    For best results I chose the 2nd option, "CSV (Comma delimited) (*.csv)"
#    If you're running Windows, I recommend you use this option.
#
#    NOTE: The first option, "CSV UTF-8 (Comma delimited) (*.csv)" caused some slight
#    issues when I tried to read in this CSV file with R. If you're curious
#    the reason for the problem was that on Windows, this option adds a 
#    "byte order mark (BOM)" to the beginning of the file. The BOM caused
#    a slight issue when trying to read this file into R.
#
#    Students who had MACs told me that they only saw the UTF-8 option and
#    that it worked fine for them in R. 
#
#    In any case, the differences between the options are not that critical 
#    for right now. Later in the course, when we get more into details of 
#    "encodings" we will readdress this issue.
#
# 4. If you try to save the file as a CSV you will be warned that you will
#    lose the data on the other sheets. That is as expected as I described
#    above.
##############################################################################

##############################################################################
# Reading and Writing files
#
# This is a useful tutorial:
#    https://www.datacamp.com/community/tutorials/r-tutorial-read-excel-into-r
#
# It doesn't cover everything though. The full datacamp course covers a lot
# more.
#
##############################################################################


##############################################################################
# Some definitions: TEXT FILES, TEXT EDITORS, BINARY FILES, CSV FILES
##############################################################################
# Files on a computer can be roughly divided into
# - text files  (also known as "flat files")
# - binary files
#
# For most of the course (and especially this lesson) we will focus mainly
# on text files.
#
#
# TEXT FILES
#
# Note - The following definition of a "text file" does not go into much detail.
#        It simply explains what CANNOT be in a text file. However, this is not
#        enough for a full definition - the full definition and a better
#        understanding will have to wait until later in the course.
#
# The only info that may ever appear in a "text file" is plain letters, numbers
# and other textual symbols (e.g. !@#$% etc). A text file CANNOT contain
# pictures, multiple fonts, tables of information, multiple "tabs" (e.g.
# as in Excel files), etc. Microsoft Word files (and files from 
# similar "Word processor" programs such as the Pages program on Mac) are NOT
# text files, even if they only contain plain text. The very fact that these
# programs CAN store pictures, etc in their files is enough to say that 
# the files from these program are NOT text files.
#
# A "text editor" is a program that is used to create and modify text files.
# Note that Microsoft Word is NOT a "text editor". MS Word is instead
# known as a "word processor".
#
# Computer programming code, regardless of the programming language,
# should be typed into text files using a "text editor" program. 
# That means that you should NOT use Microsoft
# Word or a similar "Word Processor" programs to type computer code.
# For example, the "script editor" window in RStudio is an example of
# a "text editor".
#
#
# BINARY FILES
#
# It is a little premature to define exactly what a "binary file" is. However,
# for now, we can say that files which contain data other than pure
# unadulterated text are gererally "binary files". For example,
# Excel files, Microsoft Word files, files that contain pictures, PDF files, etc
# all examples of binary files. 
##############################################################################



##############################################################################
# Different types of text files
##############################################################################
# You can import data from text files into R using several different functions.
# The exact function to use depends on how the information in arranged in 
# the text file. The exact ways to use these different functions will be
# explained in more detail below. 
#
#
# Reading text files with "delimiters" into a dataframe can be done with 
# the following functions. The first four functions below are actually
# special purpose versions of the one function read.table.
# - read.csv
# - read.csv2 
# - read.delim
# - read.delim2
# - read.table
#
#
#
# Reading text files with fixed width fields into a dataframe:
# - read.fwf    (i.e. read a file with "fixed width fields")
# - etc.
#
#
# Reading lines of text files into a character vector:
# - readLines 
#     NOTE: the "L" in "readLines" is a CAPTIAL "L").
#           By contrast, the readline function is a very different function.
#           readline (with a lowercase "l" and no final "s") is used to prompt
#           the user to type some information and return what the user typed, e.g.
#           > food = readline("What is your favorite food? ")
#  
##############################################################################


##############################################################################
# NOTE: The following info was current as of 
#       RStudio version 2021.09.2 Build 382  (January 2022)
##############################################################################
# The "Import Dataset" button on Environment tab in RStudio.
##############################################################################
# Clicking this button allows you to choose a file to import.
# You will also be asked to fill in several different options related to
# how the file is formatted and how the data will be converted into an 
# R dataframe.
# 
# The "Import Dataset" button takes the information that you enter and 
# forms an appropriate R command that can be used to import the data.
# Once you have an R command to import the data (whether you wrote the command 
# yourself or got it from the "Import Dataset" button) you can put that
# R command into an R script file so that in the future you do not need to
# use the Import Dataset button again if you need to re-import the file. 
#
# The current version of the "Import Dataset" button presents the 
# following menu choices. These are explained below.
#
#    From Text (base)     
#    From Text (readr)
#    From Excel
#    From SPSS
#    From SAS
#    From Stata
#
#
# From Text (base)
#     Use this to create an R command to import data from a text file in
#     which the values are separated from each other with "delimeter" symbols.
#     The delimiters may be commas, tabs, semicolons, or any other character
#     that is used to separated data values from each other.
#
#     The R code that is generated to do the import does not depend on any 
#     additional "packages" to be added into R. The code is usable with just
#     the "base" (ie. standard) version of R. 
#
#     (we will explore this in more detail below)
#
# From Text (readr)
#     This is similar to the previous choice, except that the code generated 
#     depends on the "readr" package being added into R. We'll discuss this more
#     later.
#
# The other menu choices shown above ("From Excel", "From SPSS", etc) each
# are used to generate R code to import data from the specified type of file.
# Each of these choices generates R code that relies on different R packages
# to import the specified type of file.
##############################################################################

##############################################################################
#
# file.choose()
#
##############################################################################

#-----------------------------------------------------------------------------
# The location of a file on your hard drive can be written using a "full path".
# This consists of all of the names of all the folders from the top of your
# hard drive down to where the file is. The folder names are separated
# with slashes. R will recognize forward slashes on both Mac and Windows.
# However, Windows normally uses backslashes for this. Therefore if you 
# are on windows, file.choose() will use backslashes (doubled, i.e. \\)
#
#-----------------------------------------------------------------------------

# The following will display a window that lets you choose a file. Once 
# you have chosen the file and pressed "Open" the full path to the file
# will be displayed. Note that the "Open" button doesn't actually "open"
# the file, it just returns the full path to the file (another example
# of R being somewhat "quirky")
#
# WARNING: sometimes the window, is not visible at first since it comes up
# behind other windows. If that happens you can minimize all your other 
# windows to see the file chooser window. (This seems to be a bug in 
# RStudio).
#
# Try running this a few times with different files in different folders
# to see what a full path looks like on your computer. 

file.choose()

#-----------------------------------------------------------------------------
# read.csv()
#-----------------------------------------------------------------------------


# Replace the "full path" to the file shown below with the location on 
# your computer. (you can use file.choose() to do this ... see above)

stocks.v001 <- read.csv("C:/Users/yrose/Dropbox (Personal)/website/yu/ids2460-dataMgmtForAnal/79spr22-ids2460-dataManagement/stocks-v001.csv", encoding="UTF-8")

# Show the data
stocks.v001

# Alternatively, you can store the full path in a variable ...

fullPathToFile = file.choose()

# If you're curious ... here is the full path 
fullPathToFile

# Now we can read it in ...
stocks.v002 <-  read.csv(fullPathToFile, encoding="UTF-8")
stocks.v002


#############################################################################
# See the documentation page for the exact arguments to the
# read.table, read.csv, read.csv2, read.delim and read.delim2 
# functions
#
# ?read.csv   # this is the same page as ?read.table , ?read.csv2 , etc.
#############################################################################

?read.csv

#############################################################################
# For short examples, you can use the text argument to specify the data 
# instead of creating an actual file.
#############################################################################

# The text argument allows you to specify explicit text instead of creating
# a file.

df = read.csv(header=TRUE,text=
"fruit, calories, color
apple,30,red
pineapple,90,brown and green
plum,45,purple"
)

df

# Be careful when using the text argument as spaces in the beginning of a 
# line will be interpreted as being part of the actual data.
# 
# Notice the difference between this previous example and the following 
# example.

df = read.csv(header=TRUE,text=
           "fruit, calories, color
            apple,30,red
            pineapple,90,brown and green
            plum,45,purple"
           )
df

df$fruit       # notice the spaces before each fruit name
df$color       # the spaces were only added for the first column
colnames(df)

##############################################################################
# example( SOME_R_FUNCTION )
##############################################################################
# Use the example function to execute the examples that appear at the 
# bottom of the R documentation files. 
##############################################################################

?seq   # show the documentation for the seq function

# The following runs the examples that appear at the end of the help page.
# Note that the ">" prompt is displayed as "seq>" in the output.
example("seq")  # Run the examples that appear at the end of the documentation

# We can now see the examples for the read.csv function.

?read.csv     # show the documentation for the read.csv function

# Run the examples from the read.csv documentaiton page.
#
# Notice the use of the tempfile() function. This is explained a little more
# in the very next section below ...

example("read.csv")   


##############################################################################
# tempfile()
##############################################################################
# tempfile()  returns the full path to the name of a file that doesn't 
# currently exist. You can use this as a filename for information that you
# need to temporarily store in a file. 
#
# Sometimes, you need to create a file "temporarily". In other words, you 
# may need to create a file to store some information but then will remove
# the file or rename the file when you get more information. It is sometimes
# inconvenient to find a good folder to place such a file. 
#
# The tempfile function simply returns the full path for a filename that
# doesn't currently exist. You can use this filename to create a file
# and them remove the file when you no longer have any need for it.
#
# The tempfile() function will generate a new name every time it is called.
##############################################################################

tempfile()   # you can use this name for a temporary file

tempfile()    # another name

##############################################################################
# unlink( SOME_FILE_NAME )
#
# This function removes the specified file. The name "unlink" derives from a
# similar command that originated in the 1970s with the Unix operating system.
# The reason the command is called unlink is not very important and is not
# very applicable to R. If you're curious, you can search online for the reason
# it's called unlink - or ask me after class.
##############################################################################

tf = tempfile()
tf

fruit = c("apple", "orange", "pear", "banana")
writeLines(fruit, tf)
?writeLines

# Get the contents of the file
readLines(tf)

# Remove the file
unlink(tf)

# The file is no longer there. This will generate an error.
readLines(tf)  # ERROR

#####################################################################
# To see the contents of a particular folder from your computer's 
# filesystem viewer:
#
# MAC
# 
# 1. open finder
#
# 2. press cmd-shift-g
#
# 3. type or paste the full path to the FOLDER you want to see into the textbox
#    that asks you which folder you want and press GO.
#
# 4. make sure that your full path is the full path to a FOLDER and not to 
#    a FILE. If the last name in the full path is a filename then delete 
#    that last name.
#    NOTE:  Make sure that the path does not include "//". All separators 
#    should be just a "/" (file.choose seems to sometimes include "//" )
#
# WINDOWS
#
# 1. Open the "File Explorer" program 
#    (start menu, type "File Explorer", press Enter)
#
# 2. Paste in the full path to the folder as described for Mac above. 
#    Then press enter.
#
# 3. Make sure that the separators in the path are each a single
#    backslash, i.e. "\"
#####################################################################




##############################################################################
# SOME_CHARCTER_VECTOR = readLines( SOME_FILE )
# 
# Reads in the lines of a text file and returns a vector that contains
# one entry per line.
##############################################################################

# readLines has a CAPITAL "L"
lines = readLines("C:/Users/yrose/Dropbox (Personal)/website/yu/ids2460-dataMgmtForAnal/79spr22-ids2460-dataManagement/stocks-v003.csv")

lines

# You can use cat with sep="\n" to see how the file actually looks in the file.
cat(lines, sep="\n")

#-----------------------------------------------------------------------------
# readLines (capital "L", final "s")    and 
# readline (lowercase "l", no "s")
#-----------------------------------------------------------------------------

# Don't confuse readLines with readline (lowercase "l")
# Remember - readline is used to ask the user to enter some information
#
# Example with readline (VERY different from readLines)

food = readline("What is your favorite food? ")

food





##############################################################################
# "Fixed Width Field" text files.
# 
# Use the read.fwf function to read in data from a fixed width field
# text file.
##############################################################################

lines = c(
  "name            test1  test2  year     ",
  "Joe Smith       71     80     Sophomore",
  "Anne P. Jones   90     95     Senior   ",
  "M. Cohen        85     83     Sophomore",
  "J. Fox          99     98     Freshman ")

tf = tempfile()

writeLines(lines, tf) 

linesInTheFile = readLines(tf)
linesInTheFile
cat(linesInTheFile, sep="\n")

# The following works, but notice that the headers are just part of the data
# in the dataframe. The read.fwf function automatically created new 
# column names (V1, V2, V3, etc).
read.fwf(file=tf, widths = c(16,7,7,9))

# We might think that specifying header=TRUE (similar to what we did for the 
# read.csv function)  would fix the problem. Unfortunately, it doesn't - we 
# just get the error "more columns than column names" (which doesn't
# immediately seem be make sense)

read.fwf(file=tf, widths = c(16,7,7,9), header=TRUE)  # ERROR

# upon closer examination of the documentation we can see the reason for our
# error.

?read.fwf

# The documentation includes the following for the header and sep arguments:
#
#    header	    a logical value indicating whether the file contains the names
#               of the variables as its first line. If present, the names must
#               be delimited by sep.
#
#    sep	      a character. the separator used internally. should be a character
#               that does not occur in the file (except in the header).
#
# The read.fwf function expects the headers to be separated by commas (or
# whatever is specified in sep). This usually isn't what you get when
# someone sends you a fixed width file. This is another example of the
# functions in R not being very consistent and being rather "quirky". 
#
# To solve the problem, we will leave header=FALSE and then fix the dataframe
# once it has been read in.

# First specify header=FALSE to read the file.
# This works but the actual headers actually appear as the first line of data
# and the column names for the dataframe are generated automatically
# as V1,V2, etc

df = read.fwf(file=tf, widths = c(16,7,7,9), header=FALSE)
df

# We can fix this ourselves

colnames(df) = df[1,]    # copy the first row of data into the column names
df
df = df[-1,]             # remove the first row of data
df                       # final result






##############################################################################
# Another Example:
#   using read.fwf to read fixed width field data from a file or URL
#
# The following is data about the Sea Surface Temperature.
# The first couple of lines of file looks like this:
##############################################################################
#     Weekly SST data starts week centered on 3Jan1990
# 
#                    Nino1+2      Nino3        Nino34        Nino4
#     Week          SST SSTA     SST SSTA     SST SSTA     SST SSTA
#     03JAN1990     23.4-0.4     25.1-0.3     26.6-0.0     28.6 0.3
#     10JAN1990     23.4-0.8     25.2-0.3     26.6 0.1     28.6 0.3
#     17JAN1990     24.2-0.3     25.3-0.3     26.5-0.1     28.6 0.3
#     24JAN1990     24.4-0.5     25.5-0.4     26.5-0.1     28.4 0.2
#     31JAN1990     25.1-0.2     25.8-0.2     26.7 0.1     28.4 0.2
#     07FEB1990     25.8 0.2     26.1-0.1     26.8 0.1     28.4 0.3
#     14FEB1990     25.9-0.1     26.4 0.0     26.9 0.2     28.5 0.4
#     ... etc
##############################################################################

data <- read.fwf(
  file = "http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for",
  skip = 4,
  widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4))

str(data)   # We got back a data.frame

# Show the dataframe -
#
# Note that when you run a command that generate a lot of data, 
# RStudio will only display up to a maximum number of lines in the
# console. 
# Note that if you try to display a dataframe with many rows, 
# R will 
# many rows are displayed.
data         

# To solve this you can use the View function (that's View with a CAPITAL "V")
# to see the entire dataframe in a separate tab.
View(data)   


##############################################################################
# See the examples, i.e. :  example("read.fwf")
#
# Get used to using the example function to learn more about functions.
# You will learn a lot by doing so.
##############################################################################

# See the examples in the documentation of read.fwf for more info.

example("read.fwf")




####################
lines = readLines(url("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"))

lines = readLines("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for")

str(lines)  # character vector

lines   # character vector with one entry per line



book = readLines( url("https://www.gutenberg.org/files/1661/1661-0.txt") )



##############################################################################
# Writing data to files.
##############################################################################
?write.csv

##############################################################################
# Using write.csv to write out the data from a dataframe to a CSV file
#
# Read the documentation ?write.csv and 
# pay careful attention to various arguments described there.
# 
##############################################################################

df = data.frame ( student = c("joe", "sue", "sam"),
                  test1 = c(70,80,90),
                  test2 = c(75,85,95),
                  honors = c(FALSE, FALSE, TRUE))
df

?write.csv
write.csv(df, "grades.csv")

# You usually do not want the row.names to be in a csv file
write.csv(df, "grades2.csv", row.names = FALSE)

##############################################################################
# Working with files on your computer
# 
##############################################################################

#-----------------------------------------------------------------------------
# R has a concept of a "working directory", i.e. the "directory" (AKA folder)
# that R will read/write files from/to when you do not specify a full path.
#-----------------------------------------------------------------------------


getwd()  # displays the folder (i.e. "direcotry") that R is currently using


#-----------------------------------------------------------------------------
# if you want to save the file in another location, you need to tell
# R the path to the location.
#-----------------------------------------------------------------------------

filename = 
  "C:/Users/yrose/Dropbox (Personal)/gradesFilesForYU/grades2.csv"

write.csv(df, filename)

# Note that the folders in the path must already exist or else this will 
# not work.

filename = 
  "C:/Users/yrose/thisFolderDoesntExist/grades2.csv"

write.csv(df, filename)   # ERROR - folder doesn't exist



#-----------------------------------------------------------------------------
# You can also use the setwd(SOME_FOLDER) function to change the working
# directory. 
#-----------------------------------------------------------------------------

getwd()

folder = "C:/Users/yrose/Dropbox (Personal)/anotherFolder"
setwd(folder)
write.csv(df, "grades3.csv")

grades3 = read.csv("grades3.csv")
grades3

#-----------------------------------------------------------------------------
# dir()
# dir ( SOME_DIRECTORY )
#-----------------------------------------------------------------------------



dir()

dir("c:/Users/yrose")

myDesktop = "C:/Users/yrose/OneDrive/Desktop/"

dir(myDesktop)

# Filename extensions

# Zip files

# Reading files

# get the "working directory" (i.e. folder)
getwd()

# set (i.e. changer) the "working directory" (i.e. folder)
#    setwd(SOME_FOLDER_NAME)

# Show files in the "working directory" (aka working folder)
dir()



# Mac vs Windows - 
#
# a. /mac/uses/forward/slashes
#
#    \windows\uses\backslashes
#
#    R code allows for both styles - however, if you use \backslashes\ in R
#    then you must use TWO \\backslashes\\ since a \backslash is interpreted
#    in R code in other ways, e.g. \n is a new line and \t is a tab character.
#    Therefore, the best advice is in R to always use /forward/slashes/ for 
#    file paths.
#
# b. Windows has an optional "drive letter" (e.g. c: or d: etc.)
#
#    Mac doesn't use drive letters at all.
#
#
# c. Filename extensions are more significant on Windows
#
# 

###############################################################################
# Folders and directories
# File names
# 
#   full path vs relative path
###############################################################################

# Replace the following path with the path on your computer
dir = 
  "/Users/yrose/Dropbox (Personal)/website/yu/ids2460-dataMgmtForAnal/79spr22-ids2460-dataManagement/exampleFolder-dataMgmt-mac-fall2018"
setwd(dir)

# This should open another window to show the file contents
file.show("readme.txt")  
dir()
