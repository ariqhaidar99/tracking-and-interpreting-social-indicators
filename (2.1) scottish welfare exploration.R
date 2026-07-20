# ------------------------------------------------------------------------------
# Script: 01_Scottish_Welfare_Fund_Expenditure_Analysis
# ------------------------------------------------------------------------------

# 1. Setup and Options
options(scipen = 999) # Prevent scientific notation

# 2. Import Data & Clean Columns
# Ensure "scottish welfare fund.csv" is in your working directory
wf <- read.csv("scottish welfare fund.csv", stringsAsFactors = TRUE)
colnames(wf)[colnames(wf) == "Value..GBP."] <- "Value (GBP)"
colnames(wf)[colnames(wf) == "Scottish.Welfare.Fund.Application.Type"] <- "Application Type"

# 3. Explore Dataset Structure
View(wf)
str(wf)
summary(wf)

# 4. Pre-processing & Subsetting (Workshop 1 Brief Focus)
# The dataset contains both Council Areas and a national total row ("Scotland").
# We want to focus strictly on local authorities and total applications ("All").
wf.council <- subset(wf, wf$FeatureType == "Council Area" & 
                       wf$`Application Type` == "All")

# Verify the subset
View(wf.council)

# 5. Calculate Mean Expenditure Per Local Authority
# Using aggregate() as outlined in the workshop briefs
mean.expenditure <- aggregate(wf.council$`Value (GBP)` ~ wf.council$FeatureName, 
                              FUN = mean, 
                              na.rm = TRUE)

# Rename columns for clarity
colnames(mean.expenditure) <- c("Council Area", "Mean Expenditure (GBP)")

# View the results sorted or as-is
View(mean.expenditure)

# 6. Exploratory Data Visualization
# Set up plotting area
par(mfrow=c(1,1), mar=c(12, 6, 4, 2)) # Adjust bottom margin for long council names

# Create a barplot of mean expenditures by council area
barplot(mean.expenditure$`Mean Expenditure (GBP)`, 
        names.arg = mean.expenditure$`Council Area`, 
        las = 2,               # Rotate council names vertically for readability
        col = "steelblue", 
        main = "Mean Scottish Welfare Fund Expenditure by Council Area",
        ylab = "Mean Expenditure (GBP)",
        cex.names = 0.9)       # Scale down font size for fit
