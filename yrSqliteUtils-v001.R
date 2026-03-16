# =============================================================================
# SQLite Utility Functions
# 
# Helper functions for converting between R data frames and SQLite databases.
# Useful for bundling multiple data frames into a single portable file,
# or for loading all tables from a SQLite database into R.
#
# Dependencies: DBI, RSQLite, tcltk (for file/folder picker dialogs)
#
#
# -------------------
# Functions Provided
# -------------------
#
# dfsToSqlite()   - Write data frames from the global environment to a SQLite
#                   database (one table per data frame).
#
# sqliteToDfs()   - Load all tables from a SQLite database into R as data frames
#                   (optionally placing them in the global environment).
#
# sqliteToExcel() - Export all tables in a SQLite database to an Excel workbook
#                   with one worksheet per table.
#
# sqliteToRData() - Save all tables from a SQLite database into an .RData file
#                   as individual data frame objects.
#
# rdataToSqlite() - Load an .RData file and write any contained data frames
#                   to a SQLite database (one table per data frame).
#
# excelToSqlite() - Import all worksheets from an Excel file into a SQLite
#                   database, with optional control over where headers start
#                   in each sheet.
# =============================================================================


if (!require(DBI)) { install.packages("DBI"); require(DBI) }
if (!require(RSQLite)) { install.packages("RSQLite"); require(RSQLite) }
if (!require(openxlsx)) { install.packages("openxlsx"); require(openxlsx) }
if (!require(tcltk)) { install.packages("tcltk"); require(tcltk) }


# -----------------------------------------------------------------------------
# dfsToSqlite
# 
# Writes data frames from the global environment into a SQLite database file.
# Each data frame becomes a table, named after the variable.
# Non-data-frame objects are silently skipped.
#
# Arguments:
#   sqliteFilename - (character) Path to the SQLite file to create/overwrite.
#                    If the file already exists, matching tables are overwritten.
#   objs           - (character vector, optional) Names of objects to export.
#                    If omitted, all objects in the global environment are
#                    checked and any data frames found are exported.
#
# Returns:
#   Nothing. Called for its side effect of writing to a SQLite file.
#
# ==============
# Usage Examples
# ==============
#
# --- Example 1: Export all data frames in the environment ----------------
#
# movies   <- data.frame(title = c("Toy Story", "Cars"), year = c(1995, 2006))
# boxoffice <- data.frame(movie_id = c(1, 2), revenue = c(373, 462))
#
# # Writes both 'movies' and 'boxoffice' tables to the SQLite file
# dfsToSqlite("my_data.sqlite")
#
#
# --- Example 2: Export only specific data frames -------------------------
#
# dfsToSqlite("my_data.sqlite", c("movies", "boxoffice"))
#
#
# --- Example 3: Let the user pick where to save with a file dialog -------
#
# savePath <- tcltk::tclvalue(tcltk::tkgetSaveFile(
#   defaultextension = ".sqlite",
#   filetypes = "{{SQLite Files} {.sqlite}} {{All Files} {*}}"
# ))
# if (nchar(savePath) > 0) {
#   dfsToSqlite(savePath)
# }
# -----------------------------------------------------------------------------
dfsToSqlite <- function(sqliteFilename, objs) {
  con <- dbConnect(SQLite(), sqliteFilename)
  on.exit(dbDisconnect(con))
  
  # If no object names were passed in, grab everything in the global environment
  if (missing(objs))
    objs <- ls(envir = .GlobalEnv)
  
  for (name in objs) {
    obj <- get(name, envir = .GlobalEnv)
    # Only write objects that are data frames; skip everything else
    if (is.data.frame(obj)) {
      dbWriteTable(con, name, obj, overwrite = TRUE)
    }
  }
}



