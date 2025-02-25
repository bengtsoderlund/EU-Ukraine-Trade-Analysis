# ===========================
# 04_visualization.R  =======
# ===========================

# ---- Load Regression Results ----
reg <- readRDS("results/regression_results.rds")

# ---- 7. Display results ----#

beta_vec <- as.vector(reg$coefficients)
se_vec   <- as.vector(reg$se)
years <- as.numeric(sub("int_", "", rownames(reg$coefficients)))


res_df <- data.frame(
  year = years,
  beta = beta_vec,
  lower = beta_vec - 1.96 * se_vec,
  upper = beta_vec + 1.96 * se_vec
)


ggplot(res_df, aes(x = year)) +
  geom_line(aes(y = beta), color = "blue", size = 0.9) +
  geom_line(aes(y = lower), color = "blue", linetype = "dashed") +
  geom_line(aes(y = upper), color = "blue", linetype = "dashed") +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 2012, color = "red") +
  geom_vline(xintercept = 2014, color =  "darkgrey", linetype = "dashed") +
  geom_vline(xintercept = 2016, color =  "darkgrey", linetype = "dashed") +
  annotate("text", x = 2011.8, y = 1.43, label = "Initialled", hjust = 1) +
  annotate("text", x = 2014, y = 1.43, label = "Signed", hjust = 0.5) +
  annotate("text", x = 2016.2, y = 1.43, label = "In force", hjust = 0) +
  scale_x_continuous(breaks = seq(2000, 2020, by = 2)) +
  labs(
    title = "Impact of Ukraine-EU FTA on Exports",
    x = "Year",
    y = "Coefficient Estimate"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))


# Save figure
ggsave("results/impact_fta_exports.png", width = 8, height = 5)