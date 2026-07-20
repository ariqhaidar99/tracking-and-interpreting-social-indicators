# Scottish Welfare Fund: Spatial Econometrics and Longitudinal Analysis

## Overview
This repository contains a comprehensive data science analysis of the Scottish Welfare Fund (2013-2022). The objective of this project is to understand the socioeconomic and spatial drivers behind emergency crisis grants and to visualize the macroeconomic shock of the COVID-19 pandemic on local welfare dependencies.

## The Analytical Journey

### 1. Exploratory Data Analysis & Baselining
The analysis begins by cleaning the raw welfare fund dataset and subsetting it to focus exclusively on local Council Areas[cite: 3]. By calculating the mean expenditure across all years, we established a baseline understanding of raw spending distributions across Scotland's local authorities[cite: 3].

### 2. Spatial Econometrics & Model Optimization
Recognizing that raw spending is heavily biased by population size, the data was merged with demographic datasets to calculate **Per Capita Expenditure**[cite: 1]. 
*   **Hypothesis Testing:** We tested the hypothesis that urban density compounds financial crisis need[cite: 1].
*   **Transformations:** Through iterative econometric modeling, a log-log transformation (`log10`) provided the most robust fit, successfully proving that population density is a statistically significant driver of per-capita welfare spending[cite: 1].
*   **Multivariate Controls:** A secondary model incorporating demographic age structures (working-age percentages) was tested but ultimately discarded, proving that spatial density overrides age demographics in predicting welfare pressure[cite: 1].

### 3. Longitudinal Macroeconomic Shock Visualization
To capture the missing variance from the spatial models, the analysis pivoted to a time-series approach to observe temporal shocks[cite: 2].
*   We extracted specific financial years from the data to map a continuous longitudinal trend[cite: 2].
*   Using `ggplot2`, we mapped the per-capita demand for Scotland's 5 densest councils, followed by a macro-level "swarm" plot of all 32 councils[cite: 2].
*   **Visual Storytelling:** The final visualizations utilize aesthetic transparency and `ggrepel` for direct line labeling, clearly highlighting the systemic structural shock of the 2020 COVID-19 pandemic[cite: 2].

## Repository Structure
*   `01_Scottish_Welfare_Fund_Expenditure_Analysis.R`: Initial data import, cleaning, and aggregate bar plot generation[cite: 3].
*   `02_Scottish_Welfare_Fund_Per_Capita_&_Density_Modelling.R`: Data merging, normalization, and linear/log/sqrt regression modeling[cite: 1].
*   `03_Longitudinal_COVID_Shock_Analysis.R`: Time-series feature engineering and advanced `ggplot2` panel visualizations[cite: 2].

## Requirements
To run these scripts, you will need base R along with the following packages installed:
*   `ggplot2` (For time-series visualizations)[cite: 2]
*   `ggrepel` (For non-overlapping line labels in the global council plot)[cite: 2]