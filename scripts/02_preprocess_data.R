## Preprocess Data
## Clean and transform expression matrix and metadata for downstream analysis

# --- Preprocess metadata ------------------------------------------------------

## ---- preprocess-meta
# Select columns from metadata that will be used for further analysis
metadata_preprocess <- as.data.frame(metadata) %>%
  rownames_to_column("sample") %>%
  rename(age = `age:ch1`, diabetes_type = `diabetes type:ch1`, 
         gender = `gender:ch1`) %>%
  mutate(age = as.integer(gsub("yrs", "", age))) %>%
  select(sample, age, diabetes_type, gender)

# --- Preprocess expression matrix ---------------------------------------------

# Show data processing information
metadata$data_processing[1]

## ---- summary-expression
summary(expr_matrix)

## ---- remove-low-expression
mask <- rowSums(expr_matrix, na.rm = TRUE) > 0.5
expr_matrix_reduced <- expr_matrix[mask,]

## ---- check-na
table(rowSums(is.na(expr_matrix)))

## ---- drop-na
expr_matrix_reduced <- as.data.frame(expr_matrix_reduced) %>% drop_na()
dim(expr_matrix_reduced)

## ---- pivot-longer
# Pivot expression matrix to longer form
expr_matrix_long <- as.data.frame(expr_matrix_reduced) %>%
  rownames_to_column("gene") %>%
  pivot_longer(cols = -gene,
               names_to = "sample",
               values_to = "normalised_count")

## ---- combine-expression-meta
# Combine expression matrix (in long format) with metadata
combined_data <- expr_matrix_long %>%
  left_join(metadata_preprocess, by="sample")
