insert_date <- function(data){
  obtain_timestamp <- function(data){
    data$timestamp <- as.character(difftime(data$timestamp,
                                            "0001-01-01 00:00:00", tz = "UTC", units = c("secs"))*1e7)
    data
  }
  
  lines = tail(data$line,1)
  i=1
  day = 1
  while(i <=lines){
    tmp = data$dayofweek[i] 
    tmp1 = data$dayofweek[i+1]
    date <- paste0("0001-01-0", day)
    data$time[i] <- sub("",date,data$time[i])
    
    if(tmp != tmp1){
      day = day+1
    }
  }
  data
}