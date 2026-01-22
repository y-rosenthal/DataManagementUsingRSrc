# This file contains several useful "utility" functions

require(fs)

# Function to wrap text and save to a new file
wrap_text_file <- function(input_file) {
  # Read the file content
  text <- readLines(input_file, warn = FALSE)
  
  # Wrap each line to 68 characters without breaking words
  wrapped_text <- unlist(lapply(text, strwrap, width = 68, simplify = TRUE))
  
  # Generate new filename by appending "_wrapped" before the extension
  file_parts <- strsplit(input_file, "\\.")[[1]]
  new_filename <- paste0(file_parts[1], "_wrapped.", file_parts[2])
  
  # Write to the new file
  writeLines(wrapped_text, new_filename)
  
  # Return the new filename
  return(new_filename)
}

#infile = "c:/Users/yrosenth/Downloads/tmpEmail.txt"
#outfile = "c:/Users/yrosenth/Downloads/tmpEmailWrapped.txt"

# Example usage
#input_file <- "example.txt"  # Change this to your filename
#new_file <- wrap_text_file(input_file)
#cat("Wrapped text saved to:", new_file, "\n")

# Example usage
#new_file <- wrap_text_file(infile)
#cat("Wrapped text saved to:", new_file, "\n")
