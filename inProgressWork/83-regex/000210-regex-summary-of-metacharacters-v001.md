# Regular expressions:

  - Regular expressions are not an "R" thing. Regular expressions are available
    in MANY technolory environments, including R, Python, Java, and most other
	  languages, some Bash commands, VSCode and many other text editors.
	
  - The exact rules for regular expressions may be slightly different in different
    environments. However, the vast majority of the rules are the same in different environments.
	
# Functions from the base R installation

  * grep(pattern, x, ignore.case = FALSE, perl = FALSE, value = FALSE,
         fixed = FALSE, useBytes = FALSE, invert = FALSE)

    - search for a pattern in a vector, x. 
  
    - if `value` is TRUE then the actual value is returned
  
    - if `value` is FALSE then the position is returned

  * grepl(pattern, x, ignore.case = FALSE, perl = FALSE,
          fixed = FALSE, useBytes = FALSE)

    - search for a pattern in a vector, x. Return a logical vector.

    - we covered the arguments:  pattern, x, ignore.case

    - we did not (yet?) cover the arguments: perl, fixed, useBytes

  * sub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,
         fixed = FALSE, useBytes = FALSE)

    - substitute the first text that matches the pattern with the replacement
      in each entry in the vector x.
  
    - we covered the arguments:  pattern, x, ignore.case

    - we did not yet cover the arguments: perl, fixed, useBytes

  * gsub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,
         fixed = FALSE, useBytes = FALSE)

    - gsub is similar to sub, but gsub replaces EVERY occurrence of `pattern` 
	    with `replacement` (sub only replaces the first occurrence). The "g" 
	    in "gsub" stands for "global".

	  
  * strsplit(x, split, fixed = FALSE, perl = FALSE, useBytes = FALSE)

    - split the entries in vector x into different characters values
	
	- split is a regular expression pattern. The text is split everywhere
	  the pattern matches
	  
	- IMPORTANT: the return value of strsplit is a LIST of character vectors

# stringr package

## functions from the stringr package

  * str_view(string, pattern = NULL, match = TRUE, 
             html = FALSE, use_escapes = FALSE )

    - string is a character vector
	
	- Displays the values from string that match the pattern.
	  Highlights the text from each character value that matched the pattern.
	  This is helpful for learning regular expressions. 
	  (see the documentation for the match argument)
	  
    - we covered the arguments: string, pattern

    - we did not yet cover the arguments: match, html, use_escapes


## data from the stringr package

  - stringr::words

  - stringr::fruit

  - stringr::sentences



# regular expression meta-characters

## anchors ( ^ and $ ) "anchor" the pattern to the beginning or end of the text

^pattern - pattern starts at the beginning of the text

pattern$  -  pattern appears at the end of the text



## period

.         - matches any single character


## \backslash

  - Before we begin, we must say that using backslashes with regular expressions in R code vs. using 
    backslashes with regular expressions in other environments (e.g. text editors like R's Script
    editor window, and many other similar text editors)	is slightly different. 
	
  - In general, a backslash takes away the special meaning from the following character.
  
    For example, "\." is a regular expression that matches an ACTUAL period, 
    while "." is a regular expression that matches any single character
	(see the "period" meta-character described above). 

    When we use backslashes in this way we say that the backslash is "escaping" the
    regular meaning of the following character.
	
  - In classic regular expressions you simply use a single backslash to take
    away the meaning from the following character.
    For example, when using regular expression searches  in VSCode,
    searching for \. will only match actual periods. 
	
	In R you must use two backslahes, insted of a single backslash.
	
	For example, in R, grep(c("Hi.", "apple") , pattern="\\.", value=TRUE)
	with two \\backslashes in the pattern will only match "Hi." and not "apple"
	since "Hi." contains an actual period and "apple" does not.
	However, grep(c("Hi.", "apple") , pattern="\.", value=TRUE)
	with a single \backslash in the pattern	causes an error, i.e: 
	*Error: '\.' is an unrecognized escape in character string starting ""\."*
	
	You must use two backslashes in R inside regular expressions since R first processes the 
	pattern as though it were a regular R character value. 
	Normaly, in R character values a backslash also means something. For example, 
    in R \n is used for a newline character, \t for a tab, \" for a quote, \' for an apostrophe.
    Normally in R \\ is used to represent a single backslash. For example cat("\\") displays only one "\".
	R only recognizes a limited number of escape sequences and "\." is NOT one of them. 
	Therefore if you type :   grep(c("Hi.", "apple") , pattern="\.", value=TRUE)
	R does not recognize what "\." is and stops with an error.
	
	Therefore in R you need to type two backslahes in regular expressions.
	For example in the code: grep(c("Hi.", "apple") , pattern="\\.", value=TRUE)
	The text "\\." is processed by R to actually be "\.". That value, i.e. "\." is 
	then passed to the regular expression processor in R to perform the regular
	expression processing.
	
  - For these reasons, to match an actual backslash in the text, you must type
    FOUR backslashes in R. 
	
	For example:   
	
	  * cat( grep(c("\\", "apple"), pattern="\\\\", value=TRUE) )
	
	  * results in: \
		
	While:
	
	  * cat( grep(c("\\", "apple"), pattern="\\", value=TRUE) )
	
	  * results in: ERROR - invalid regular expression.	
	  
	    Since "\\" becomes the regular expression "\" which has no meaning.
	


## [square brackets]   (also known as "character classes")

[abc]     - matches any single one of a or b or character

[a-f]     - matches any single one of a or b or c or d or e or f

[a-c0-3]    - matches any single character from a,b,c,0,1,2,3

[a-cxyz0-3]   - matches any single character from a,b,c,x,y,z,0,1,2,3

[^aeiou]    - matches any single character that is not one of a,e,i,o,u

[^a-c0-3]   - matches any single character that is NOT one of : a,b,c,0,1,2,3

^[aeiou]      - matches any vowel at the beginning of the text

^[^aeiou]      - matches any NON-vowel at the beginning of the text

### The majority of meta characters lose their special meaning  when enclosed in the [square brackets]

  * [.?!]         - matches any single character from . ? !
  
    You don't need \\ before the . but it doesn't hurt if you have it anyway.

  * grep(pattern="\\.a", x=SOME_CHARACTER_VECTOR)

    matches a period followed by an a 

  * grep(pattern="[.]a", x=SOME_CHARACTER_VECTOR)

    This pattern is equivalent to the above pattern. The [.] takes away
    the special meaning of the period.


### The ONLY four meta-characters that have a special meaning inside [square brackets] are  ^ ] - and \

  * ^ at the beginning of the [^brackets] means NOT any one of those characters
   
  * inside the [brac-kets] means a range of characters
  
  * ] inside the brackets means that that the brackets have ended

  Therefore if you want to actually match one of these special characaters
  You can do one of two things. 
  
  * you can precede the special character
    with a backslash (in R you would need two backslashes) or 
    
  * follow the following rules:
  
    -  to include a "^" in brackets put the ^ anywhere, except for the 
       first character in the brackets, e.g. [.^?] matches any of a
       period (.) a caret (^) or a question mark (?)

    -  to include a "-" in brackets put the - either as the first or last 
       character in the [brackets], e.g. [-.?] matches a dash a period or a    question mark

    - to include a "]" make it the FIRST character, e.g. [].?]  
      matches one of "]"  "."  or "?"

