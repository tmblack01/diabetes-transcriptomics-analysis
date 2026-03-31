## 01: Read Data
## Download dataset and metadata from the Gene Expression Omnibus (GEO) 
## repository

# --- Get data -----------------------------------------------------------------

# Query the GEO database to extract data with given GEO identifier
geo_idx <- 'GSE44313'
gse <- getGEO(geo_idx, GSEMatrix = TRUE, AnnotGPL = TRUE)
gse_data <- gse[[1]]

# Run this command to check that expression matrix is not empty
# show(gse)

# Extract expression matrix and metadata
expr_matrix <- exprs(gse_data)
metadata <- pData(gse_data)