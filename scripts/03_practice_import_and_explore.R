# ============================================================
# Practice: import data from different sources + explore
# Based on: https://rpubs.com/Mapara_lee/1434996
# HW1 focus: Statistical packages + Database management systems
# ============================================================
# Run order:
#   1) 01_install_packages.R
#   2) 02_create_sample_sources.R
#   3) this file
# ============================================================

library(readr)
library(readxl)
library(haven)
library(DBI)
library(RSQLite)

root <- "C:/Users/kwizerah/Desktop/AUCA/R-programming/ASSIGNMENT 1"
data_dir <- file.path(root, "data")

cat("\n========== PACKAGE -> SOURCE MAP ==========\n")
cat("readr / read.table  -> text, CSV\n")
cat("readxl              -> Excel (.xlsx)\n")
cat("haven               -> SPSS (.sav), Stata (.dta), SAS\n")
cat("DBI + RSQLite       -> SQLite / SQL databases\n")
cat("===========================================\n\n")

# ------------------------------------------------------------
# A) TEXT FILE (base R — as in the lecturer notes)
# ------------------------------------------------------------
cat("--- A) Text file with read.table() ---\n")
data_class <- read.table(file.path(data_dir, "class_data.txt"), header = TRUE)
print(variable.names(data_class))
print(head(data_class))
print(tail(data_class))
print(data_class[10:20, ])
print(summary(data_class$WEIGHT))
cat("n =", length(data_class$WEIGHT), "\n")
print(summary(data_class))
print(str(data_class))

# Summary helpers from the notes
print(apply(data_class, 2, sd))
print(c(Mean = mean(data_class$HEIGHT), SD = sd(data_class$HEIGHT)))
print(c(Mean = mean(data_class$WEIGHT), SD = sd(data_class$WEIGHT)))

# BMI (Create another Variable section)
BMI <- round(data_class$WEIGHT / (data_class$HEIGHT / 100)^2, digits = 2)
new_data_class <- cbind(data_class, BMI)
print(head(new_data_class, 5))
print(summary(BMI))

# Simple plots (open a graphics device when run in RStudio)
plot(WEIGHT ~ HEIGHT, data = data_class, main = "WEIGHT vs HEIGHT")
abline(lm(WEIGHT ~ HEIGHT, data = data_class)$coefficients)
cat("Correlation HEIGHT-WEIGHT:",
    cor(data_class$HEIGHT, data_class$WEIGHT), "\n")

# ------------------------------------------------------------
# B) CSV with readr (modern text import)
# ------------------------------------------------------------
cat("\n--- B) CSV with readr::read_csv() ---\n")
students_csv <- read_csv(file.path(data_dir, "students.csv"), show_col_types = FALSE)
print(students_csv)
print(summary(students_csv))

# ------------------------------------------------------------
# C) EXCEL with readxl
# ------------------------------------------------------------
cat("\n--- C) Excel with readxl::read_excel() ---\n")
excel_path <- file.path(data_dir, "class_workbook.xlsx")
cat("Sheets:", paste(excel_sheets(excel_path), collapse = ", "), "\n")
excel_class <- read_excel(excel_path, sheet = "class_data")
excel_students <- read_excel(excel_path, sheet = "students")
print(head(excel_class))
print(summary(excel_students))

# ------------------------------------------------------------
# D) STATISTICAL PACKAGES with haven  *** HW1 ***
# ------------------------------------------------------------
cat("\n--- D) SPSS (.sav) with haven::read_sav() [HW1] ---\n")
students_spss <- read_sav(file.path(data_dir, "students.sav"))
print(students_spss)
print(str(students_spss))
print(summary(as.data.frame(students_spss)))

cat("\n--- D2) Stata (.dta) with haven::read_dta() [HW1] ---\n")
students_stata <- read_dta(file.path(data_dir, "students.dta"))
print(students_stata)
print(summary(as.data.frame(students_stata)))

# How haven helps: keeps labelled metadata from SPSS/Stata
cat("\nHaven keeps variable labels / types from statistical packages.\n")
cat("Example column class for gender after SPSS import:\n")
print(class(students_spss$gender))

# ------------------------------------------------------------
# E) DATABASE with DBI + RSQLite  *** HW1 ***
# ------------------------------------------------------------
cat("\n--- E) SQLite database with DBI + RSQLite [HW1] ---\n")
con <- dbConnect(SQLite(), file.path(data_dir, "class_db.sqlite"))
cat("Tables in DB:\n")
print(dbListTables(con))

db_class <- dbReadTable(con, "class_data")
db_students <- dbGetQuery(con, "SELECT * FROM students WHERE gender = 'F'")
cat("All class_data from DB:\n")
print(head(db_class))
cat("Female students via SQL:\n")
print(db_students)

# Aggregation in SQL (DBMS advantage)
sql_summary <- dbGetQuery(con, "
  SELECT gender,
         COUNT(*) AS n,
         ROUND(AVG(math_score), 2) AS mean_math,
         ROUND(AVG(it_score), 2) AS mean_it
  FROM students
  GROUP BY gender
")
cat("Grouped summary inside the database:\n")
print(sql_summary)
dbDisconnect(con)

# ------------------------------------------------------------
# F) Built-in R datasets (from the notes)
# ------------------------------------------------------------
cat("\n--- F) Built-in datasets ---\n")
data("airquality")
print(variable.names(airquality))
print(str(airquality))

data("iris")
print(head(iris))
print(by(iris$Petal.Length, iris$Species, mean))
boxplot(Sepal.Length ~ Species, data = iris,
        main = "Comparison of categorical vs quantitative")

# ------------------------------------------------------------
# G) Leadership data management (from the notes)
# ------------------------------------------------------------
cat("\n--- G) Leadership data (missing values, subset, sort) ---\n")
manager <- c(1, 2, 3, 4, 5)
country <- c("US", "US", "UK", "UK", "UK")
gender <- c("M", "F", "F", "M", "F")
age <- c(32, 45, 25, 39, 99)
q1 <- c(5, 3, 3, 3, 2)
q2 <- c(4, 5, 5, 3, 2)
q3 <- c(5, 2, 5, 4, 1)
q4 <- c(5, 5, 5, NA, 2)
q5 <- c(5, 5, 2, NA, 1)
leadership <- data.frame(manager, country, gender, age, q1, q2, q3, q4, q5)

leadership$age[leadership$age == 99] <- NA
leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age >= 35 & leadership$age <= 75] <- "Middle Aged"
leadership$agecat[leadership$age < 35] <- "Young"

print(leadership)
print(is.na(leadership[, 5:9]))
newdata <- na.omit(leadership)
print(newdata)
newdata2 <- leadership[order(leadership$age), ]
print(newdata2)
print(subset(leadership, age >= 35 | age < 24, select = c(q1, q2, q3, q4, q5)))

cat("\n========== PRACTICE COMPLETE ==========\n")
cat("You imported from: text, CSV, Excel, SPSS, Stata, SQLite, and built-in data.\n")
cat("Libraries used: readr, readxl, haven, DBI, RSQLite (+ base R).\n")
