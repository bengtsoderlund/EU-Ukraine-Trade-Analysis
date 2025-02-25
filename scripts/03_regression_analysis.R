# =================================
# 03_regression_analysis.R  =======
# =================================

# ---- Load Matched Data ----
matched_exports <- read_csv("data/processed/matched_exports.csv")

# ---- 6. Run dynamic DiD regression  ----

# Create independent variable
y <- matched_exports$export

# Create interaction variables for dynamic diff-in-diff
x <- matched_exports %>%
  select(year, treated)

for (n in 2000:2021) {
  column_name <- paste0("int_", n)
  x <- x %>%
    mutate(!!column_name := ifelse(year == n, 1, 0) * treated)
}

x <- x %>%
  select(-year, -treated, -int_2011) # Drop reference year

x <- data.matrix(x)

# Create exporter- and importer fixed effects
fes <- list(
  exp_year = interaction(matched_exports$reporter, matched_exports$year),
  imp_year = interaction(matched_exports$partner, matched_exports$year),
  pair = interaction(matched_exports$reporter, matched_exports$partner)
)


reg <- hdfeppml_int(y = y, x = x, fes = fes)

# Save regression results
saveRDS(reg, "results/regression_results.rds")