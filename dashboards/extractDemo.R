## load packages 
library(googleAuthR)
library(googleCloudStorageR)

## set options
gcs_global_bucket("rshiny-ga-article-dash")
options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/cloud-platform"))

## auth on the VM
gar_gce_auth()

### get files from GCS
file <- "data/viewId_demo.rds"

gcs_get_object(object_name = file,
               saveToDisk = file,
               overwrite = TRUE)

file2 <- "data/gaAccountInfo_demo.rds"

gcs_get_object(object_name = file2,
               saveToDisk = file2,
               overwrite = TRUE)