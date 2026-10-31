# ============================================================
# Create sample datasets in several formats for import practice
# Run AFTER 01_install_packages.R
# ============================================================

library(readr)
library(writexl)
library(haven)
library(DBI)
library(RSQLite)

# Set this to your Assignment 1 folder
root <- "C:/Users/kwizerah/Desktop/AUCA/R-programming/ASSIGNMENT 1"
data_dir <- file.path(root, "data")
dir.create(data_dir, showWarnings = FALSE, recursive = TRUE)

# --- Base class data (from lecturer notes) ---
class_data <- read.table(file.path(data_dir, "class_data.txt"), header = TRUE)
stopifnot(all(c("HEIGHT", "WEIGHT") %in% names(class_data)))

# Extra demo table (students) — mixed types like a real spreadsheet
students <- data.frame(
  studentID   = 1:8,
  gender      = c("M", "F", "M", "M", "F", "F", "M", "F"),
  math_score  = c(12, 17, 10, 9, NA, 15, 14, 11),
  it_score    = c(13, 18, 11, 10, 19, 16, 12, 14),
  height_cm   = c(161, 155, 158, 170, 160, 156, 162, 158),
  weight_kg   = c(50, 49, 42, 65, 60, 52, 58, 46),
  stringsAsFactors = FALSE
)

# 1) CSV (text file)
write_csv(students, file.path(data_dir, "students.csv"))
write.csv(class_data, file.path(data_dir, "class_data.csv"), row.names = FALSE)

# 2) Excel
write_xlsx(
  list(class_data = class_data, students = students),
  path = file.path(data_dir, "class_workbook.xlsx")
)

# 3) Statistical packages — SPSS & Stata (HW1)
write_sav(students, file.path(data_dir, "students.sav"))   # SPSS
write_dta(students, file.path(data_dir, "students.dta"))   # Stata

# 4) Database — SQLite (local DBMS for HW1 practice)
db_path <- file.path(data_dir, "class_db.sqlite")
if (file.exists(db_path)) file.remove(db_path)
con <- dbConnect(SQLite(), db_path)
dbWriteTable(con, "class_data", class_data, overwrite = TRUE)
dbWriteTable(con, "students", students, overwrite = TRUE)
dbDisconnect(con)

message("Sample sources created in: ", data_dir)
message("  - class_data.txt / class_data.csv")
message("  - students.csv")
message("  - class_workbook.xlsx  (Excel)")
message("  - students.sav         (SPSS)")
message("  - students.dta         (Stata)")
message("  - class_db.sqlite      (SQLite database)")
