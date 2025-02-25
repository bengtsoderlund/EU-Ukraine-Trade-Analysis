# ==============================
# 01_data_preparation.R  =======
# ==============================

# ---- 1. Load Required Libraries ----
library(dplyr)   # Data manipulation
library(readr)   # Reading CSV files
library(tidyr)   # Data cleaning
library(penppml) # High dimension fixed effects PPML estimation
library(ggplot2) # Plot results


# ---- 2. Load Raw Data ----

exports <- read_csv("data/raw/exports_2000_2021.csv")
gravity_controls <- read_csv("data/raw/gravity_controls.csv")


# ---- 3. Merge Datasets ----

merged_exports <- exports %>% 
  inner_join(gravity_controls, by = c("reporteriso", "partneriso", "year"))


# ---- 4. Generate Treatment Variable ----

# Generate treatment variable
eu_countries <- c("Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czechia", 
                  "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", 
                  "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", 
                  "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", 
                  "Slovenia", "Spain", "Sweden")

merged_exports <- merged_exports %>%
  mutate(treated = case_when(
    (reporter == "Ukraine" & partner %in% eu_countries) ~ 1,
    (partner == "Ukraine" & reporter %in% eu_countries) ~ 1,
    (reporter == "Ukraine" & partner == "United Kingdom" & year < 2020) ~ 1,
    (reporter == "United Kingdom" & partner == "Ukraine" & year < 2020) ~ 1,
    TRUE ~ 0
  ))


# Save cleaned dataset
write_csv(merged_exports, "data/processed/merged_exports.csv")


