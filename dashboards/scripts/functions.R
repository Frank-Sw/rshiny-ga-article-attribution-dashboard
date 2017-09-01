# functions.R ------------------------------------------------------------------

#' Safe set names
#' 
#' Will error if there is a problem setting names, which is better than silently returning NA
#' 
#' @param data_frame Data.frame to change the names of
#' @param lookup_names A named vector of the names of old_name = new_name
#' @return A character vector of new names, or error if any NA's
set_names <- function(data_frame, lookup_names){
  old_names <- names(data_frame)
  new_names <- lookup_names[old_names]
  failed_names <- new_names[is.na(new_names)]
  
  if(any(is.na(failed_names))){
    str(new_names)
    str(old_names)
    stop("Failed to rename all columns, check lookup_names")
  }
  
  new_names
  
}


#' Get Google Analytics Account Info
#' 
#' Export GA account info for documentation purposes
#' 
#' @param gaViewIds list of ga profile ids as strings
#' @return dataframe saved as rds file, one for each GA view
get_account_info <- function(gaViewIds){
  
  lapply(gaViewIds, function(x){
    
    ga_account_list() %>%
      filter(viewId == x) %>%
      saveRDS(file = paste0("data/gaAccountInfo_",x,".rds"))
  })
  
}


#' Get Google Analytics Data for Dashboards
#' 
#' Extract and join session and hit level data from GA, save as 
#' rds files for dashboards
#' 
#' @param dates date range list of pairs, from and to dates
#' @param gaViewIds list of ga profile ids as strings
#' @param sessionMetrics
#' @param sessionDimensions
#' @param hitMetrics
#' @param hitDimensions
#' 
#' @return dataframe and save as rds file, one for each view
get_data <- function(dates,
                     gaViewIds,
                     sessionMetrics,
                     sessionDimensions,
                     hitMetrics,
                     hitDimensions){
  
  print("[-] starting to get data for dashboards...")
  
  data <- lapply(gaViewIds, function(x){
    
    # Get GA metadata for printing and timezone setting
    ga_account_info <- ga_account_list() %>%
      filter(viewId == x)
    
    ## save GA view metadata for ease of reference
    view <- ga_view(ga_account_info$accountId, 
                    webPropertyId = ga_account_info$webPropertyId, 
                    profileId = ga_account_info$viewId)
    
    # load lookup names from config.R
    lookups <- as.data.frame(get(paste0("lookup",x)), col.names = c("x"))
    # set dataframe column name for ease of reference in parameterizing
    # queries
    names(lookups) <- "displayName"
    
    print(paste0("[?] getting sesssion data from GA view: ", view$name , " | ", x))
    
    # create dataframes of session metrics and dimensions
    # for ease of reference in parametrized queries
    session_metrics <- lookups %>%
      tibble::rownames_to_column(var = "old_row_name") %>%
      dplyr::rename(gaName = old_row_name) %>%
      dplyr::filter(displayName %in% sessionMetrics) %>%
      print()
    
    session_dimensions <- lookups %>%
      tibble::rownames_to_column(var = "old_row_name") %>%
      dplyr::rename(gaName = old_row_name) %>%
      dplyr::filter(displayName %in% sessionDimensions) %>%
      print()
    
    sessions <- google_analytics_4(x, 
                                   date_range = date_range, 
                                   metrics = session_metrics[["gaName"]],
                                   dimensions = session_dimensions[["gaName"]],
                                   order = order_type("sessions",
                                                      sort_order = "DESCENDING"),
                                   max = -1,
                                   anti_sample = TRUE)
    
    
    # rename dataframe columns from lookup names in config.R
    colnames(sessions) <- set_names(sessions, lookup_names = get(paste0("lookup",x)))
    
    print(paste0("[?] getting hit data from GA view: ", view$name , " | ", x))
    
    # create dataframes of hit metrics and dimensions
    # for ease of reference in parametrized queries
    hit_metrics <- lookups %>%
      tibble::rownames_to_column(var = "old_row_name") %>%
      dplyr::rename(gaName = old_row_name) %>%
      dplyr::filter(displayName %in% hitMetrics) %>%
      print()
    
    hit_dimensions <- lookups %>%
      tibble::rownames_to_column(var = "old_row_name") %>%
      dplyr::rename(gaName = old_row_name) %>%
      dplyr::filter(displayName %in% hitDimensions) %>%
      print()
    
    hits <- google_analytics_4(x, 
                               date_range = date_range, 
                               metrics = hit_metrics[["gaName"]],
                               dimensions = hit_dimensions[["gaName"]],
                               order = order_type("uniquePageViews",
                                                  sort_order = "DESCENDING"),
                               max = -1,
                               anti_sample = TRUE)
    
    # rename dataframe columns from lookup names in config.R  
    colnames(hits) <- set_names(hits, lookup_names = get(paste0("lookup",x)))
    
    # join hit and dimension data into a single file
    ga_all <- inner_join(sessions, hits, by = c(date = "date", 
                                                sessionFirstArticlePublishDate = "hitArticlePublishDate",
                                                sessionFirstArticleTitle = "hitArticleTitle",
                                                sessionFirstArticleAuthor = "hitArticleAuthor"))
    
    ### format columns
    ### view timezone set in ga view
    print(view$timezone)
    ## date conversions
    ga_all$sessionFirstArticlePublishDate <- as.Date(ga_all$sessionFirstArticlePublishDate,
                                                     format="%Y %m %d",
                                                     tz=view$timezone)
    
    ## order columns and write out to rds object
    ga_all %>% select(date, 
                      sessionFirstArticlePublishDate, 
                      sessionFirstArticleTitle,
                      sessionFirstArticleAuthor,
                      uniquePageviews,
                      sessions,
                      events,
                      eventConversionRate,
                      transactions,
                      revenue) %>% 
      saveRDS(file = paste0("data/viewId_",x,".rds"))
    
  })
  
  print("[X] gathering of data for dashboards complete.")
  
}

