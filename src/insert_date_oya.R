#' Insert date insert to the data missing values
insert_date_oya <- function(data){
  print("Inside insert_date")
  
  cond = head(data$Year,1)
  i = 1
  
  aux <- paste0(data$Year,"-",
                data$Month,"-",
                data$Day," ",
                data$Hour,":",
                data$Minute,":",
                data$Second)
 # print(aux)
  
  b = data.frame(timestamp = as.POSIXct(aux))
  class(b$timestamp) = "POSIXct"
  
    #while(cond != NULL){
      
      
     # aux <- paste0(data$Year[i],"-",
      #              data$Month[i],"-",
       #             data$Day[i]," ",
        #            data$Hour[i],":",
         #           data$Minute[i],":",
          #          data$Second[i])
      #b$timestamp[i] <- aux
      
      #aux2 <- paste0("Data: ",data[i],"i: ",i, "| aux:",aux)
      #print(aux2)
      
    #  i = i+1
     # cond = data[i]
    #}
  
  df <- structure(list(dataTimestamp = b$timestamp,
                       axis1 = data$Activity,
                       steps = data$Second), 
                  .Names = c("dataTimestamp","axis1","steps"), 
                  class = "data.frame", 
                  row.names = c(NA, nrow(b)))
  print(df)
  df
}

