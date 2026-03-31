## Dimensionality Reduction
## Reduce the number of dimensions in the expression matrix using different
## techniques

# --- PCA ----------------------------------------------------------------------

# perform PCA on the (reduced) expresion matrix
expr_pca <- prcomp(t(expr_matrix_reduced))

pca_var <- tibble(pca_eigenvalues = expr_pca$sdev^2, 
                  num_comp = 1:length(pca_eigenvalues)) %>%
  mutate(var_explained = cumsum(pca_eigenvalues) / sum(pca_eigenvalues) * 100)

# Generate an scree plot
p6 <- pca_var %>%
ggplot(aes(num_comp, pca_eigenvalues)) +
  geom_point() + geom_line() + theme_light() +
  scale_x_continuous(n.breaks = 10) +
  labs(x = "principal component", y = "variance", 
       title = "PCA Scree Plot")

ggsave("output/04_pca_scree_plot.png", plot = p6)

# Generate a plot showing (cumulative) variance explained
p7 <- pca_var %>%
  ggplot(aes(num_comp, var_explained)) +
  geom_point() + geom_line() + theme_light() +
  scale_x_continuous(n.breaks = 10) + scale_y_continuous(n.breaks = 8) +
  labs(x = "principal component", y = "variance", 
       title = "PCA Cumulative Variance Explained Plot")

ggsave("output/04_pca_variance_explained_plot.png", plot = p7)

# Generate a scatter plot for the first two principal components
p8 <- expr_pca$x %>% as.data.frame() %>%
  rownames_to_column("sample") %>%
  left_join(metadata_preprocess, by="sample") %>%
  ggplot(aes(PC1, PC2, colour = diabetes_type)) + 
  geom_point(size = 2) + theme_light() + 
  labs(title = "First Two Principal Components for Diabetes Gene Expression", 
       colour = "diabetes type")

ggsave("output/04_pca_scatter_plot.png", plot = p8)

# --- t-SNE --------------------------------------------------------------------

# Set seed for reproducibility
set.seed(1000)

# Apply t-SNE to the gene expression matrix, set to 2 dimensions
expr_tsne <- Rtsne(t(expr_matrix_reduced), dim = 2, perplexity = 3)
tsne_comp <- expr_tsne$Y
colnames(tsne_comp) <- c("X1", "X2")
rownames(tsne_comp) <- colnames(expr_matrix_reduced)

# Plot t-SNE components
p9 <- tsne_comp %>% as.data.frame() %>% 
  rownames_to_column("sample") %>% 
  left_join(metadata_preprocess, by="sample") %>% 
  ggplot(aes(x = X1, y = X2, colour = diabetes_type)) + 
  geom_point(size = 2) + 
  theme_minimal() + 
  labs(title = "t-SNE Plot for Diabetes Gene Expression")

ggsave("output/04_tsne_scatter_plot.png", plot = p9)
