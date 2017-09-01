#!/usr/bin/Rscript
# extract.R ------------------------------------------------------------------
## load packages 
library(googleAnalyticsR)
library(dplyr)

## load lookup tables 
source("config.R")

## load user defined fuctions
source("scripts/functions.R")

## authenticate with GA 
googleAuthR::gar_auth() # OAuth () aka - your user credentials)

## set date range
date_range <- c(Sys.Date()-7, Sys.Date()-1)

## set ga view ids and names for extraction 
list_of_views_to_get <- c(
  # ,12345567 # ADD GA VIEW IDS HERE #
  # ,12345678
  # ,2345678
  # ,9123456
  # ,4567899
) 

## execute
tryCatch({
  ## print initial message
  message("[-] starting data extraction...")
  
  ## get GA account info for all reports
  get_account_info(gaViewIds = list_of_views_to_get)
  
  ## get data for dashboards
  get_data(dates = date_range,
           gaViewIds = list_of_views_to_get,
           sessionMetrics = c("sessions",
                              "events",
                              "eventConversionRate",
                              "transactions",
                              "revenue"),
           sessionDimensions = c("date",
                                 "sessionFirstArticlePublishDate",
                                 "sessionFirstArticleTitle",
                                 "sessionFirstArticleAuthor"),
           hitMetrics = c("uniquePageviews"),
           hitDimensions = c("date",
                             "hitArticlePublishDate",
                             "hitArticleTitle",
                             "hitArticleAuthor"))
  ## print success message
  message("Data extract for dashboard completed successfully!")
  
},
error=function(cond) {
  
  ## print error message in case of error
  message(paste("@you", 
                "Data extract failed!",
                "Here is the error message:", 
                "\n```\n",
                cond,
                "\n```", 
                sep = " "))
})
