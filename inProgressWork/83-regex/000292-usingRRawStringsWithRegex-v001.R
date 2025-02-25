# The concept of a "raw string" was introduced recently in R 4.0
#
# Any string (ie. character value) that appears between r"( .... )"
# is quoted as exactly the value that appears between the r"( and )"
# symbols. For detailed info about R's new raw string feature see this page:
#
#    https://r4ds.hadley.nz/strings.html#sec-raw-strings
#
# You can use an R "raw string" to quote anything without
# resorting to backslahes or other techniques.
#
# To create a "raw string" in R place the text that you want to quote
# between    r"(      and      )"
# (the r stands for raw, not "R")
#
# The text being quoted can safely include any characters you like.
# For example, the following "strangeValue" gets displayed just fine.

strangeValue = r"( Backslash: \  Quote: "  Apostrophe: ' )"

cat(strangeValue)    # Backslash: \  Quote: "  Apostrophe: ' 


# You can use r"(raw strings)" to very simply quote regular expression 
# pattern regardless of what metacharacters are in the pattern.

# For example, the following is a regex pattern to match numbers in the
# form:  999.99999  i.e. numbers that contain a decimal point and 
# have at least one digit before and at least one digit after 
# the decimal point.
#
#        \d+\.\d+
#
# To include this pattern in a regular R string you would need 
# to use \\double-backslashes. With "raw strings" you do not need
# to use \\double-backslashes. See the examples below


#   without raw strings - you NEED \\double-backslashes

pattern = "\\d+\\.\\d+"       # this is NOT a raw string
cat(pattern)   # \d+\.\d+
charNums = c("one", "1.593", "278.123", "999")
grep(pattern, charNums, value=TRUE)

#   with raw strings - you DON'T need the \\double-backslashes

pattern = r"(\d+\.\d)"        # this is a "raw string"
cat(pattern)   # \d+\.\d+
charNums = c("one", "1.593", "278.123", "999")
grep(pattern, charNums, value=TRUE)

