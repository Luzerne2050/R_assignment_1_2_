# Assignment 1 — Data import practice

Practice from: https://rpubs.com/Mapara_lee/1434996

## Run order (RStudio)

1. Open `scripts/01_install_packages.R` → **Source**
2. Open `scripts/02_create_sample_sources.R` → **Source**
3. Open `scripts/03_practice_import_and_explore.R` → **Source**
4. Optional: Knit `HW1_data_import.Rmd` for an HTML report

## What each script does

| File | Purpose |
|------|---------|
| `01_install_packages.R` | Install/load `readr`, `readxl`, `haven`, `DBI`, `RSQLite`, … |
| `02_create_sample_sources.R` | Build CSV, Excel, SPSS, Stata, SQLite samples in `data/` |
| `03_practice_import_and_explore.R` | Import each source + explore (includes HW1) |
| `HW1_data_import.Rmd` | Short write-up you can knit and submit |

## Package → data source

- Text / CSV → `read.table` / `readr`
- Excel → `readxl`
- SPSS / Stata → `haven` (**HW1**)
- SQLite database → `DBI` + `RSQLite` (**HW1**)
