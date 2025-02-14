message("Starting copy _quarto.yml to _book folder...")
result <- file.copy("_quarto.yml", "_book/_quarto.yml", overwrite = TRUE)
message("Copy operation result: ", result)
