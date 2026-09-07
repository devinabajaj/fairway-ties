library(tidyverse)
library(igraph)
library(ggraph)

golf_graph <- readRDS("data/processed/golf_graph.rds")

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

# Comprehensive tibble
player_full <- tibble(
  Golfer = V(golf_graph)$name,
  Nation = V(golf_graph)$Nation,
  Region = V(golf_graph)$Region,
  driveDist = V(golf_graph)$driveDist,
  fairPct = V(golf_graph)$fairPct,
  greenReg = V(golf_graph)$greenReg,
  avePutts = V(golf_graph)$avePutts,
  sandPct = V(golf_graph)$sandPct,
  totPrize = V(golf_graph)$totPrize,
  strength = V(golf_graph)$strength,
  archetype = V(golf_graph)$archetype
)

# Archetype stat comparison
stat_long <- player_full %>%
  group_by(archetype) %>%
  summarise(driveDist = mean(driveDist), fairPct = mean(fairPct),
            greenReg = mean(greenReg), avePutts = mean(avePutts),
            sandPct = mean(sandPct)) %>%
  pivot_longer(-archetype, names_to = "stat", values_to = "value")

ggplot(stat_long, aes(x = archetype, y = value, fill = archetype)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~stat, scales = "free_y") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Average stat profile by archetype", x = NULL, y = NULL)

ggsave("output/figures/archetype_stats_comparison.png", width = 10, height = 7, dpi = 300)


# Geography
geo_archetype <- player_full %>% count(Region, archetype)

ggplot(geo_archetype, aes(x = Region, y = n, fill = archetype)) +
  geom_col(position = "fill") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Playing-style archetypes by region",
       subtitle = "Proportion of players in each archetype, by region of origin",
       x = NULL, y = "Proportion", fill = "Archetype")

ggsave("output/figures/geography_archetype.png", width = 10, height = 6, dpi = 300)


# Archetype and earnings

ggplot(player_full, aes(x = reorder(archetype, totPrize, median), y = totPrize, fill = archetype)) +
  geom_boxplot(show.legend = FALSE) +
  coord_flip() +
  scale_y_continuous(labels = scales::dollar) +
  theme_minimal() +
  labs(title = "2022 season earnings by archetype", x = NULL, y = "Total prize money")

ggsave("output/figures/earnings_by_archetype.png", width = 9, height = 6, dpi = 300)


# Ego network of the most central player

top_player <- player_full %>% arrange(desc(strength)) %>% slice(1) %>% pull(Golfer)
top_player  # confirm who it is in the console

ego_ids <- c(V(golf_graph)[top_player], neighbors(golf_graph, top_player))
ego_graph <- induced_subgraph(golf_graph, ego_ids)

ggraph(ego_graph, layout = "fr") +
  geom_edge_link(aes(width = weight), alpha = 0.5, color = "grey50") +
  geom_node_point(aes(color = archetype), size = 8) +
  geom_node_text(aes(label = name), repel = TRUE, size = 3.5) +
  scale_edge_width(range = c(0.5, 2)) +
  theme_void() +
  labs(title = paste(top_player, "and her closest statistical twins"), color = "Archetype") +
  theme(legend.position = "right")


# Regional clustering
assortativity_nominal(golf_graph, as.factor(V(golf_graph)$Region), directed = FALSE)

ggsave("output/figures/ego_network_top_player.png", width = 8, height = 6, dpi = 300)
