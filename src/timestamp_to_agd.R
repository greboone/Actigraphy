#' Convert the timestamp to AGD pattern, that starts at 0001-01-01 00:00:00 not in 1970-01-01 00:00:00
timestamp_to_agd <- function(data){
  print("Inside timestamp_to_agd")
  data$dataTimestamp <- as.character(difftime(as.POSIXct(data$dataTimestamp, origin = "1970-01-01 00:00:00"),
                                          "0001-01-01 00:00:00", tz = "UTC", units = c("secs"))*1e7)
  data
}