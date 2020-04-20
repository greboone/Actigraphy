#' Insert date insert to the data missing values
insert_date_oya <- function(data){
  print("Inside insert_date")

  aux <- paste0(data$Year,"-",
                data$Month,"-",
                data$Day," ",
                data$Hour,":",
                data$Minute,":",
                data$Second)

  b = data.frame(timestamp = as.POSIXct(aux))
  class(b$timestamp) = "POSIXct"

  df <- structure(list(dataTimestamp = b$timestamp,
                       axis1 = data$Activity,
                       steps = data$Second), 
                  .Names = c("dataTimestamp","axis1","steps"), 
                  class = "data.frame", 
                  row.names = c(NA, nrow(b)))
  print(df)
  df
}

