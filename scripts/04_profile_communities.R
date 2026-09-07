## Profiling each community's average stats (for naming archetypes + blog outputs)

library(tidyverse)
library(igraph)

golf_graph <- readRDS("data/processed/golf_graph.rds")

# Player-level data (including community) into one clean table
player_data <- tibble(
  Golfer = V(golf_graph)$name,
  Nation = V(golf_graph)$Nation,
  Region = V(golf_graph)$Region,
  driveDist = V(golf_graph)$driveDist,
  fairPct = V(golf_graph)$fairPct,
  greenReg = V(golf_graph)$greenReg,
  avePutts = V(golf_graph)$avePutts,
  sandPct = V(golf_graph)$sandPct,
  community = V(golf_graph)$community
)

# Average stat profile per community
community_profiles <- player_data %>%
  group_by(community) %>%
  summarise(
    n_players = n(),
    avg_driveDist = round(mean(driveDist), 1),
    avg_fairPct = round(mean(fairPct), 1),
    avg_greenReg = round(mean(greenReg), 1),
    avg_avePutts = round(mean(avePutts), 2),
    avg_sandPct = round(mean(sandPct), 1)
  ) %>%
  arrange(desc(avg_driveDist))

print(community_profiles)

# Naming the communities based on table analysis
community_names <- tibble(
  community = c(1,2,3,4,5,6,7),
  archetype = c(
    "all_rounders",
    "inconsistent_approach",
    "long_drives",
    "generalists",
    "high_accuracy",
    "weak_short_game",
    "strong_short_game"
  )
)

# Attaching the names to both tables by matching on community number
community_profiles <- community_profiles %>%
  mutate(community = as.integer(community)) %>%
  left_join(community_names, by = "community") %>%
  relocate(archetype, .after = community)

player_data <- player_data %>%
  mutate(community = as.integer(community)) %>%
  left_join(community_names, by = "community") %>%
  relocate(archetype, .after = community)
    

print(community_profiles)

# Re-save with the archetype names included
write_csv(community_profiles, "output/community_profiles.csv")
write_csv(player_data, "output/player_communities.csv")


