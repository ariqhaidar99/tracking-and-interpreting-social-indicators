# ------------------------------------------------------------------------------
# Script: 02_Scottish_Welfare_Fund_Per_Capita_&_Density_Modelling
# ------------------------------------------------------------------------------

options(scipen = 999) # Prevent scientific notation

# 1. Load Datasets
wf <- read.csv("scottish welfare fund.csv", stringsAsFactors = TRUE)
density.data <- read.csv("land area and population density by administrative area mid-2025.csv", stringsAsFactors = TRUE)

# Clean column names in welfare fund data
colnames(wf)[colnames(wf) == "Value..GBP."] <- "Value (GBP)"
colnames(wf)[colnames(wf) == "Scottish.Welfare.Fund.Application.Type"] <- "Application Type"

# 2. Subset Council Level Data for Total Applications ("All")
wf.council <- subset(wf, wf$FeatureType == "Council Area" & 
                           wf$`Application Type` == "All")

# 3. Calculate Mean Expenditure Per Council Across Years
mean.expenditure <- aggregate(wf.council$`Value (GBP)` ~ wf.council$FeatureCode + wf.council$FeatureName, 
                              FUN = mean, 
                              na.rm = TRUE)

colnames(mean.expenditure) <- c("FeatureCode", "FeatureName", "Mean.Expenditure.GBP")

# 4. Clean Population Density Data (Ensure population is numeric by stripping commas if needed)
str(density.data)
density.data$Population.Density.Num <- as.numeric(gsub(",", "", density.data$Population.density..persons.per.square.kilometre.))
density.data$Population.Num <- as.numeric(gsub(",", "", density.data$Estimated.population.30.June.2025))


# 5. Merge Welfare Data with Population & Density Data
merged.data <- merge(mean.expenditure, density.data, by.x = "FeatureCode", by.y = "Area.code")
str(merged.data)

# 6. Calculate Per Capita Expenditure (Pounds per resident)
merged.data$Per.Capita.Expenditure <- merged.data$Mean.Expenditure.GBP / merged.data$Population.Num

# Sort to see top per-capita spending councils
merged.sorted <- merged.data[order(-merged.data$Per.Capita.Expenditure), ]
View(merged.sorted)

# 7. Next-Level Visualization: Per Capita Spending vs. Population Density
# 7.1. Ensure absolute numeric forcing right inside the variables
x_values <- as.numeric(merged.data$Per.Capita.Expenditure)
y_values <- as.numeric(merged.data$Population.Density.Num)

# 7.2. Configure plotting margins
par(mfrow=c(1,1), mar=c(5, 5, 4, 2))

# 7.3. Plot using direct X, Y coordinates (avoids the buggy formula interface)
plot(x = x_values, 
     y = y_values,
     pch = 19, 
     col = "darkblue", 
     cex = 1.3,
     main = "Welfare Fund Expenditure Per Capita vs. Population Density",
     xlab = "Mean Expenditure Per Capita (GBP)",
     ylab = "Population Density (persons / sq km)")

# 7.4. Add the trendline using the exact same NUMERIC columns
abline(lm(merged.data$Population.Density.Num ~ merged.data$Per.Capita.Expenditure), 
       col = "red", 
       lwd = 2)

# 8. Model summary
summary(lm(merged.data$Population.Density.Num ~ merged.data$Per.Capita.Expenditure))

# 9. Model correction and improvement
# 9.1. Correct causal direction
model_v2 <- lm(merged.data$Per.Capita.Expenditure ~ merged.data$Population.Density.Num)
summary(model_v2)
par(mfrow=c(2,2)) # Set up a 2x2 grid for diagnostic plots
plot(model_v2)
# Same Result :(
# 9.2. Log-transformed model
model_v3 <- lm(log10(merged.data$Per.Capita.Expenditure) ~ log10(merged.data$Population.Density.Num))
summary(model_v3)
plot(model_v3)
# 9.3. Applying square-root transformation 
model_v4 <- lm(sqrt(merged.data$Per.Capita.Expenditure) ~ sqrt(merged.data$Population.Density.Num))
summary(model_v4)
plot(model_v4)

# 10. Load the age and sex structure data
age.data <- read.csv("age and sex structure by administrative area mid-2025.csv", stringsAsFactors = FALSE)

# 11. Clean up the numeric columns (Removing commas from column 6: Persons Working Age)
# We use column indexing [, 6] to avoid dealing with messy spaces or newline characters in the header
age.data$Working.Age.Num <- as.numeric(gsub(",", "", age.data[, 6]))

# 12. Merge with our existing merged.data
# Note: Ensure you are using your active 'merged.data' that already contains Population & Expenditure
merged.data.v2 <- merge(merged.data, age.data, by.x = "FeatureCode", by.y = "Area.code")

# 13. Feature Engineering: Calculate the percentage of the population that is working age
merged.data.v2$Percent.Working.Age <- (merged.data.v2$Working.Age.Num / merged.data.v2$Population.Num) * 100

# 14. Multivariate Regression Model 
# We keep the log10 for density (since we know it works) and add the new demographic percentage
model_v5 <- lm(log10(Per.Capita.Expenditure) ~ log10(Population.Density.Num) + Percent.Working.Age, data = merged.data.v2)

# 15. Reveal the results
summary(model_v5)
plot(model_v5)
# model is a "dud", refer back to log10 transform model
