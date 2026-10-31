# ============================================================
# Assignment 1 practice — install packages used for data import
# Source lesson: https://rpubs.com/Mapara_lee/1434996
# ============================================================
# Run this ONCE in RStudio (Source) or from terminal with Rscript.

pkgs <- c(
  "readr",      # CSV / delimited text (fast, tidy)
  "readxl",     # Excel (.xlsx, .xls)
  "writexl",    # write Excel sample files
  "haven",      # SPSS (.sav), Stata (.dta), SAS
  "foreign",    # older SPSS/Stata/SAS readers
  "DBI",        # database interface
  "RSQLite",    # SQLite (local DBMS for practice)
  "openxlsx"    # another Excel helper (optional)
)

options(repos = c(CRAN = "https://cloud.r-project.org"))

need <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(need) > 0) {
  message("Installing: ", paste(need, collapse = ", "))
  install.packages(need, dependencies = TRUE)
} else {
  message("All required packages are already installed.")
}

invisible(lapply(pkgs, library, character.only = TRUE))
message("Packages loaded successfully.")
