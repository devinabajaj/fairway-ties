## LPGA 2022 Dataset
# Load and clean the LPGA 2022 dataset

library(tidyverse)

lpga_raw <- read_csv("data/raw/lpga2022.csv")

# Looking at the structure of the data
glimpse(lpga_raw)

# Checking for missing values
lpga_raw %>%
  select(Golfer, driveDist, fairPct, greenReg, avePutts, sandPct) %>%
  summarise(across(everything(), ~sum(is.na(.))))  # No missing values

# Keep only what we need for the network + context columns
lpga_clean <- lpga_raw %>%
  select(Golfer, Nation, Region, driveDist, fairPct, greenReg, avePutts, sandPct, totPrize, events)

write_csv(lpga_clean, "data/processed/lpga_clean.csv")

# Count number of players in dataset
nrow(lpga_clean)
