# EU-Ukraine Trade Analysis

## Overview

This project evaluates the impact of the EU-Ukraine Deep and Comprehensive Free Trade Agreement (DCFTA) on trade flows using a dynamic gravity difference-in-difference regression model. The analysis constitutes the basis of a report prepared by the National Board of Trade Sweden. I researched and wrote the report, and this repository contains all scripts required to reproduce the main analysis.

**Full Report:** [Read the Report (PDF)](docs/eu_ukraine_dcfta.pdf)

## Methodology

-   **Data Sources**: The dataset consists of bilateral trade data (exports) obtained from UNCOMTRADE and gravity variables (e.g., GDP, distance, language, colonial ties) obtained from CEPII.
-   **Regression Model**: Implements a **Dynamic Difference-in-Difference Gravity Regression** using a **Poisson Pseudo-Maximum Likelihood (PPML)** estimator.
-   **Treatment Group**: All exporter-importer pairs that can be formed between **Ukraine and EU members**.
-   **Matching**: The treatment group is matched to a control group of similar exporter-importer pairs using **Coarsened Exact Matching (CEM)**.
-   **Visualization**: Plots **coefficient estimates over time** to illustrate the impact of the trade agreement as its implementation progresses.

## Setup

Clone the repository and open the `.Rproj` file in RStudio.

Install required R packages:

``` r
install.packages(c("dplyr", "readr", "tidyr", "penppml", "ggplot2"))
```
