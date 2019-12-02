insert_date <- function(data){
  library('lubridate')
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
    aux1 <- paste0("*",data$time[i],"*")
    
    aux <- paste(date, data$time[i])
    #print(aux)
    b$timestamp <- as.POSIXct(aux, format = "%Y-%m-%d %H:%M:%S")
    print(b$timestamp[i])
  
    #print(data$time[i])
    #data$time[i] <- sub("",date,data$time[i])
    #print(date$time[i])
    if(tmp != tmp1){
      day = day+1
    }
    i = i+1
   }
  data
}
