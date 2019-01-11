library(jsonlite)
library(httr)

Auth <- function(customerId, apiKey) {
    credentials <- jsonlite::toJSON(list("customer_id" = customerId, "api_key" = apiKey), auto_unbox = TRUE)
    req <- httr::POST("https://api.applymagicsauce.com/auth",
                      httr::add_headers("Content-Type" = "application/json;charset=UTF-8"),
                      body = credentials)
    if (req$status == 200) {
        return (httr::content(req)$token)
    } else {
        error <- jsonlite::toJSON(httr::content(req), pretty = TRUE, auto_unbox = TRUE)
        stop(error)
    }
}

PredictFromText <- function(token, text) {
    req <- httr::POST("https://api.applymagicsauce.com/text",
                      httr::add_headers("Content-Type" = "text/plain;charset=UTF-8", "X-Auth-Token" = token),
                      body = text)
    if (req$status == 200) {
        return (httr::content(req))
    } else {
        error <- jsonlite::toJSON(httr::content(req), pretty = TRUE, auto_unbox = TRUE)
        stop(error)
    }
}

PredictFromLikeIds <- function(token, likeIds) {
    req <- httr::POST("https://api.applymagicsauce.com/like_ids",
                      httr::add_headers("Content-Type" = "application/json;charset=UTF-8", "X-Auth-Token" = token),
                      body = jsonlite::toJSON(likeIds, auto_unbox = TRUE))
    if (req$status == 200) {
        return (httr::content(req))
    } else {
        error <- jsonlite::toJSON(httr::content(req), pretty = TRUE, auto_unbox = TRUE)
        stop(error)
    }
}

PredictFromLikeNames <- function(token, likeNames) {
    req <- httr::POST("https://api.applymagicsauce.com/like_names",
                      httr::add_headers("Content-Type" = "application/json;charset=UTF-8", "X-Auth-Token" = token),
                      body = jsonlite::toJSON(likeNames, auto_unbox = TRUE))
    if (req$status == 200) {
        return (httr::content(req))
    } else {
        error <- jsonlite::toJSON(httr::content(req), pretty = TRUE, auto_unbox = TRUE)
        stop(error)
    }
}

# /auth
token <- Auth(1234, 'key')

# /text
predictionResult <- PredictFromText(token, "Lorem ipsum dolor sit amet")
print(jsonlite::toJSON(predictionResult, pretty = TRUE, auto_unbox = TRUE))

# /like ids
predictionResult <- PredictFromLikeIds(token, c("5845317146", "6460713406", "22404294985", "35312278675",
                                                "105930651606", "171605907303", "199592894970", "274598553922",
                                                "340368556015", "100270610030980"))
print(jsonlite::toJSON(predictionResult, pretty = TRUE, auto_unbox = TRUE))

# /like names
# Populate the array below with proper names (i.e. name of a celebrity, band, organisation, etc.), something well-known.
# Come up with 10 of these.
predictionResult <- PredictFromLikeNames(token, c("Name 1", "Name 2", "Name 3"))
print(jsonlite::toJSON(predictionResult, pretty = TRUE, auto_unbox = TRUE))
