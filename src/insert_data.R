insert_data <- function(info, linha, cochilo){
  print("Inside insert_data")
  print(info)
  tryCatch(
    {
      if(cochilo == 0){
        
        #monitoring <- list(patient = "5b3edff7-e011-4388-8be4-dd9a20fe92ec", # UUID do paciente
        #                            monitoring_begin = data$in_bed_time[i],
        #                           monitoring_end = data$out_bed_time[i])  
        
        #monitoring <- structure(list(
        patient = '5b3edff7-e011-4388-8be4-dd9a20fe92ec' #, # UUID do paciente
        monitoring_begin = info$in_bed_time #,
        monitoring_end = info$out_bed_time #), 
        #.Names = c("patient","monitoring_begin","monitoring_end"), 
        #class = "data.frame", 
        #row.names = c(NA, 1))#, tail(info,1))) 
        
        query <- paste0("INSERT INTO monitoring (patient, monitoring_begin, monitoring_end) VALUES('", patient, "', '", monitoring_begin, "', '", monitoring_end, "')")
        
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
        print(isPostgresqlIdCurrent(db))
        print("Inserting into table monitoring")
        dbSendQuery(db,query)
        
        #dbWriteTable(db,"monitoring", monitoring, append = TRUE)
        print("Inserted into table")
        dbReadTable(db, "monitoring")
        
        
        query <- paste0("SELECT id 
                     FROM monitoring;")
        print("Sending Query")
        #monitoring_id <- 
        #dbSendQuery(db, query)
        dbFetch(dbSendQuery(db, query))
        #dbFetch(monitoring_id)
        #print(monitoring_id) 
        #dbClearResult(monitoring_id)
        print("DALEMERDA")
        
        #indicator <- structure(list(
        indicator = 1#, # Eficiencia
        value = info$efficiency#,
        monitoring = monitoring_id#), 
        #.Names = c("indicator","value","monitoring"), 
        #class = "data.frame", 
        #row.names = c(NA, 1))
        #dbWriteTable(db,"indicator", indicator, append=TRUE)
        query <- paste0("INSERT INTO indicator (indicator, value, monitoring) VALUES(", indicator, ", ", value, ", ", monitoring, ")")
        print("Inserting into table indicator")
        dbSendQuery(db,query)
        
        
        
        
        #indicator <- structure(list(
        indicator = 2#, # Latencia do sono
        value = info$total_sleep_time#,
        monitoring = monitoring_id#), 
        #.Names = c("indicator","value","monitoring"), 
        #class = "data.frame", 
        #row.names = c(NA, 1))
        #dbWriteTable(db,"indicator", indicator, append=TRUE)
        query <- paste0("INSERT INTO indicator (indicator, value, monitoring) VALUES(", indicator, ", ", value, ", ", monitoring, ")")
        print("Inserting into table indicator")
        dbSendQuery(db,query)
        
        
      }else{}
      
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