# -----------------------------------------------------------------------------
# sqliteToDfs
# 
# Reads all tables from a SQLite database and returns them as data frames.
#
# Arguments:
#   sqliteFilename - (character) Path to an existing SQLite file.
#   toGlobalEnv    - (logical, default FALSE) If TRUE, each table is also
#                    loaded into the global environment as a separate variable
#                    (e.g., a table named "movies" becomes a variable `movies`).
#                    If FALSE, tables are only returned as a named list.
#
# Returns:
#   A named list of data frames, one per table. If toGlobalEnv = TRUE,
#   the list is returned invisibly (and the data frames are also created
#   as individual variables in the global environment).
# ==============
# Usage Examples
# ==============
# --- Example 1: Load tables as a list -----------------------------------
#
# dfs <- sqliteToDfs("my_data.sqlite")
# dfs$movies        # access the movies table
# dfs$boxoffice     # access the boxoffice table
#
#
# --- Example 2: Load tables directly into the global environment ---------
#
# sqliteToDfs("my_data.sqlite", toGlobalEnv = TRUE)
# # Now you can use them directly:
# head(movies)
# summary(boxoffice)
#
#
# --- Example 3: Let the user pick a SQLite file to load -----------------
#
# filepath <- tk_choose.files(
#   caption = "Select a SQLite database",
#   filter = matrix(c("SQLite Files", ".sqlite", "All Files", ".*"),
#                   ncol = 2, byrow = TRUE)
# )
# if (length(filepath) > 0 && nchar(filepath) > 0) {
#   sqliteToDfs(filepath, toGlobalEnv = TRUE)
# }
# -----------------------------------------------------------------------------
sqliteToDfs <- function(sqliteFilename, toGlobalEnv = FALSE) {
  if (!file.exists(sqliteFilename)) {
    stop("File not found: ", sqliteFilename)
  }
  
  con <- dbConnect(SQLite(), sqliteFilename)
  on.exit(dbDisconnect(con))
  
  tables <- dbListTables(con)
  
  # Read each table into a named list
  dfs <- list()
  for (name in tables) {
    dfs[[name]] <- dbReadTable(con, name)
  }
  
  # Optionally inject each data frame into the global environment
  if (toGlobalEnv) {
    list2env(dfs, envir = .GlobalEnv)
    message("Loaded ", length(dfs), " tables: ", paste(names(dfs), collapse = ", "))
    return(invisible(dfs))
  }
  
  dfs
}





# -----------------------------------------------------------------------------
# sqliteToExcel
#
# Converts all tables in a SQLite database into an Excel workbook.
# Each SQLite table becomes one worksheet.
#
# Arguments:
#   sqliteFilename - (character) Path to an existing SQLite file.
#   excelFilename  - (character, optional) Output .xlsx file path.
#                    If omitted, the user is prompted to choose a location.
#
# Dependencies:
#   openxlsx
#
# Returns:
#   Nothing. Called for its side effect of writing an Excel file.
#
# ==============
# Usage Examples
# ==============
#
# # Save the data to a specific Excel filename
#
# sqliteToExcel("my_data.sqlite", "my_data.xlsx")
#
# # Or let the user pick the save location:
#
# sqliteToExcel("my_data.sqlite")
# -----------------------------------------------------------------------------
sqliteToExcel <- function(sqliteFilename, excelFilename) {
  
  if (!file.exists(sqliteFilename)) {
    stop("File not found: ", sqliteFilename)
  }
  
  # Ask user where to save if no filename provided
  if (missing(excelFilename)) {
    excelFilename <- tcltk::tclvalue(tcltk::tkgetSaveFile(
      defaultextension = ".xlsx",
      filetypes = "{{Excel Files} {.xlsx}} {{All Files} {*}}"
    ))
    
    if (nchar(excelFilename) == 0) return(invisible(NULL))
  }
  
  con <- dbConnect(SQLite(), sqliteFilename)
  on.exit(dbDisconnect(con))
  
  tables <- dbListTables(con)
  
  wb <- createWorkbook()
  
  for (name in tables) {
    df <- dbReadTable(con, name)
    addWorksheet(wb, name)
    writeData(wb, name, df)
  }
  
  saveWorkbook(wb, excelFilename, overwrite = TRUE)
  
  message("Wrote ", length(tables), " tables to: ", excelFilename)
}


