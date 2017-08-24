# config.R ------------------------------------------------------------------

# lookup tables
## GA View 12345678
lookup12345678 <- c(date = "date",
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

## GA View 1111111 
## use this as a template, copy/paste for each GA view
## then change indicies of custom dimensions 
lookup1111111 <- c(date = "date",
                  dimension00 = "hitArticlePublishDate",
                  dimension00 = "hitArticleTitle",
                  dimension00 = "hitArticleAuthor",
                  dimension00 = "sessionFirstArticlePublishDate",
                  dimension00 = "sessionFirstArticleTitle",
                  dimension18 = "sessionFirstArticleAuthor",
                  goal00Completions = "events",
                  goal00ConversionRate = "eventConversionRate",
                  sessions = "sessions",
                  transactions = "transactions",
                  transactionRevenue = "revenue",
                  uniquePageViews = "uniquePageviews")