install.packages("ggraph")

library(tidyverse)
library(igraph)
library(ggraph)

golf_graph <- readRDS("data/processed/golf_graph.rds")

# Re-attach the archetype names to the graph object 
community_names <- tibble(
  community = c(1, 2, 3, 4, 5, 6, 7),
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

V(golf_graph)$archetype <- community_names$archetype[
  match(as.integer(V(golf_graph)$community), community_names$community)
]

set.seed(42)  # keeps the layout identical every time you re-run this

# All players
ggraph(golf_graph, layout = "fr") +
  geom_edge_link(alpha = 0.15, color = "grey") +
  geom_node_point(aes(color = archetype, size = strength)) +
  geom_node_text(aes(label = ifelse(strength > quantile(strength, 0.75), name, "")),
                 repel = TRUE, size = 2.8, max.overlaps = 20) +
  theme_void() +
  labs(title = "Fairway Ties: LPGA Player Similarity Network (2022)",
       subtitle = "Nodes = players, colored by playing-style archetype. Size = centrality.",
       color = "Archetype") +
  theme(legend.position = "right")

ggsave("output/figures/network_overview.png", width = 12, height = 9, dpi = 300)

# Each archetype
ggraph(golf_graph, layout = "fr") +
  geom_edge_link(alpha = 0.15, color = "grey") +
  geom_node_point(aes(color = archetype, size = strength)) +
  geom_node_text(aes(label = name), repel = TRUE, size = 2.3, max.overlaps = 25) +
  facet_nodes(~archetype) +
  theme_void() +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold", size = 12)) +
  labs(title = "Fairway Ties: LPGA Playing-Style Archetypes")

ggsave("output/figures/network_faceted.png", width = 16, height = 11, dpi = 300)