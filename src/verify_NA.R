verify_NA <- function(data){
  i=1
  lines = tail(data$line,1)

    while(i <= lines){
      if(is.na(data$activity[i]) == TRUE){
        data$activity[i] <- paste0('0')
      }
      i = i+1
    }
  data
}