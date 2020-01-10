insert_date <- function(data){
  print("Inside insert_date")
  lines = tail(data$line,1)
  i=1
  day = 1
  b = data.frame(timestamp = data$time)
  class(b$timestamp) = "POSIXct"
  
  while(i <= lines){
    tmp = data$dayofweek[i] 
    
    if(i>=lines-1){
      tmp1 = tmp
    }else{
      tmp1 = data$dayofweek[i+1]
    }
    
    date <- paste0("2000-01-0", day)
    aux <- paste(date, data$time[i])
    b$timestamp[i] <- aux #as.POSIXct(aux, format = "%Y-%m-%d %H:%M:%S")
    
    if(tmp != tmp1){
      day = day+1
    }
    i = i+1
  }
  
  df <- structure(list(dataTimestamp = b$timestamp,
                      axis1 = data$activity,
                      steps = data$line), 
                     .Names = c("dataTimestamp","axis1","steps"), 
                      class = "data.frame", 
                  row.names = c(NA, tail(data$line,1)))#as.factor(paste0(-1*tail(data$line,1),"L")))) #-22308L))

  df
}

