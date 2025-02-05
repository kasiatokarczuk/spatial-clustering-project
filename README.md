# Spatial Clustering of Point Data - Kraków Offenses

## Overview

This project focuses on applying density-based clustering algorithms to spatial data, with the goal of identifying clusters with increased intensity of offenses in Kraków. The two main clustering methods used are **DBSCAN** (Density-Based Spatial Clustering of Applications with Noise) and **HDBSCAN** (Hierarchical Density-Based Spatial Clustering of Applications with Noise). These algorithms were tested with different parameters, and the results were visualized on a map of Kraków, showing the areas with the highest density of offenses.

## Data

The project uses the following datasets:
- **Offense data**: A shapefile containing point data of recorded offenses in Kraków.
- **Neighborhood boundaries**: A shapefile containing the boundaries of neighborhoods (osiedla) in Kraków.


## Clustering Methods

### 1. DBSCAN (Density-Based Spatial Clustering of Applications with Noise)
DBSCAN groups points based on their proximity to one another. The algorithm identifies core points (those with enough neighboring points within a given radius) and connects them into clusters. Points that do not meet the criteria for core points are labeled as noise.

#### Parameters:
- **eps**: The radius within which neighbors are considered.
- **minPts**: The minimum number of points required to form a cluster.

#### Results:
- Increasing the `eps` value resulted in fewer, larger clusters.
- Lower `minPts` values led to more smaller clusters, including noise points.
- The following visualizations were produced with different parameter combinations:
  - `eps = 250, minPts = 5`
  - `eps = 500, minPts = 5`
  - `eps = 500, minPts = 10`
  - `eps = 750, minPts = 10`

### 2. HDBSCAN (Hierarchical Density-Based Spatial Clustering of Applications with Noise)
HDBSCAN is a hierarchical clustering method that identifies clusters based on varying densities. It automatically selects the optimal number of clusters, making it more flexible than DBSCAN, which requires manual parameter tuning.

#### Parameter:
- **minPts**: The minimum number of points required to form a cluster.

#### Results:
- Lower `minPts` values resulted in more, smaller clusters.
- Higher `minPts` values created fewer but more stable clusters.

Visualizations were produced for the following `minPts` values:
  - `minPts = 4`
  - `minPts = 10`
  - `minPts = 20`
  - `minPts = 30`


## Conclusions

Both clustering methods successfully identified the districts and neighborhoods with the highest intensity of offenses in Kraków. Key findings include:
- **Stare Miasto**, **Kazimierz**, and **Kleparz** are among the areas with the highest density of recorded offenses.
- **HDBSCAN** was more adaptable and better at identifying stable clusters in varying density zones.
- **DBSCAN** was effective when the parameters (`eps` and `minPts`) were fine-tuned for specific areas.
