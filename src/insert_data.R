#' Insert data connect to the database 'monitoring' and send the data for each monitoring input
insert_data <- function(info, linha, cochilo){
  print("Inside insert_data")
  print(info)
  
  tryCatch(
          expr = {
            drv <- dbDriver("PostgreSQL")
            db <- dbConnect(drv, dbname = "monitoramento",
                            host = "localhost", port = 5432,
                            user = "postgres", password = 3553)
          },
          error=function(cond){
            message("Here's the original error message:")
            message(cond)
            dbDisconnect(db)
            return(NA)
          },
          warning=function(cond) {
            message("Here's the original warning message:")
            message(cond)
            dbDisconnect(db)
            return(NULL)
          }
  )
  
  tryCatch(
    {
      if(cochilo == 0){

        patient = '5b3edff7-e011-4388-8be4-dd9a20fe92ec' # patient UUID
        monitoring_begin = info$in_bed_time
        monitoring_end = info$out_bed_time
        
        query <- paste0("INSERT INTO monitoring 
                         (patient, monitoring_begin, monitoring_end) 
                         VALUES('", patient, "', '", monitoring_begin, "', '", monitoring_end, "')")
        
        print(isPostgresqlIdCurrent(db))
        print("Inserting into table monitoring")
        dbSendQuery(db,query)
        
        print("Inserted into table")
        print("Selecting 'id' from table")
        query <- paste0("SELECT id 
                     FROM monitoring;")
        print("Sending Query")
        monitoring_id <- dbSendQuery(db, query)
        monitoring_id <- dbFetch(monitoring_id)
        print(monitoring_id) 
        print("Query send")
        
        indicator = 1#, # Eficiencia
        value = info$efficiency#,
        monitoring <- tail(monitoring_id,1)#), 
        query <- paste0("INSERT INTO indicator 
                         (indicator, value, monitoring) 
                         VALUES(", indicator, ", ", value, ", ", monitoring, ")")
        print("Inserting into table indicator")
        dbSendQuery(db,query)
        

        indicator = 2#, # Latencia do sono
        value = info$total_sleep_time#,
        monitoring <- tail(monitoring_id,1)#), 

        query <- paste0("INSERT INTO indicator 
                         (indicator, value, monitoring) 
                         VALUES(", indicator, ", ", value, ", ", monitoring, ")")
        print("Inserting into table indicator")
        dbSendQuery(db,query)
        
        
      }else{
        patient = '5b3edff7-e011-4388-8be4-dd9a20fe92ec' # patient UUID
        monitoring_begin = info$in_bed_time
        monitoring_end = info$out_bed_time
        
        query <- paste0("INSERT INTO monitoring 
                         (patient, monitoring_begin, monitoring_end) 
                         VALUES('", patient, "', '", monitoring_begin, "', '", monitoring_end, "')")
        
        print(isPostgresqlIdCurrent(db))
        print("Inserting into table monitoring")
        dbSendQuery(db,query)
        
        print("Inserted into table")
        print("Selecting 'id' from table")
        query <- paste0("SELECT id 
                     FROM monitoring;")
        print("Sending Query")
        monitoring_id <- dbSendQuery(db, query)
        monitoring_id <- dbFetch(monitoring_id)
        print(monitoring_id) 
        print("Query send")
        
        indicator = 6#, # Cochilo
        value = info$efficiency#,
        monitoring <- tail(monitoring_id,1)#), 
        query <- paste0("INSERT INTO indicator 
                         (indicator, value, monitoring) 
                         VALUES(", indicator, ", ", value, ", ", monitoring, ")")
        print("Inserting into table indicator")
        dbSendQuery(db,query)
        

        indicator = 7#, # Duracao do cochilo
        value = info$total_sleep_time#,
        monitoring <- tail(monitoring_id,1)#), 

        query <- paste0("INSERT INTO indicator 
                         (indicator, value, monitoring) 
                         VALUES(", indicator, ", ", value, ", ", monitoring, ")")
        print("Inserting into table indicator")
        dbSendQuery(db,query)
      }
      
    },
    error=function(cond){
      message("Here's the original error message:")
      message(cond)
      dbDisconnect(db)
      return(NA)
    },
    warning=function(cond) {
      message("Here's the original warning message:")
      message(cond)
      dbDisconnect(db)
      return(NULL)
    },
    finally={
      dbDisconnect(db)
      message("End of finally-tryCatch")      
    }
)    
}