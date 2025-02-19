dryrun=false  # Set to true for dry run mode

# Function to run or echo the command based on dryrun mode
run_command() {
  if [ "$dryrun" = true ]; then
    echo "Would run: $@"
  else
    $@
  fi
}

grep -i yrChapterNumber _quarto.yml | awk '{$1=$1; print}' | while read -r line; do
  # Extract filename and yrChapterNumber
  filename=$(echo "$line" | cut -d'#' -f1 | xargs | sed 's/^-\s*//')
  
  # Extract yrChapterNumber without using a lookbehind, capturing until the last non-whitespace character
  yrChapterNumber=$(echo "$line" | sed -n 's/.*yrChapterNumber\s\+\(.*\S\).*/\1/p' | sed 's/$/. /')

  # Extract the current content inside <yrChapterNumber>...</yrChapterNumber>
  current_yrChapterNumber=$(grep -oP '(?<=<yrChapterNumber>).*?(?=</yrChapterNumber>)' "$filename")

  # Update the file only if the current content is different from $yrChapterNumber
  if [ "$current_yrChapterNumber" != "$yrChapterNumber" ]; then
    # Properly append a period and space and escape any special characters
    run_command sed -i "s|<yrChapterNumber>.*</yrChapterNumber>|<yrChapterNumber>${yrChapterNumber//\\/\\\\}</yrChapterNumber>|" "$filename"
    echo "Updated file: $filename with yrChapterNumber $yrChapterNumber"
  else
    echo "No update needed for file: $filename"
  fi
done

