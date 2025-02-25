# ===========================================
# ====  Master Script: Run All Scripts  =====
# ===========================================

source("scripts/01_data_preparation.R")
source("scripts/02_matching.R")
source("scripts/03_regression_analysis.R")
source("scripts/04_visualization.R")

cat("\nAll scripts executed successfully!\n")