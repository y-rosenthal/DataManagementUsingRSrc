##################################################################.
# Using the stringr package
##################################################################.

# The stringr package has many different functions for manipulating text.
# The following are some ways to learn more about stringr (and other 
# packages in R)

#~~~~~~~~~~~~~~~~~~~~~
# See the help pages.
#~~~~~~~~~~~~~~~~~~~~~
help(package="stringr")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Look at the "vignettes" for the package.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Open a browser with links to the "vignettes" for stringr
browseVignettes("stringr")

# Open a browser with links to all "vignettes" all packages that were
# installed on your computers
browseVignettes()

# To see vignettes for a package that you haven’t installed, look at the
# “Vignettes” listing on its CRAN page, e.g.
#   https://cran.r-project.org/web/packages/tidyr/index.html.
#
# This page lists all of the R packages on CRAN:
#   https://cran.r-project.org/web/packages/available_packages_by_name.html
#
# For tidyverse packages you can also search the tidyverse website:
#   https://www.tidyverse.org/

######################################################.
# Using the regex functions in the stringr package
######################################################.

# See the vignette for using regular expressions with stringr functions:
#
#   https://stringr.tidyverse.org/articles/regular-expressions.html


# some stringr regex functions:

?stringr::regex           # use this to specify options such as ignore.case
?stringr::str_subset      # equivalent to base::grep(pattern, x, value=TRUE)
?stringr::str_detect      # equivalent to base::grepl(pattern, x)
?stringr::str_extract     # return first match in each string (as a character vector)
?stringr::str_extract_all # return all matches in each string (as a list of character vectors)
?stringr::str_split       # similar    to base::strsplit
?stringr::str_match       # return character matrix for first match with matching groups in columns
?stringr::str_match_all   # return list of character matrices - each matrix contains one row for each match in a single string

# Make sure to look at the "Examples" section at the end of the help pages.
#
# You can use the example function to see the output of the "Examples" at 
# the end of a particular help page, e.g.
example(str_match)


# Data available from stringr package
sentences
words
stringr::fruit

# Groups in regex

# match the first letter in every sentence in sentences variable
str_view(sentences, 
         pattern= "^[A-Za-z]")


# match the first word in every sentence in sentences variable
str_view(sentences, 
         pattern= "^[A-Za-z]+")



###################################################################.
# Matching groups in a regular expression
#
# Parentheses in a regex creates a group of text that will be "remembered".
# The first group can be referred to as \1 the 2nd group as \2 etc.
# (don't forget, in R you must use \\ instead of \)
# See examples below.
###################################################################.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Using groups to modify the strings
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Let's try to move the first word of every sentence to the end of the sentence.
# The pattern shown below contains two parts of the regular expression. 
# Each part of the regex is surrounded by parentheses.
#
# The parentheses will be important soon, but for now, in order to understand
# this pattern just ignore the parentheses. 
# The pattern matches, starting from the begining of the text any sequence
# of one or more letters, followed by any other text.
#
#    ^[A-Za-z]+     matches the first word
#    .*             matches the rest of the text
#
# Now, notice that the different parts are surrounded by (parentheses).
# Each parenthesized part of the regex is known as a "group".
# We'll see the significance of the (groups) soon but for now, let's just 
# see that each sentence is matched in its entirety.

patternWithGroups = "(^[A-Za-z]+)(.*)"

# Entire sentence is matched
str_view(sentences, 
         pattern= patternWithGroups)

# When processing a regular expression, the text in a string that was 
# matched by each group in the pattern is "remembered".
#
# The text that matches the 1st group can be referred to as \1 
# The text that matches the 2nd group can be referred to as \2
# Note that in R you must use two backslashes \\1 \\2 etc.
#
# Standard regex allows for up to 9 groups (i.e. \1 through \9). 
# If you need 10 or more groups in a single pattern then there are different
# approaches in different regex systems. Search online for more info.
#
# For example the following uses groups to move the first word of a 
# sentence to the end of the sentence. The replacement argument
# in the str_replace_all specifies what you want to replace the 
# text that matched the full pattern with. The following example
# replaces the entire sentence (which match the entire pattern)
# with a new version of the sentence that places the first word of the
# original sentence at the end of the new "sentence".

# Use str_replace_all (from stringr) or gsub (from the base R package)
# to replace the original text with our new text.

str_replace_all(sentences, pattern=patternWithGroups, replacement="\\2\\1")

# Let's add a new group that captures the punctuation so that we can 
# be sure to put the original punctuation at the end of the new sentence.

patternWithThreeGroups = paste0(
  "(^[A-Za-z]+)",    # Match first word
  "([^.?!]*)",     # the rest of the sentence (without the punctuation)
  "([.?!])"      # punctuation at the end of the sentence
)

patternWithThreeGroups

