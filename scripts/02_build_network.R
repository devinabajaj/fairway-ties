## Building the LPGA player similarity network

library(tidyverse)
library(igraph)

lpga_clean <- read_csv("data/processed/lpga_clean.csv")

# Standardize our 5 statistics (Driving Distance, Fairway %, Greens in Regulation,
# Average Putts, and Sand %) so they're all on the same scale
stats_scaled <- lpga_clean %>%
  select(driveDist, fairPct, greenReg, avePutts, sandPct) %>%
  scale() %>%
  as.data.frame()
rownames(stats_scaled) <- lpga_clean$Golfer

# Distance between every pair of players in "playing style space"
dist_matrix <- as.matrix(dist(stats_scaled))

# Convert distance to a similarity score (closer players = higher similarity)
sim_matrix <- 1 / (1 + dist_matrix)

# For each player, keep only their top 5 most similar players
k <- 5
edge_list <- map_dfr(1:nrow(sim_matrix), function(i) {
  player <- rownames(sim_matrix)[i]
  sims <- sim_matrix[i, -i]
  top_k <- sort(sims, decreasing = TRUE)[1:k]
  tibble(from = player, to = names(top_k), weight = top_k)
})

# Remove dupes so each pair only shows up once
# (A->B and B->A can both show up since similarity is symmetric,
# but a top-5 cutoff isn't guaranteed to be mutual)
edge_list <- edge_list %>%
  mutate(pair_id = map2_chr(from, to, ~paste(sort(c(.x, .y)), collapse = "_"))) %>%
  distinct(pair_id, .keep_all = TRUE) %>%
  select(from, to, weight)

# Build the network object
golf_graph <- graph_from_data_frame(edge_list, directed = FALSE, vertices = lpga_clean)

# Verification
vcount(golf_graph)
ecount(golf_graph)

saveRDS(golf_graph, "data/processed/golf_graph.rds")
