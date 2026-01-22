#!/bin/bash

# This was created by claude.ai

# Function to display help message
show_help() {
    echo "Usage: $0 <filename>"
    echo
    echo "Renumbers chapter numbers in comments of the form '# yrChapterNumber n'"
    echo "where n is a number. Numbers will be replaced sequentially starting from 1."
    echo "Skips lines that are commented out (first non-whitespace character is #)."
    echo
    echo "Arguments:"
    echo "  filename    The file to process"
    echo
    echo "Options:"
    echo "  -h         Display this help message"
    echo
    echo "Example:"
    echo "  $0 myfile.yml"
    echo
    echo "Note: A backup of the original file will be created as filename.bak"
}

# Check for help flag or incorrect number of arguments
if [ "$1" = "-h" ] || [ "$#" -ne 1 ]; then
    show_help
    [ "$1" = "-h" ] && exit 0 || exit 1
fi

filename="$1"

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found"
    exit 1
fi

# Create a temporary file
temp_file=$(mktemp)

# Initialize counter
counter=1
matches_found=0

# Process the file line by line
while IFS= read -r line; do
    # Check if line is commented out (first non-whitespace character is #)
    if [[ $line =~ ^[[:space:]]*# ]]; then
        # Line is commented out - write it unchanged
        echo "$line" >> "$temp_file"
        echo "Skipping commented line: '$line'"
    # Check if the line ends with the chapter number pattern
    elif [[ $line =~ .*#[[:space:]]*yrChapterNumber[[:space:]]+[0-9]+[[:space:]]*$ ]]; then
        # Preserve everything up to the last occurrence of "# yrChapterNumber"
        prefix=$(echo "$line" | sed -E 's/#[[:space:]]*yrChapterNumber[[:space:]]+[0-9]+[[:space:]]*$//')
        # Create the new line with the sequential number
        new_line="${prefix}# yrChapterNumber $counter"
        echo "$new_line" >> "$temp_file"
        echo "Renumbering: '$line' -> '$new_line'"
        ((counter++))
        ((matches_found++))
    else
        # Keep non-matching lines unchanged
        echo "$line" >> "$temp_file"
    fi
done < "$filename"

if [ $matches_found -eq 0 ]; then
    echo "Warning: No chapter numbers were found to renumber!"
    rm "$temp_file"
    exit 1
else
    echo "Found and renumbered $matches_found chapter numbers."
    # Backup original file
    cp "$filename" "$filename.bak"
    # Move temporary file to original
    mv "$temp_file" "$filename"
    echo "Original file has been backed up as $filename.bak"
fi