# -----------------------------------------------------------------------------
# sqliteToRData
#
# Reads all tables from a SQLite database and saves them into an .RData file.
# Each table becomes a data frame object inside the RData file.
#
# Arguments:
#   sqliteFilename - (character) Path to an existing SQLite file.
#   rdataFilename  - (character, optional) Output .RData file path.
#                    If omitted, the user is prompted to choose a location.
#
# Returns:
#   Nothing. Called for its side effect of writing an .RData file.
#
# ==============
# Usage Examples
# ==============
#
# --- Example 1: Convert SQLite database to RData file -------------------
#
# sqliteToRData("my_data.sqlite", "my_data.RData")
#
#
# --- Example 2: Let the user pick where to save -------------------------
#
# sqliteToRData("my_data.sqlite")
# -----------------------------------------------------------------------------
sqliteToRData <- function(sqliteFilename, rdataFilename) {
  
  if (!file.exists(sqliteFilename)) {
    stop("File not found: ", sqliteFilename)
  }
  
  # Ask user where to save if not provided
  if (missing(rdataFilename)) {
    rdataFilename <- tcltk::tclvalue(tcltk::tkgetSaveFile(
      defaultextension = ".RData",
      filetypes = "{{RData Files} {.RData}} {{All Files} {*}}"
    ))
    
    if (nchar(rdataFilename) == 0) return(invisible(NULL))
  }
  
  con <- dbConnect(SQLite(), sqliteFilename)
  on.exit(dbDisconnect(con))
  
  tables <- dbListTables(con)
  
  dfs <- list()
  
  for (name in tables) {
    dfs[[name]] <- dbReadTable(con, name)
  }
  
  # Save all tables as objects in the RData file
  list2env(dfs, envir = environment())
  save(list = names(dfs), file = rdataFilename, envir = environment())
  
  message("Saved ", length(dfs), " tables to: ", rdataFilename)
}

# -----------------------------------------------------------------------------
# rdataToSqlite
#
# Loads objects from an .RData file and writes any data frames found
# into a SQLite database. Each data frame becomes a table with the
# same name as the object.
#
# Arguments:
#   rdataFilename  - (character) Path to an existing .RData file.
#   sqliteFilename - (character, optional) Output SQLite file path.
#                    If omitted, the user is prompted to choose a location.
#
# Returns:
#   Nothing. Called for its side effect of writing a SQLite file.
#
# ==============
# Usage Examples
# ==============
#
# --- Example 1: Convert RData file to SQLite database -------------------
#
# rdataToSqlite("my_data.RData", "my_data.sqlite")
#
#
# --- Example 2: Let the user pick where to save -------------------------
#
# rdataToSqlite("my_data.RData")
# -----------------------------------------------------------------------------
rdataToSqlite <- function(rdataFilename, sqliteFilename) {
  
  if (!file.exists(rdataFilename)) {
    stop("File not found: ", rdataFilename)
  }
  
  # Ask user where to save if not provided
  if (missing(sqliteFilename)) {
    sqliteFilename <- tcltk::tclvalue(tcltk::tkgetSaveFile(
      defaultextension = ".sqlite",
      filetypes = "{{SQLite Files} {.sqlite}} {{All Files} {*}}"
    ))
    
    if (nchar(sqliteFilename) == 0) return(invisible(NULL))
  }
  
  env <- new.env()
  load(rdataFilename, envir = env)
  
  objs <- ls(env)
  
  con <- dbConnect(SQLite(), sqliteFilename)
  on.exit(dbDisconnect(con))
  
  written <- c()
  
  for (name in objs) {
    obj <- get(name, envir = env)
    
    if (is.data.frame(obj)) {
      dbWriteTable(con, name, obj, overwrite = TRUE)
      written <- c(written, name)
    }
  }
  
  message("Wrote ", length(written), " tables: ", paste(written, collapse = ", "))
}


