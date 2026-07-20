# ------------------------------------------------------------------------------
# Script: 03a_Longitudinal_Top5_COVID_Shock_Analysis.R
# ------------------------------------------------------------------------------

install.packages(c("ggplot2", "ggrepel"))
library(ggplot2)
library(ggrepel)

# 1. Prepare Data (Assuming 'wf' and 'density.data' are already loaded in your environment)
# Filter for Council Areas and "All" applications, but DO NOT aggregate by mean. Keep all years.
wf.council <- subset(wf, FeatureType == "Council Area" & `Application Type` == "All")

# 2. Merge with Density Data to secure Population figures
merged.ts <- merge(wf.council, density.data, by.x = "FeatureCode", by.y = "Area.code")

# 3. Calculate Per Capita Expenditure for EACH year
merged.ts$Per.Capita <- merged.ts$`Value (GBP)` / merged.ts$Population.Num

# 4. Feature Engineering: Extract the starting year from DateCode for the X-axis
# (Converts "2020/2021" into a clean numeric 2020)
merged.ts$Year <- as.numeric(substr(merged.ts$DateCode, 1, 4))

# 5. Identify the Top 5 Most Densely Populated Councils
council.densities <- unique(merged.ts[, c("FeatureName", "Population.Density.Num")])
council.densities <- council.densities[order(-council.densities$Population.Density.Num), ]
top_5_names <- head(council.densities$FeatureName, 5)

# 6. Filter the dataset to ONLY include these top 5 councils
plot_data <- subset(merged.ts, FeatureName %in% top_5_names)

# 7. Generate the "Hired-Level" Time-Series Visualization
ggplot(plot_data, aes(x = Year, y = Per.Capita, group = FeatureName, color = FeatureName)) +
  
  # Highlight the COVID-19 Shock region (Financial Years 2019/20 to 2021/22)
  annotate("rect", xmin = 2019.5, xmax = 2021.5, ymin = 0, ymax = Inf, 
           alpha = 0.15, fill = "red") +
  annotate("text", x = 2020.5, y = max(plot_data$Per.Capita) * 0.95, 
           label = "COVID-19 Shock", color = "darkred", fontface = "bold") +
  
  # Add the data points and trend lines
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  
  # Professional Formatting & Labels
  scale_x_continuous(breaks = min(plot_data$Year):max(plot_data$Year)) +
  labs(title = "Structural Shock: Pre vs. Post-COVID Welfare Expenditure",
       subtitle = "Tracking Per Capita Demand in Scotland's 5 Densest Councils (2013-2022)",
       x = "Financial Year (Starting Year)",
       y = "Per Capita Expenditure (GBP)",
       color = "Council Area") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 16))

# ------------------------------------------------------------------------------
# Script: 03b_Longitudinal_Global_COVID_Shock.R
# ------------------------------------------------------------------------------

# 1. Use the full merged dataset
plot_data_all <- merged.ts

# 2. Create a subset of data for ONLY the final year to attach the labels to
max_year <- max(plot_data_all$Year, na.rm = TRUE)
label_data <- subset(plot_data_all, Year == max_year)

# 3. Generate the Labeled Visualization
ggplot(plot_data_all, aes(x = Year, y = Per.Capita, group = FeatureName, color = FeatureName)) +
  
  # Highlight the COVID-19 Shock region
  annotate("rect", xmin = 2019.5, xmax = 2021.5, ymin = 0, ymax = Inf, 
           alpha = 0.15, fill = "red") +
  annotate("text", x = 2020.5, y = max(plot_data_all$Per.Capita, na.rm = TRUE) * 0.95, 
           label = "COVID-19 Shock", color = "darkred", fontface = "bold") +
  
  # Plot all 32 lines with slight transparency
  geom_line(linewidth = 1, alpha = 0.6) +
  geom_point(size = 1.5, alpha = 0.6) +
  
  # NEW: Add direct labels to the end of the lines using ggrepel
  geom_text_repel(data = label_data, 
                  aes(label = FeatureName), 
                  nudge_x = 0.7,      # Push labels horizontally to the right
                  direction = "y",    # Repel them vertically so they stack neatly
                  hjust = 0,          # Left-align the text
                  size = 3.5, 
                  segment.color = "grey70", # Color of the connecting lines
                  max.overlaps = Inf) +     # Force all labels to render
  
  # Expand the X-axis limits (max_year + 2.5) to create blank space for the labels
  scale_x_continuous(breaks = min(plot_data_all$Year, na.rm = TRUE):max_year,
                     limits = c(min(plot_data_all$Year, na.rm = TRUE), max_year + 2.5)) +
  
  labs(title = "Macroeconomic Shock: Pre vs. Post-COVID Welfare Expenditure",
       subtitle = "Tracking Per Capita Demand Across All 32 Scottish Councils (2013-2022)",
       x = "Financial Year (Starting Year)",
       y = "Per Capita Expenditure (GBP)") +
  
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none", # Legend stays gone
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", size = 16),
    # Added breathing room at the bottom and right
    plot.margin = margin(t = 10, r = 10, b = 40, l = 10, unit = "pt") 
  )
