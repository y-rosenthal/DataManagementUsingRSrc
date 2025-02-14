# The following replaces adds the yrChapterNumber number to the 
# appropriate .qmd file. 
# The yrChapterNumber should appear at the end of the line for a .qmd file in 
# the _quarto.yml file (see the following example.)

#Uncomment these for debugging options
#
#set -x 
#set -v
#
#dryrun=false  # Set to true for dry run mode
#
# Function to run or echo the command based on dryrun mode
#run_command() {
#  if [ "$dryrun" = true ]; then
#    echo "Would run: $@"
#  else
#    $@
#  fi
#}

grep -i yrChapterNumber _quarto.yml | awk '{$1=$1; print}' | while read -r line; do

  # Extract filename and yrChapterNumber
  filename=$(echo "$line" | cut -d'#' -f1 | xargs | sed 's/^-\s*//')
  #yrChapterNumber=$(echo "$line" | sed -n 's/.*yrChapterNumber\s\+\(.*\S\).*/\1/p')
  #yrChapterNumber=$(echo "$line" | sed -n 's/.*yrChapterNumber\s\+\(.*\S\).*/\1./p' | sed 's/\.\s*$/\. /')
  yrChapterNumber=$(echo "$line" | sed -n 's/.*yrChapterNumber\s\+\(.*\S\).*/\1/p' | sed 's/$/. /')
  

  # Extract the current content inside <yrChapterNumber>...</yrChapterNumber>
  current_yrChapterNumber=$(grep -oP '(?<=<yrChapterNumber>).*?(?=</yrChapterNumber>)' "$filename")

  # Update the file only if the current content is different from $yrChapterNumber
  if [ "$current_yrChapterNumber" != "$yrChapterNumber" ]; then
  
    # Escape special characters in the replacement text
    escaped_replacement=$(echo "$yrChapterNumber" | sed -e 's/[\#&]/\\&/g')

    # Use the escaped replacement text in the sed command
    sed -i "s#<yrChapterNumber>.*</yrChapterNumber>#<yrChapterNumber>$escaped_replacement</yrChapterNumber>#g" "$filename"

    echo "Attempted to update file: $filename with yrChapterNumber $yrChapterNumber"
  else
    echo "No update needed for file: $filename"
  fi
done