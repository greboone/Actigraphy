timestamp_to_agd <- function(data){
  data$timestamp <- as.character(difftime(data$timestamp,
                                          "0001-01-01 00:00:00", tz = "UTC", units = c("secs"))*1e7)
  data
}