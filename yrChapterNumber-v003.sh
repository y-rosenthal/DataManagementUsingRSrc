# This script was generated mostly by chatgpt.com 
# with modifications by me (yrosenthal)
# https://chatgpt.com/c/670953e9-bc5c-800b-8d27-60ed9eeb8258
#
# The following script reads the _quarto.yml file to determine the contents
# of the <yrChapterNumber></yrChapterNubmer> element in the associated
# .qmd files. The script then replaces the contents of the <yrChapterNubmer>
# element with the appropriate value - based on the .qmd file.
#
# The _quarto.yml file should have # yrChapterNumber comments similar to the
# following at the end of a line that has a .qmd file on it.
#
#   EXAMPLE from a _quarto.yml file
#
#    - part: Some computer basics
#      chapters:
#      - intro00100-operatingSystems.qmd  # yrChapterNumber 1
#      - intro00120-files.qmd             # yrChapterNumber 2
#      - intro00130-chromeExtensions.qmd  # yrChapterNumber 3
#
#    - part: Into to Coding With AI
#      chapters:
#      - ai-000100-overview.qmd           # yrChapterNumber 4
#      - aiCoding00100-overview.qmd       # yrChapterNumber 5
#
# Note that if a line contains other comments, the # yrChapterNumber 
# comment should come at the end of the line. For example, see the
# # yrChapterNumber comments for chapters 32-35,38,39,40. They 
# all have a comment that precedes the # yrChapterNubmer comment.
#
#    - part: Relational databases and SQL (no dplyr knowledge needed)
#      chapters:
#      - sql0006-introToDatabases-v023.qmd # copied from introToSQL # yrChapterNumber 32
#      - sql0014-theBooksDatabase-v001.qmd # NEW # yrChapterNumber 33
#      - sql0010-introToSql-v023.qmd       # NEW # yrChapterNumber 34
#      - sql0035-workingWithMultipleTables-v012.qmd # renumbered from sql0020 # yrChapterNumber 35
#      - sql0030-sqlFunctions_aggregateFunctions_groupBy_having-v019.qmd # yrChapterNumber 36
#      - sql0040-crossJoin-leftJoin-subquery-selfJoins-v023.qmd # yrChapterNumber 37
#      - sql0050-commonTableExpressions-v001.qmd    # NEW # yrChapterNumber 38
#      - sql0200-otherSqlCommands-v002.qmd          # EDIT THIS  # yrChapterNumber 39
#      - sql0900-sqlWindowFunctions-v002.qmd        # NEW # yrChapterNumber 40
#      - sql0950-workingWithDatabasesInR-v010.qmd # yrChapterNumber 41
#      - 0600100-introToDb-v001.qmd # yrChapterNumber 42


#Uncomment these for debugging options
#I don't know if this still works ...
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

grep -i yrChapterNumber _quarto.yml | awk '!/^\s*#/ {print}' | awk '{$1=$1; print}' | while read -r line; do
  # Extract filename and yrChapterNumber
  filename=$(echo "$line" | cut -d'#' -f1 | xargs | sed 's/^-\s*//')
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