str_replace_all(sentences, pattern=patternWithThreeGroups, replacement="\\2\\1\\3")

# Fix the results a little more by removing any whitespace that appears
# between first word and the 2nd word in the original sentence.
# We do so by explicitly matching the whitespace in the pattern. We
# don't need to include this whitespace in a parenthesized group
# as we will not be using it in the replacement argument.

pattern = paste0(
  "(^[A-Za-z]+)",    # Match first word
  "\\s+",            # match all the spaces or tabs the come after the first word
  "([^.?!]*)",     # the rest of the sentence (without the punctuation)
  "([.?!])"      # punctuation at the end of the sentence
)

pattern

# Let's also add a space at the end of the sentence before we insert the original
# first word at the end. To do so, add a space before \\1 in the replacement.

newSentences = str_replace_all(sentences, pattern=pattern, replacement="\\2 \\1\\3")
newSentences

# Finally, let's capitalize the sentences correctly by using the 
# function stringr::str_to_sentence.

newSentences = str_to_sentence(newSentences)

newSentences


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Using groups to find strings with repeating text
#
# You can also use groups to find patterns 
# that have repeating text. See examples below.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Find all words where the first letter is the same as the last letter.
# The pattern includes a (parenthesized) group AND a reference to that group \\1.
# The pattern means:
#    (^.)   match the very first character and remember it as \\1
#    .*     match as many other characters as you can while still matching the rest of the pattern
#    \\     the text must end with the same character as it started with (i.e. \\1)

pattern = "(^.).*\\1$"   # the first character in the text is same as last character

str_view(words, pattern)   # Entire pattern matches the entire word

grep(pattern, words, value=TRUE)  # words that start/end with same letter


# Show all words where first two letters match the last two letters in reverse
# e.g. words such as:
#   "engine" (starts with "en" and ends with "ne")
#   "level" (starts with "le" and ends with "el")
# 

pattern = "(^.)(.).*\\2\\1$"   

grep(pattern, words, value=TRUE)  


# show all words where the first two letters are the same as the last 2 letters
# e.g. words such as "decide" and "photograph"
pattern = "(^..).*\\1$"   

str_view(words, pattern)

grep(pattern, words, value=TRUE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# "greedy" vs "non-greedy" quantifiers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# By default, quantifiers such as +  *  ?  {3,} {3,9}
# will match AS MUCH as possible from the text.
# This is known as "greedy" matching.
# 
# If a quantifier is followed by a question mark it becomes
# a non-greedy quantifier and matches as little as it can
# while still satisfying the rest of the pattern. 
#
# See the examples below.

# The following will match the first vowel through the last vowel
# because the * is by default GREEDY in how it matches.
# 
# For example, given the word "creativity" this pattern will match 
# starting with the "e" and ending with the last "i".
# i.e. the part shown between the <angle-brackets>:  cr<eativi>ty.

pattern = "[aeiou].*[aeiou]"   # match from the first vowel through the last vowel
str_view(words, pattern = pattern)    


# Unfortunately, it's hard to see where the pattern starts if you just
# view the results for the words that start with "a". Therefore let's
# start viewing the results from the first word that start with a "b".

# We can find the position in the vector of the first word that 
# starts with a "b" by using the following command (that uses 
# a regular expression).

positionOfFirstB = min( grep("^b", words, value=FALSE) )
positionOfFirstB

# Now let's view our results again, this time, starting from 
# the first word that starts with a b.

str_view(words[positionOfFirstB:length(words)], pattern)


# All quantifiers are greedy by default
#
# * will match zero or more of the previous part of the regex (as much as it can)
# + will match ONE or more of the previous part of the regex (as much as it can)
# ? will match the value if it exists and only not match if it can't exist
#
# {m,n}  will match as many copies of the previous part of the regex until a max
#        of n copies but no fewer than m copies.

# To make a quantifier UN-GREEDY, follow it with a question mark. This 
# question mark does NOT mean what a question mark would mean otherwise.
# (Unfortunately, some meta characters mean different things depending 
#  on the context in which they appear)
#
# .*      # match as much as you can (greedy)
# .*?     # make the * ungreedy (match as little as possible while still matching the whole pattern)
#
# .+      # match at least one but as much as you can (greedy)
# .+?     # make the + ungreedy (match at least one but as little as possible)
#
# .?      # match or don't match (prefer a match)
# .??     # match or don't match (prefer to not match)

# In the following pattern matches we made the * UN-greedy by following it with ?
# This will now match all characters starting from the first vowel until the 
# NEXT vowel ( *? is UN-GREEDY )

unGreedyPattern = "[aeiou].*?[aeiou]"   # match from the first vowel through the last vowel
unGreedyPattern

results = str_view(words[positionOfFirstB:length(words)], unGreedyPattern)


words2 = c("hippopotamus", words)

str_view(words2, unGreedyPattern)
