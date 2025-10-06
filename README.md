# AgNav Demo Econometric Analysis (simulated data)

Purpose: Demonstrate modelling with farm-level microdata to estimate production function, economic returns, and greenhouse gas relationships.

Data: simulated cross-sectional dataset with 1000 farms.

Models:
1) Production (log-linear): log_yield ~ log_farm_size + log_fertilizer + log_labour + livestock_units + C(region)
2) Income: income_local ~ log_yield + log_farm_size + C(region)
3) GHG (log): log_ghg ~ log_fertilizer + livestock_units + C(region)

Key outputs (estimates):
- Mean predicted % change in yield from a 10% reduction in fertilizer: -2.61%
- Mean predicted % change in GHG from a 10% reduction in fertilizer: -2.52%

Files included: simulated_farm_microdata.csv, analysis_prod_summary.txt, README.md