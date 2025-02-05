library(sf)
library(ggplot2)
library(dbscan)
library(dplyr)

# Load data
points <- st_read("C:/Users/kasia/Studies/SEMESTR 5/Analiza danych przestrzennych/projekt/zestaw8_XYTableToPoi_Project.shp")
residential_areas <- st_read("C:/Users/kasia/Studies/SEMESTR 5/Analiza danych przestrzennych/projekt/osiedla.shp")

#------DBSCAN METHOD-----
dbscan_clustering <- function(data_points, data_areas, eps, minPts) {
  # Extract coordinates
  coords <- st_coordinates(data_points)
  
  # Perform DBSCAN clustering
  db <- dbscan(coords, eps = eps, minPts = minPts)
  data_points$cluster <- db$cluster
  
  # Visualization with transparency for noise points (cluster 0)
  ggplot() +
    geom_sf(data = data_areas, fill = "white", color = "black") +
    geom_sf(data = data_points, aes(color = as.factor(cluster), alpha = ifelse(cluster == 0, 0.3, 1))) +
    theme_minimal() +
    labs(color = "Cluster", alpha = "Transparency") +
    ggtitle(paste("DBSCAN Clustering Results (eps =", eps, ", minPts =", minPts, ")")) +
    scale_alpha_identity()  # Enable raw alpha values
}

# Example usage
dbscan_clustering(points, residential_areas, eps = 500, minPts = 10)



#------HDBSCAN METHOD-----
hdbscan_clustering <- function(data_points, data_areas, minPts) {
  # Extract coordinates
  coords <- st_coordinates(data_points)  
  
  # Perform HDBSCAN clustering
  db <- hdbscan(coords, minPts = minPts)  
  
  # Assign cluster results to data
  data_points$cluster <- db$cluster  
  
  # Visualization 
  ggplot() +
    geom_sf(data = data_areas, fill = "white", color = "black") +
    geom_sf(data = data_points, aes(color = as.factor(cluster), alpha = ifelse(cluster == 0, 0.4, 1))) +
    theme_minimal() +
    labs(color = "Cluster", alpha = "Transparency") +
    ggtitle(paste("HDBSCAN Clustering Results (minPts =", minPts, ")")) +
    scale_alpha_identity()  # Enable raw alpha values
}

# Example usage
hdbscan_clustering(points, residential_areas, minPts = 10)

# Estimating epsilon
#-----Method 1----
# Value for minPts (e.g., 10 for initial testing)
minPts <- 10

# Compute k-nearest neighbors distances
knn_distances <- kNNdist(coords, k = minPts)

# k-NN Distance Plot
plot(sort(knn_distances), 
     type = "l", 
     main = "k-NN Distance Plot",
     xlab = "Points (sorted)", 
     ylab = paste(minPts, "-NN Distance"),
     col = "blue", 
     lwd = 2)

# Adding a line for a potential epsilon
abline(h = 750, col = "red", lty = 2, lwd = 2)


#---Method 2----
find_elbow <- function(distances) {
  distances <- sort(distances)
  n <- length(distances)
  idx <- 1:n
  diffs <- distances[-1] - distances[-n]
  which.max(diffs)
}

# Find "elbow" point
eps_idx <- find_elbow(knn_distances)
eps_value <- sort(knn_distances)[eps_idx]
cat("Optimal epsilon:", eps_value, "\n")

# Visualization of residential areas
ggplot() +
  geom_sf(data = residential_areas, fill = "lightblue", color = "black") +
  theme_minimal() +
  ggtitle("Map of Residential Areas")



#---Interactive map for displaying residential areas---
library(sf)
library(leaflet)

# Coordinate system transformation
osiedla_wgs84 <- st_transform(osiedla, crs = 4326)

# Verify data correctness
print(st_crs(osiedla_wgs84))

osiedla_wgs84$NAZWA_JEDN <- iconv(osiedla_wgs84$NAZWA_JEDN, from = "latin1", to = "UTF-8")

leaflet(osiedla_wgs84) %>%
  addTiles() %>%
  addPolygons(
    color = "black",
    weight = 1,
    fillColor = ~colorNumeric("YlOrRd", GESTOSC_ZA)(GESTOSC_ZA),
    fillOpacity = 0.7,
    label = ~NAZWA_JEDN,
    highlightOptions = highlightOptions(
      weight = 3,
      color = "blue",
      bringToFront = TRUE
    )
  ) %>%
  addLegend(
    pal = colorNumeric("YlOrRd", domain = osiedla_wgs84$GESTOSC_ZA),
    values = ~GESTOSC_ZA,
    title = "Population Density",
    position = "bottomright"
  ) 
