## Exploratory Data Analysis
## Explore dataset to gather initial insights, using statistics 
## and visualisations

# Identify top 5 genes in dataset with the most variance
top_genes <- expr_matrix_reduced %>% apply(1, sd) %>% 
  sort(decreasing = TRUE) %>% 
  head(5)

# --- Box plot -----------------------------------------------------------------

# Generate box plots of normalised counts against the most variable genes
p1 <- combined_data %>% filter(gene %in% names(top_genes)) %>%
  ggplot(aes(gene, normalised_count, fill = gene)) +
    geom_boxplot() + theme_light() + guides(fill = "none") +
  scale_fill_viridis_d(begin = 0.4) +
  labs(y = "normalised count", 
      title = "Distribution of Normalised Counts for Most Variable Genes")

ggsave("output/03_boxplot_counts_against_gene.png", plot = p1)

p2 <- combined_data %>% filter(gene %in% names(top_genes)) %>%
  ggplot(aes(gene, normalised_count, fill = diabetes_type)) +
  geom_boxplot() + theme_light() +
  labs(y = "normalised count", 
       title = "Distribution of Normalised Counts for Most Variable Genes, Group by Diabetes Type", 
       fill = "diabetes type")

ggsave("output/03_boxplot_counts_against_gene_groupby_type.png", plot = p2)

# --- Scatter plot -------------------------------------------------------------

# Generate scatter plot for normalised counts against age
p3 <- combined_data %>% filter(gene == names(top_genes)[1]) %>%
  ggplot(aes(age, normalised_count)) +
  geom_point() + geom_smooth(method = "lm") + theme_light() +
  labs(y = "normalised count", 
       title = "Normalised Counts against Age with Line of Best Fit")

ggsave("output/03_scatterplot_counts_against_age.png", plot = p3)

p4 <- combined_data %>% filter(gene == names(top_genes)[1]) %>%
  ggplot(aes(age, normalised_count, colour = diabetes_type)) +
  geom_point()+ geom_smooth(method = "lm") + theme_light() +
  labs(y = "normalised count", 
       title = "Normalised Counts against Age with Line of Best Fit", 
       colour = "diabetes type")

ggsave("output/03_scatterplot_counts_against_age_groupby_type.png", plot = p4)

# --- Heatmap ------------------------------------------------------------------

# Generate heatmap to visual gene expression of the top 5 most variable genes
p5 <- combined_data %>% filter(gene %in% names(top_genes)) %>%
  ggplot(aes(sample, gene, fill = normalised_count)) +
  geom_tile(colour="black", linewidth=0.3) + theme_light() +
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  labs(title = "Gene Expression Heatmap for Top 5 Most Variable Genes", 
       fill = "normalised count") + 
  scale_fill_gradient(low="white", high = "#0ABFBC")

ggsave("output/03_gene_expression_heatmap.png", plot = p5)
