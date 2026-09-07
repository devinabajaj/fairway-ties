## Centrality and community detection on the LPGA similarity network

library(tidyverse)
library(igraph)

golf_graph <- readRDS("data/processed/golf_graph.rds")

# Centrality
# Degree: how many connections a player has
# Weighted degree (strength): how strong those connections are
V(golf_graph)$degree <- degree(golf_graph)
V(golf_graph)$strength <- strength(golf_graph, weights = E(golf_graph)$weight)

# Top 10 most centrally styled players
centrality_table <- tibble(
  Golfer = V(golf_graph)$name,
  degree = V(golf_graph)$degree,
  strength = V(golf_graph)$strength
) %>%
  arrange(desc(strength))
print(head(centrality_table, 10))

# Community Detection
communities <- cluster_louvain(golf_graph, weights = E(golf_graph)$weight)
communities
membership(communities)

V(golf_graph)$community <- membership(communities)
V(golf_graph)$community

# Number and size of each community
table(V(golf_graph)$community)

# Which players are in which community
community_table <- tibble(
  Golfer = V(golf_graph)$name,
  community = V(golf_graph)$community
) %>%
  arrange(community)
print(community_table, n = 30)


saveRDS(golf_graph, "data/processed/golf_graph.rds")
