# functionsDemo.R ------------------------------------------------------------------
## load packages 
library(googleAuthR)
library(googleCloudStorageR)

## set options
gcs_global_bucket("rshiny-ga-article-dash")
options(
  googleAuthR.scopes.selected = c(
    "https://www.googleapis.com/auth/cloud-platform"
    )
  )

## functions 
#' Setup VM
#' A helper function that sets up a GCE VM, waits for a period of time you set
#' then opens the shiny app in your browser
#' @param gce_vm_name STRING 
#' @param gce_vm_type STRING 
#' @param tag STRING 
#' @param app_directory STRING 
#' @param wait_second INTEGER of seconds to wait before opening the app's url
#' @return a dataframe "vm" wtih GCE instance info
setup_vm <- function(gce_vm_name,
                     gce_vm_type,
                     tag,
                     app_directory, 
                     wait_seconds){
  
  message(sprintf("[-] hello world!, it's %s EDT", Sys.time()))
  message(sprintf("[?] started building VM - %s", Sys.time()))
  vm <- gce_vm(name = gce_vm_name,
               template = "shiny",
               predefined_type = gce_vm_type,
               dynamic_image = tag)
  gce_vm_status <- gce_get_instance(vm)
  
  message(sprintf("[?] waiting %s seconds...", wait_seconds))
  Sys.sleep(wait_seconds)
  
  message(sprintf("[?] ..and now opening your browser to:"))
  app_url <- sprintf("http://%s%s", gce_get_external_ip(vm), app_directory)
  message(sprintf("[?] %s", app_url))
  browseURL(app_url)
  
  message(sprintf("[?] gcloud command to ssh into %s:", gce_vm_name))
  cmd <- paste0("gcloud compute --project \"",
                gce_project_id,
                "\" ssh --zone \"",
                gce_zone,
                "\" \"",
                gce_vm_name,
                "\"")
  message(sprintf("[?] %s", cat(cmd)))
  
  return(vm)
}


#' Choose GA Authentication
#' 
#' create function so one can seamlessly auth with
#' GA or on the VM without fear of auth errors :-)
#' @return authentication method for GA
choose_ga_auth <- function() {

  message("[-] checking if in the cloud...")

  if(is.null(gar_gce_auth())) {

    message("[?] NO, not in the cloud on a GCE VM.")
    
    message(sprintf("[?] authenticating with user creds"))    
    gar_auth()

  } else {    

    message("[?] YES, in the cloud on a GCE VM!")
    
    message("[?] using VM's default creds for authentication...")
    gar_gce_auth()

  }
}


#' Get GCS data
#' 
#' @param paramViewId
#' 
#' @return 
fetch_data <- function(paramViewId){

  message("[-] starting data fetch...")
  message("[-] choosing authentication method...")

  ## auth
  choose_ga_auth()
  
  ## set file directories for ease of switching 
  sourceDirectory <- "data/"
  destDirectory <- ""
  
  # file2 <- paste0("../data/gaAccountInfo_", paramViewId, ".rds")

  ### Get main data set 
  # sourceData <- paste0("data/viewId_", paramViewId, ".rds")
  # destData <- paste0("dashboards/data/viewId_", paramViewId, ".rds")
  sourceData <- paste0("data/viewId_", paramViewId, ".rds")
  destData <- paste0("viewId_", paramViewId, ".rds")
  
  if(!file.exists(destData)) {

        message(sprintf("[!] '%s' does NOT exist!", sourceData))
        message("[?] downloading...")
        gcs_get_object(object_name = sourceData,
                 saveToDisk = destData,
                 overwrite = TRUE)
  } else {
    message(sprintf("[x] '%s' already exists :)", sourceData))
  }
  
  ### get ga account info
  ### 
  sourceInfo <- paste0("data/gaAccountInfo_", paramViewId, ".rds")
  destInfo <- paste0("gaAccountInfo_", paramViewId, ".rds")
  
  if(!file.exists(destInfo)) {

    message(sprintf("[!] '%s' does NOT exist!", destInfo))
    message("[?] downloading...")
        gcs_get_object(object_name = sourceInfo,
                 saveToDisk = destInfo,
                 overwrite = TRUE)
  } else {

    message(sprintf("[x] '%s' already exists :)", sourceInfo))
  }
}
