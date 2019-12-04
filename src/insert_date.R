insert_date <- function(data){
  
  lines = tail(data$line,1)
  i=1
  day = 1
  b = data.frame(timestamp = data$time)
  class(b$timestamp) = "posix"
  
  while(i <= lines){
    tmp = data$dayofweek[i] 
    if(i>=lines-1){
      tmp1 = tmp
    }else{
      tmp1 = data$dayofweek[i+1]
    }
    
    date <- paste0("0001-01-0", day)
    aux <- paste(date, data$time[i])
    b$timestamp <- as.POSIXct(aux, format = "%Y-%m-%d %H:%M:%S")
    if(tmp != tmp1){
      day = day+1
    }
    i = i+1
  }
  
  denis = data.frame(pid = data$pid,
                     sawa2 = data$sawa2,
                     line = data$line,
                     offwrist = data$offwrist,
                     whitelight = data$whitelist,
                     starth = data$starth,
                     day = data$day,
                     dayofweek = data$dayofweek,
                     validday = data$validday,
                     time = b$timestamp)
  
  denis
}
