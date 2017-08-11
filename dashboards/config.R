# config.R ------------------------------------------------------------------

# data_filename <- "data/viewId_demo.rds"

# gaExtract.R ------------------------------------------------------------------
# lookup tables
## AU
lookup37404136 <- c(date = "date",
                  dimension8 = "hitArticlePublishDate",
                  dimension10 = "hitArticleTitle",
                  dimension7 = "hitArticleAuthor",
                  dimension19 = "sessionFirstArticlePublishDate",
                  dimension21 = "sessionFirstArticleTitle",
                  dimension18 = "sessionFirstArticleAuthor",
                  goal9Completions = "events",
                  goal9ConversionRate = "eventConversionRate",
                  sessions = "sessions",
                  transactions = "transactions",
                  transactionRevenue = "revenue",
                  uniquePageViews = "uniquePageviews")


# dashboards/index.Rmd ------------------------------------------------------------------
# library(scales)

# ## set report title
# report_title <- switch(paramViewId,
#                        "demo" = "Article Attribution Report - Example Website 1",
#                        "123456" = "Article Attribution Report - Example Website 2")

# ## set report favicon
# favicon_url <- switch(paramViewId,
#                       "demo" = "favicon_demo.png",
#                       "123456" = "favicon_2.png")

# # load GA account info
# # ga_account_info <- switch(paramViewId,
# #                           "demo" = readRDS("../../data/gaAccountInfo_demo.rds"),
# #                           "123456" = readRDS("../../data/gaAccountInfo_123456.rds"))

# # set custom dollar format for value box
# custom_dollar_format <- switch(paramViewId,
#                                "demo" = dollar_format(prefix = "$"),
#                                "123456" = dollar_format(prefix = "$"))

# # set custom dollar format for tables
# currencyFormat <- switch(paramViewId,
#                          "demo" = "$",
#                          "123456" = "$")

# # set logo url for inputs sidebar
# logo_url <- switch(paramViewId,
#                   "demo" = "logo_demo.png",
#                    "123456" = "logo_2.png")