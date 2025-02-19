#!/bin/bash

# This was created by claude.ai
# URL: https://claude.ai/chat/eae343be-39f3-45b5-b394-f0159297d6be
# CHAT NAME:  "create yrRenumberChapters.sh script")

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
changes_made=0

# Process the file line by line
while IFS= read -r line; do
    # Check if line is commented out (first non-whitespace character is #)
    if [[ $line =~ ^[[:space:]]*# ]]; then
        # Line is commented out - write it unchanged
        echo "$line" >> "$temp_file"
        echo "Skipping commented line: '$line'"
    # Check if the line ends with the chapter number pattern
    elif [[ $line =~ .*#[[:space:]]*yrChapterNumber[[:space:]]+[0-9]+[[:space:]]*$ ]]; then
        # Extract current number
        current_num=$(echo "$line" | grep -oE '[0-9]+[[:space:]]*$')
        current_num=${current_num%% *} # Remove trailing whitespace
        
        # Preserve everything up to the last occurrence of "# yrChapterNumber"
        prefix=$(echo "$line" | sed -E 's/#[[:space:]]*yrChapterNumber[[:space:]]+[0-9]+[[:space:]]*$//')
        
        # Create the new line with the sequential number
        new_line="${prefix}# yrChapterNumber $counter"
        
        # Show appropriate message based on whether number changed
        if [ "$current_num" -ne "$counter" ]; then
            echo "Updating chapter $current_num → $counter:"
            echo "  $line"
            ((changes_made++))
        else
            echo "Chapter $current_num is already correct:"
            echo "  $line"
        fi
        
        echo "$new_line" >> "$temp_file"
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
    echo "Found $matches_found chapter numbers."
    if [ $changes_made -eq 0 ]; then
        echo "No changes were necessary - all chapter numbers were already sequential."
        rm "$temp_file"
        exit 0
    else
        echo "Made $changes_made changes to chapter numbers."
        # Backup original file
        cp "$filename" "$filename.bak"
        # Move temporary file to original
        mv "$temp_file" "$filename"
        echo "Original file has been backed up as $filename.bak"
    fi
fi

