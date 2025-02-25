# ======================
# 02_matching.R  =======
# ======================

# ---- Load Processed Data ----
merged_exports <- read_csv("data/processed/merged_exports.csv")

# ---- 5. Implement Coarsened Exact Matching ----

# Set matching parameters
match_vars <- c(
  "gdp_o_group", "gdpcap_o_group", "gdp_d_group", "gdpcap_d_group", 
  "contig", "comlang_off", "comcol") # Match variables
match_year <- 2011 # Matching year
gdp_groups <- 3 # Set nr of GDP gropups
gdpcap_groups <- 4 # Set nr of GDP/capita groups


# Generate income groups for CEM stratification
income <- merged_exports %>%
  filter(year == match_year) %>% # Base income group on data from match_year
  group_by(partner) %>% # Use data from partner countries
  summarise(
    gdp_d = first(gdp_d),
    gdpcap_d = first(gdpcap_d)
  )

income <- income %>% # Create income groups based on GDP and GDP/capita
  mutate(
    gdp_d_group = ntile(gdp_d, gdp_groups),
    gdpcap_d_group = ntile(gdpcap_d, gdpcap_groups)
  ) %>%
  mutate(
    reporter = partner,
    gdp_o_group = gdp_d_group,
    gdpcap_o_group = gdpcap_d_group
  )

# Merge income groups to merged_exports
merged_exports <- merged_exports %>%
  left_join(income %>% select(reporter, gdp_o_group, gdpcap_o_group), by = "reporter") %>%
  left_join(income %>% select(partner, gdp_d_group, gdpcap_d_group), by = "partner")


# Create CEM strata
merged_exports <- merged_exports %>%
  group_by(across(all_of(match_vars))) %>%
  mutate(cem_strata = cur_group_id()) %>%
  ungroup()

# Create matched exports data
matched_exports <- merged_exports %>%
  group_by(cem_strata) %>%
  filter(any(treated==1)) %>%
  ungroup() %>%
  select(year, reporter, partner, export, reporteriso, partneriso, treated)

# Save matched dataset
write_csv(matched_exports, "data/processed/matched_exports.csv")
