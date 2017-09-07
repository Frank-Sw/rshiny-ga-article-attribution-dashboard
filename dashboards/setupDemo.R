# setup.R ------------------------------------------------------------------
## Load files to GCS
### 1. authenticate with GCS
#### load packages
library(googleAuthR)
library(googleCloudStorageR)

#### set options after loading packages 
#### since packages load scopes by default :-)
gcs_global_bucket("rshiny-ga-article-dash")
options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/cloud-platform"))

#### authenticate via OAuth 
gar_auth()

### 2. upload files
#### GA Account Info
gcs_upload(file = "dashboards/data/viewId_demo.rds", 
           name = "data/viewId_demo.rds")
#### GA Data for Dashboards
gcs_upload(file = "dashboards/data/gaAccountInfo_demo.rds", 
           name = "data/gaAccountInfo_demo.rds")

## launch VM 
### set parameters for ease of changing going forward 
gce_project_id <- "ep-prod"
container_name <- "github-empirical-path-rshiny-ga-article-attribution-dashboard"
gce_vm_name <- "rshiny-ga-art-attr-dev" # dev
# gce_vm_name <- "rshiny-ga-art-attr" # production
gce_vm_type <- "n1-standard-1"
gce_zone <- "us-east1-b"
app_directory <- "/dashboards/demo/"

### set environment variables since it's the easiest way!
Sys.setenv("GCE_AUTH_FILE" = "key.json")
Sys.setenv("GCE_DEFAULT_PROJECT_ID" = gce_project_id)
Sys.setenv("GCE_DEFAULT_ZONE" = gce_zone)
Sys.setenv("GCE_SSH_USER" = "justin")

### load package
library(googleComputeEngineR)

### get tag name of docker image built
### from build trigger
tag <- gce_tag_container(container_name = container_name, 
                         project = gce_project_id)
### print to sanity check
tag

### load functions to setup instance
source("dashboards/scripts/functionsDemo.R")

## Setup instance, open in browser
vm <- setup_vm(gce_vm_name = gce_vm_name,
               gce_vm_type = gce_vm_type,
               tag = tag,
               app_directory = app_directory,
               wait_seconds = 3)

### VM/Docker Cheatsheet
#### docker exec -it shinyserver bash
#### cd /srv/shiny-server/dashboards/; Rscript extractDemo.R
#### cd /var/log/shiny-server; tail -f *log

## DELETE INSTANCE 
job_delete <- gce_vm_delete(vm)
gce_wait(job_delete, wait = 20)
inst <- gce_get_instance(vm)
inst$status