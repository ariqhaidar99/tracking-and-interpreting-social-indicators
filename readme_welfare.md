# Scottish Welfare Fund: Spatial Econometrics and Longitudinal Analysis

## Overview
This repository contains a comprehensive data science analysis of the Scottish Welfare Fund (2013-2022). The objective of this project is to understand the socioeconomic and spatial drivers behind emergency crisis grants and to visualise the macroeconomic shock of the COVID-19 pandemic on local welfare dependencies.

## The Analytical Journey

### 1. Exploratory Data Analysis & Baselining
The analysis begins by cleaning the raw welfare fund dataset and subsetting it to focus exclusively on local Council Areas. By calculating the mean expenditure across all years, we established a baseline understanding of raw spending distributions across Scotland's local authorities.

### 2. Spatial Econometrics & Model Optimisation
Recognising that raw spending is heavily biased by population size, the data was merged with demographic datasets to calculate **Per Capita Expenditure**. 
*   **Hypothesis Testing:** We tested the hypothesis that urban density compounds the need for financial crisis relief, as seen below:
  ![Welfare fund expenditure per capita vs population density](welfare%20fund%20expenditure%20per%20capita%20vs%20population%20density.png)
*   **Transformations:** Through iterative econometric modelling, a log-log transformation (`log10`) provided the most robust fit, successfully proving that population density is a statistically significant driver of per-capita welfare spending.
*   **Multivariate Controls:** A secondary model incorporating demographic age structures (working-age percentages) was tested but ultimately discarded, proving that spatial density overrides age demographics in predicting welfare pressure.

### 3. Longitudinal Macroeconomic Shock Visualisation
To capture the missing variance from the spatial models, the analysis pivoted to a time-series approach to observe temporal shocks.
*   We extracted specific financial years from the data to map a continuous longitudinal trend.
*   Using `ggplot2`, we mapped the per-capita demand for Scotland's 5 densest councils.
   ![Structure Shock](structure%20shock.png)
* Followed by a macro-level "swarm" plot of all 32 councils
![Swarm Chart](swarm%20analysis.png)
* **Visual Storytelling:** The final visualisations utilise aesthetic transparency and `ggrepel` for direct line labelling, clearly highlighting the systemic structural shock of the 2020 COVID-19 pandemic.

## Repository Structure
*   `01_Scottish_Welfare_Fund_Expenditure_Analysis.R`: Initial data import, cleaning, and aggregate bar plot generation.
* `02_Scottish_Welfare_Fund_Per_Capita_&_Density_Modelling.R`: Data merging, normalisation, and linear/log/sqrt regression modelling.
*   `03_Longitudinal_COVID_Shock_Analysis.R`: Time-series feature engineering and advanced `ggplot2` panel visualizations.

## Requirements
To run these scripts, you will need base R along with the following packages installed:
*   `ggplot2` (For time-series visualisations)
*   `ggrepel` (For non-overlapping line labels in the global council plot)
