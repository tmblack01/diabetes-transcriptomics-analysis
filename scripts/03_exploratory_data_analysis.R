## Exploratory Data Analysis
## Explore dataset to gather initial insights, using statistics 
## and visualisations

# Identify top 5 genes in dataset with the most variance
top_genes <- expr_matrix_reduced %>% apply(1, sd) %>% 
  sort(decreasing = TRUE) %>% 
  head(5)

# Generate box plots of normalised counts against the most variable genes
combined_data %>% filter(gene %in% names(top_genes)) %>%
  ggplot(aes(gene, normalised_count, fill = gene)) +
    geom_boxplot() + theme_light() + guides(fill = "none") +
  scale_fill_viridis_d(begin = 0.4) +
  labs(y = "normalised count", 
      title = "Distribution of Normalised Count for Most Variable Genes")

combined_data %>% filter(gene %in% names(top_genes)) %>%
  ggplot(aes(gene, normalised_count, fill = diabetes_type)) +
  geom_boxplot() + theme_light() +
  labs(y = "normalised count", 
       title = "Distribution of Normalised Count for Most Variable Genes, Group by Diabetes Type", 
       fill = "diabetes type")