# 1. Project Setup --------------------------------------------------------------
options(scipen = 9999)
# 1a. Importing Files -----------------------------------------------------------
library(jsonlite)
# Fetch the data
poverty <- read.csv("https://ourworldindata.org/grapher/share-of-population-in-extreme-poverty.csv?v=1&csvType=full&useColumnShortNames=true")
# Fetch the metadata
poverty_metadata <- fromJSON("https://ourworldindata.org/grapher/share-of-population-in-extreme-poverty.metadata.json?v=1&csvType=full&useColumnShortNames=true")
# Remove all rows where the 'year' is less than 0
poverty <- subset(poverty, year >= 0)
library(jsonlite)
# Fetch the data
cm <- read.csv("https://ourworldindata.org/grapher/child-mortality-igme.csv?v=1&csvType=full&useColumnShortNames=true")
# Fetch the metadata
cm_metadata <- fromJSON("https://ourworldindata.org/grapher/child-mortality-igme.metadata.json?v=1&csvType=full&useColumnShortNames=true")
# No "year" columns are less than zero here
library(jsonlite)
# Fetch the data
nourishment <- read.csv("https://ourworldindata.org/grapher/prevalence-of-undernourishment.csv?v=1&csvType=full&useColumnShortNames=true")
# Fetch the metadata
nourishment_metadata <- fromJSON("https://ourworldindata.org/grapher/prevalence-of-undernourishment.metadata.json?v=1&csvType=full&useColumnShortNames=true")
# No "year" columns are less than zero here
library(jsonlite)
# Fetch the data
cleanwater <- read.csv("https://ourworldindata.org/grapher/proportion-using-safely-managed-drinking-water.csv?v=1&csvType=full&useColumnShortNames=true")
# Fetch the metadata
cleanwater_metadata <- fromJSON("https://ourworldindata.org/grapher/proportion-using-safely-managed-drinking-water.metadata.json?v=1&csvType=full&useColumnShortNames=true")
# No "year" columns are less than zero here

# 1b. Rename columns to cleaner and less absurd names for all dataframes --------
names(cm)
colnames(cm)[colnames(cm) == "entity"] <- "country"
colnames(cm)[colnames(cm) == 
               "observation_value__indicator_child_mortality_rate__sex_total__wealth_quintile_total__unit_of_measure_deaths_per_100_live_births"] <- "mortality"
names(poverty)
colnames(poverty)[colnames(poverty) == "entity"] <- "country"
colnames(poverty)[colnames(poverty) == 
                    "headcount_ratio__ppp_version_2021__poverty_line_300__welfare_type_income_or_consumption__table_income_or_consumption_consolidated__survey_comparability_no_spells"] <- "poverty"
names(cleanwater)
colnames(cleanwater)[colnames(cleanwater) == "entity"] <- "country"
colnames(cleanwater)[colnames(cleanwater) == 
                  "wat_sm__residence_total"] <- "water"
names(nourishment)
colnames(nourishment)[colnames(nourishment) == "entity"] <- "country"
colnames(nourishment)[colnames(nourishment) == 
                        "X_2_1_1_prevalence_of_undernourishment__000000000024000__value__006121__percent"] <- "undernourishment"

# 1c. Merging and final cleaning of all 4 dataframes into one "super dataframe"
cm.ep <- merge(cm, poverty, by=c("country", "year", "code"))
cm.ep.nour <- merge(cm.ep, nourishment, by=c("country", "year", "code"))
v1.cm.ep.nour.water <- merge(cm.ep.nour, cleanwater, by=c("country", "year", "code"))
names(v1.cm.ep.nour.water)
v2.cm.ep.nour.water <- v1.cm.ep.nour.water[, c("country", "year", "code", "mortality", "poverty", "undernourishment", "water")]
sum(is.na(v2.cm.ep.nour.water))
colSums(is.na(v2.cm.ep.nour.water))
v3.cm.ep.nour.water <- na.omit(v2.cm.ep.nour.water)
sum(is.na(v3.cm.ep.nour.water))
colSums(is.na(v3.cm.ep.nour.water))
dim(v3.cm.ep.nour.water)
str(v3.cm.ep.nour.water)

