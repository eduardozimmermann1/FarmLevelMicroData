# AgNav Demo Econometric Analysis in R
# Author: Eduardo Zimmermann (2025)
# Purpose: Demonstrate econometric modelling with farm-level microdata (simulated example)
# Required packages: none (base R)

set.seed(2025)
n <- 1000
region <- sample(c("North","South","East","West"), n, replace = TRUE, prob = c(0.25,0.35,0.2,0.2))
farm_size <- exp(rnorm(n, 3.0, 0.6))
fertilizer <- exp(rnorm(n, 4.0, 0.7))
labour_hours <- exp(rnorm(n, 5.0, 0.5))
livestock_units <- rpois(n, 5) + 1

# True parameters
beta0 <- 1.0; beta_size <- 0.35; beta_fert <- 0.25; beta_lab <- 0.20; beta_liv <- 0.01
region_effects <- c(North=0.05, South=-0.02, East=0.08, West=-0.03)
eps <- rnorm(n, 0, 0.12)

log_yield <- beta0 + beta_size*log(farm_size) + beta_fert*log(fertilizer) +
  beta_lab*log(labour_hours) + beta_liv*livestock_units + region_effects[region] + eps
crop_yield <- exp(log_yield)

# Income and GHG
income <- 200 * crop_yield + rnorm(n, 0, 2000) + 1000 * (farm_size/mean(farm_size))
ghg_base <- 0.8 * log(fertilizer) + 0.5 * livestock_units + rnorm(n)
ghg_emissions <- exp(0.2 + 0.3 * ghg_base)

df <- data.frame(farm_size, fertilizer, labour_hours, livestock_units, region, crop_yield, income, ghg_emissions)

# Econometric models
cat("\n--- Production model ---\n")
model_prod <- lm(log(crop_yield) ~ log(farm_size) + log(fertilizer) + log(labour_hours) + livestock_units + region, data=df)
print(summary(model_prod))

cat("\n--- Income model ---\n")
model_income <- lm(income ~ log(crop_yield) + log(farm_size) + region, data=df)
print(summary(model_income))

cat("\n--- GHG emissions model ---\n")
model_ghg <- lm(log(ghg_emissions) ~ log(fertilizer) + livestock_units + region, data=df)
print(summary(model_ghg))

# Counterfactual: 10% reduction in fertilizer
df_cf <- df
df_cf$fertilizer <- df$fertilizer * 0.9

pred_base <- exp(predict(model_prod, df))
pred_cf <- exp(predict(model_prod, df_cf))
mean_yield_change <- mean(pred_cf - pred_base) / mean(pred_base) * 100

pred_ghg_base <- exp(predict(model_ghg, df))
pred_ghg_cf <- exp(predict(model_ghg, df_cf))
mean_ghg_change <- mean(pred_ghg_cf - pred_ghg_base) / mean(pred_ghg_base) * 100

cat("\nPredicted % change in yield from 10% fertilizer reduction:", round(mean_yield_change, 2), "%\n")
cat("Predicted % change in GHG from 10% fertilizer reduction:", round(mean_ghg_change, 2), "%\n")

# Save CSV for reproducibility
write.csv(df, "simulated_farm_microdata.csv", row.names = FALSE)
