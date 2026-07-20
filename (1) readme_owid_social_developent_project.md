# Global Social Development & Child Mortality Analysis

This repository contains an R-based data engineering and predictive modelling pipeline that evaluates how critical socioeconomic factors shape global childhood survival. 

By programmatically merging and analysing multi-decade, country-level data from *Our World in Data* (OWID), this project investigates a fundamental question: **To what extent do extreme poverty, hunger, and lack of clean water collectively predict child mortality rates across different nations and eras?**

The pipeline weaves together four disparate human development indicators into a single cohesive narrative about global health:
1. **The Deadliest Catalyst (Extreme Poverty):** Extreme financial deprivation is the strongest individual predictor of child mortality ($r = 0.86$). For every 1 percentage point increase in a population's extreme poverty rate, child mortality rises by approximately **0.09 deaths per 100 live births**, holding all other factors constant.
2. **The Infrastructure Shield (Clean Water):** Access to safely managed drinking water acts as a critical protective barrier ($r = -0.80$). For every 1 percentage point increase in clean water infrastructure access, child mortality decreases by **0.03 deaths per 100 live births**.
3. **The Combined Toll:** Hunger/undernourishment compounds these issues ($r = 0.75$). When modeled simultaneously, a country's poverty, undernourishment, and water sanitation levels account for **78.4% of the global variance** in child mortality rates ($R^2 = 0.7838$).

---

## Data Pipeline & Methodology
The R script (`owid_social_development.R`) follows a structured data science workflow:
### 1. Programmatic Data Ingestion & Cleaning
* Fetches live `.csv` data files and accompanying `.json` metadata profiles directly from *Our World in Data*.
* Eliminates historical year anomalies (filtering out rows where `year < 0`).
* Normalises long, unwieldy, API-generated column headers into clean, intuitive feature labels (`mortality`, `poverty`, `undernourishment`, `water`).
### 2. Merging & Harmonization
* Performs an inner merge across all four data frames using a composite key: `by = c("country", "year", "code")`. 
* Truncates missing variables using listwise deletion (`na.omit`) to guarantee statistical rigor across all multi-variable iterations.
### 3. Exploratory Data Analysis (EDA) & Diagnostics
* Generates individual time-series distributions for each metric to capture global trends.
* Evaluates bivariate relationships with child mortality using Pearson correlation tests (`cor.test`) to confirm directional hypotheses.
* Executes a **Redundancy Check** between `poverty` and `undernourishment` to diagnose potential multicollinearity risks.
### 4. Multivariate Regression Modelling
The script builds and benchmarks three variations of a multivariate ordinary least squares (OLS) linear model to map structural dynamics:
* **Baseline Linear Model (`v1.final.model`):** Maps direct linear interactions.
  $$\text{Child Mortality} = \beta_0 + \beta_1(\text{Poverty}) + \beta_2(\text{Undernourishment}) - \beta_3(\text{Water})$$
* **Square-Root Transformation (`v2.final.model.sqrt`):** Stabilizes variance by mapping `sqrt(mortality)`.
* **Logarithmic Transformation (`v3.final.model.log`):** Optimizes for exponential/multiplicative decay trends using `log(mortality)`.

---
