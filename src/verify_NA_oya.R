verify_NA_oya <- function(data){
  print("Inside verify_NA_oya")
  i=1
  
  while(i <= nrow(data)){
    if(is.na(data$Activity[i]) == TRUE){
      data$Activity[i] <- paste0('0')
    }
    i = i+1
  }
  print("Finish verifying")
  data
}