# -----------------------------------------------------------------------------
# excelToSqlite
#
# Reads all worksheets from an Excel file and writes them to a SQLite database.
# Each worksheet becomes a table. Assumes the first row of the data contains
# column headers.
#
# The location of the upper-left header cell can optionally be specified.
# If not specified, the function automatically searches for the first non-blank
# cell scanning column A, then B, then C, etc.
#
# Arguments:
#   excelFilename   - (character) Path to an Excel (.xlsx/.xls) file.
#   sqliteFilename  - (character, optional) Output SQLite file path.
#                     If omitted, the user is prompted to choose a location.
#   startCells      - (character vector, optional) Excel cell references
#                     indicating the upper-left header cell for each sheet
#                     (e.g., c("A1","B3","A2")).
#                     Each entry corresponds to the matching sheet index.
#                     If fewer entries than sheets are provided, remaining
#                     sheets use automatic detection.
#
# Dependencies:
#   readxl
#
# Returns:
#   Nothing. Called for its side effect of writing a SQLite file.
# -----------------------------------------------------------------------------
excelToSqlite <- function(excelFilename, sqliteFilename, startCells = NULL) {
  
  if (!file.exists(excelFilename)) {
    stop("File not found: ", excelFilename)
  }
  
  if (!require(readxl)) {
    install.packages("readxl")
    library(readxl)
  }
  
  # Ask where to save if not provided
  if (missing(sqliteFilename)) {
    sqliteFilename <- tcltk::tclvalue(tcltk::tkgetSaveFile(
      defaultextension = ".sqlite",
      filetypes = "{{SQLite Files} {.sqlite}} {{All Files} {*}}"
    ))
    if (nchar(sqliteFilename) == 0) return(invisible(NULL))
  }
  
  sheets <- readxl::excel_sheets(excelFilename)
  
  con <- dbConnect(SQLite(), sqliteFilename)
  on.exit(dbDisconnect(con))
  
  # Helper: detect first non-blank cell scanning columns left→right
  detectStartCell <- function(sheet) {
    
    preview <- readxl::read_excel(
      excelFilename,
      sheet = sheet,
      col_names = FALSE,
      .name_repair = "minimal"
    )
    
    preview <- as.data.frame(preview)
    
    for (col in seq_len(ncol(preview))) {
      column <- preview[[col]]
      
      idx <- which(!is.na(column) & column != "")[1]
      
      if (!is.na(idx)) {
        colLetter <- openxlsx::int2col(col)
        return(paste0(colLetter, idx))
      }
    }
    
    stop("Could not detect data start in sheet: ", sheet)
  }
  
  written <- c()
  
  for (i in seq_along(sheets)) {
    
    sheet <- sheets[i]
    
    # Determine starting cell
    start <- NULL
    if (!is.null(startCells) && length(startCells) >= i) {
      start <- startCells[i]
    } else {
      start <- detectStartCell(sheet)
    }
    
    df <- readxl::read_excel(
      excelFilename,
      sheet = sheet,
      range = readxl::cell_rows(NULL),
      skip = 0,
      col_names = TRUE
    )
    
    # Re-read using the detected range
    df <- readxl::read_excel(
      excelFilename,
      sheet = sheet,
      range = paste0(start, ":1048576")
    )
    
    tableName <- make.names(sheet)
    
    dbWriteTable(con, tableName, as.data.frame(df), overwrite = TRUE)
    
    written <- c(written, tableName)
  }
  
  message("Wrote ", length(written), " tables: ", paste(written, collapse = ", "))
}


# =============================================================================
# Usage Examples - excelToSqlite()
# =============================================================================

# --- Example 1: Convert an Excel file directly -------------------------
#
# excelToSqlite("my_data.xlsx", "my_data.sqlite")


# --- Example 2: Specify header locations for sheets --------------------
#
# excelToSqlite(
#   "my_data.xlsx",
#   "my_data.sqlite",
#   startCells = c("A1", "B3", "A2")
# )


# --- Example 3: Let the user choose where to save ----------------------
#
# excelToSqlite("my_data.xlsx")