# 3. Exploratory plotting
# 3a. individual variables
plot(v3.cm.ep.nour.water$year, v3.cm.ep.nour.water$mortality, col="green", pch=20,
     xlab="Year", ylab="Child Mortality Rate")
plot(v3.cm.ep.nour.water$year, v3.cm.ep.nour.water$poverty, col="blue", pch=20,
     xlab="Year", ylab="Share of Population Living in Extreme Poverty")
plot(v3.cm.ep.nour.water$year, v3.cm.ep.nour.water$undernourishment, col="pink", pch=20, 
     xlab="Year", ylab="Share of People who are Undernourished")
plot(v3.cm.ep.nour.water$year, v3.cm.ep.nour.water$water, col="yellow", pch=20, 
     xlab="Year", ylab="Share Using Safely Managed Drinking Water")

# 3b. mortality vs poverty, undernourishment, and clean water
# Setup for diagnostic visualization
par(mfrow=c(2,2)) # 2x2 grid

# Loop for Outcome Validation
for(var in explanatories) {
  # Visual
  plot(v3.cm.ep.nour.water[[var]], v3.cm.ep.nour.water$mortality, 
       main=paste("Mortality vs", var),
       xlab=var, ylab="Mortality", pch=20, col="darkblue")
  
  # Log these stats to your README/Analysis Report
  print(cor.test(v3.cm.ep.nour.water[[var]], v3.cm.ep.nour.water$mortality))
}

# Redundancy Check
plot(v3.cm.ep.nour.water$poverty, v3.cm.ep.nour.water$undernourishment, 
     main="Redundancy Check: Poverty vs Undernourishment",
     pch=20, col="darkred", xlab = "POverty", ylab="Undernourishment")

# 4. Exploratory statistics 
# A diagnostic function: One block of code, reusable for all variables.
get_stats <- function(metric_name) {
  cat("\n--- Diagnostics for:", metric_name, "---\n")
  # 4.1. Summary Statistics
  print(summary(v3.cm.ep.nour.water[[metric_name]], na.rm=TRUE))
  # 4.2. Dispersion Metrics (Crucial for showing outliers)
  cat("SD:", sd(v3.cm.ep.nour.water[[metric_name]], na.rm=TRUE), "\n")
  cat("IQR:", IQR(v3.cm.ep.nour.water[[metric_name]], na.rm=TRUE), "\n")
  # 4.3. Relationship to Mortality
  print(cor.test(v3.cm.ep.nour.water[[metric_name]], v3.cm.ep.nour.water$mortality))
}
# Call for each variable
get_stats("poverty")
# cor = 0.8584204, p-value < 0.00000000000000022, significant positive correlation.
get_stats("undernourishment")
# cor = 0.7459018, p-value < 0.00000000000000022, positive correlation.
get_stats("water")
# cor = -0.8013798 , p-value < 0.00000000000000022, negative correlation.

# 5. The Final Multivariate Model
# 5.1. Initial final model
v1.final.model <- lm(mortality ~ poverty + undernourishment + water, 
                  data = v3.cm.ep.nour.water)
par(mfrow=c(2,2))
plot(v1.final.model)
summary(v1.final.model)
# Poverty: For every 1 percentage point increase in poverty, child mortality 
# increases by ~0.09 deaths per 100 live births (holding other factors constant)
# Undernourishment: Also increases mortality, but the effect is smaller than poverty. 
# Water (-0.030): For every 1 percentage point increase in clean water access, mortality 
# decreases by ~0.03 deaths. The negative sign confirms the protective benefit of sanitation infrastructure.
# Adjusted R-squared:  0.7838 = Our model explains 75% of the variance in global 
# child mortality rates across the observed time periods.

# 5.2 Applying square-root transformation to v1
v2.final.model.sqrt <- lm(sqrt(mortality) ~ poverty + undernourishment + water, 
                         data = v3.cm.ep.nour.water)
plot(v2.final.model.sqrt)
summary(v2.final.model.sqrt)

# 5.3. Applying log transform to v1
v3.final.model.log <- lm(log(mortality) ~ poverty + undernourishment + water, 
                          data = v3.cm.ep.nour.water)
plot(v3.final.model.log)
summary(v3.final.model.log)

summary.lm(v1.final.model)
summary.lm(v2.final.model.sqrt)
summary.lm(v3.final.model.log)
