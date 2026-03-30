## Dimensionality Reduction
## Reduce the number of dimensions in the expression matrix using different
## techniques

# --- PCA ----------------------------------------------------------------------

# perform PCA on the (reduced) expresion matrix
expr_pca <- prcomp(t(expr_matrix_reduced))

pca_var <- tibble(pca_eigenvalues = expr_pca$sdev^2, 
                  num_comp = 1:length(pca_eigenvalues)) %>%
  mutate(var_explained = cumsum(pca_eigenvalues) / sum(pca_eigenvalues) * 100)

# Generate an elbow plot
pca_var %>%
ggplot(aes(num_comp, pca_eigenvalues)) +
  geom_point() + geom_line() + theme_light() +
  scale_x_continuous(n.breaks = 10) +
  labs(x = "principal component", y = "variance", 
       title = "PCA Elbow Plot")

# Generate a plot showing (cumulative) variance explained
pca_var %>%
  ggplot(aes(num_comp, var_explained)) +
  geom_point() + geom_line() + theme_light() +
  scale_x_continuous(n.breaks = 10) + scale_y_continuous(n.breaks = 8) +
  labs(x = "principal component", y = "variance", 
       title = "PCA Cumulative Variance Explained Plot")

# Generate a scatter plot for the first two principal components
expr_pca$x %>% as.data.frame() %>%
  rownames_to_column("sample") %>%
  left_join(metadata_preprocess, by="sample") %>%
  ggplot(aes(PC1, PC2, colour = diabetes_type)) + 
  geom_point() + theme_light() + 
  labs(title = "First Two Principal Components for Diabetes Gene Expression", 
       colour = "diabetes type")
