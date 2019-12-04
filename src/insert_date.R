insert_date <- function(data){
  
  lines = tail(data$line,1)
  i=1
  day = 1
  b = data.frame(timestamp = data$time)
  class(b$timestamp) = "timestamp"
  
  while(i <= lines){
    
    tmp = data$dayofweek[i] 
    
    if(i>=lines-1){
      tmp1 = tmp
    }else{
      tmp1 = data$dayofweek[i+1]
    }
    
    date <- paste0("1980-01-0", day)
    aux <- paste(date, data$time[i])
    b$timestamp[i] <- as.POSIXct(aux, format = "%Y-%m-%d %H:%M:%S")
    
    if(tmp != tmp1){
      day = day+1
    }
    
    i = i+1
  }

  #print(as.factor(paste0("-",tail(data$line,1),"L")))
  
  df <- structure(list(line = data$line,
                  timestamp = b$timestamp,
                      axis1 = data$activity), 
                     .Names = c("line","timestamp","axis1"), 
                      class = "data.frame", 
                  row.names = c(NA, tail(data$line,1)))#as.factor(paste0(-1*tail(data$line,1),"L")))) #-22308L))
  #b
  df
}
