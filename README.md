# Women in Golf: LPGA Player Similarity Network (2022)

A network analysis project exploring playing-style archetypes among LPGA players in 2022. Built by treating each player's stat profile as a point in a similarity space and connecting her to her 5 most statistically similar peers.

## Why this project
I have always been interested in the intersection of anthropology and analytics. Kinship diagrams in anthropology are an early example of social network analysis. In this case, instead of mapping who plays with whom, I mapped which players play most like which other players based on common golf stats like driving distance, fairway accuracy, greens in regulation, putting, and sand save percentage.

## Data
[LPGA 2022 Performance Statistics](https://www.kaggle.com/datasets/utkarshx27/lpga-performance-statistics-for-2022) via Kaggle (158 players, season-long rate stats for 2022). 

## Method
- Standardized 5 rate stats (mean 0, sd 1)
- Built a similarity network: each player connected to her top-5 most similar peers (k-nearest-neighbors)
- Ran Louvain community detection to identify 7 emergent playing-style archetypes
- Profiled each archetype's average stats to name them

## Archetypes found
| Archetype | Defining trait |
| all_rounders | Long off the tee, best greens in regulation |
| inconsistent_approach | Short hitters off the tee, worst greens in regulation |
| long_drives | Longest drives, least accurate off the tee |
| generalists | No standout traits, small group |
| high_accuracy | Short hitters but most accurate off the tee | 
| strong_short_game | Best putting and bunker play |
| weak_short_game | Good off the tee, weak putting and sand saving |


## Key visuals
- `output/figures/network_overview.png` — full similarity network
- `output/figures/network_faceted.png` — archetypes shown as separate panels
- `output/figures/archetype_stats_comparison.png` — stat averages by archetype
- `output/figures/geography_archetype.png` — archetype distribution by region
- `output/figures/earnings_by_archetype.png` — 2022 earnings by archetype
- `output/figures/ego_network_top_player.png` — closest statistical peers of the tour's most "central" player

## Tools
R, tidyverse, igraph, ggraph

## Project structure
```
fairway-ties/
├── data/raw/            # original Kaggle download
├── data/processed/      # cleaned data + saved network object
├── scripts/             # numbered analysis pipeline (01–06)
├── output/figures/      # exported visuals
```