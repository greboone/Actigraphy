send_query_indicator <- function(db, indicator, value, monitoring){
  
  query <- paste0("INSERT INTO indicator 
                         (indicator, value, monitoring) 
                         VALUES(", indicator, ", ", value, ", ", monitoring, ")")
  
  print("Inserting into table indicator")
  dbSendQuery(db,query)
  
}