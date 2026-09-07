install.packages("ggraph")

library(tidyverse)
library(igraph)
library(ggraph)

golf_graph <- readRDS("data/processed/golf_graph.rds")