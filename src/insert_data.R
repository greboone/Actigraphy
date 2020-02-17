#' Insert data connect to the database 'monitoring' and send the data for each monitoring input
insert_data <- function(info, linha, cochilo, patient_uuid){
  source(file = "src/send_query_indicator.R")
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
      patient = patient_uuid # patient UUID
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
      
      if(cochilo == 0){ # Monitoramento normal
        
        monitoring <- tail(monitoring_id,1)
        
        indicator = 1 # Eficiencia
        value = info$efficiency
        send_query_indicator(db,indicator,value,monitoring)

        indicator = 2 # Latencia do sono
        value = info$total_sleep_time
        send_query_indicator(db,indicator,value,monitoring)
        
        indicator = 9 # Excitações
        value = info$nonzero_epochs
        send_query_indicator(db,indicator,value,monitoring)       
        
        indicator = 10 # Despertares
        value = info$nb_awakenings
        send_query_indicator(db,indicator,value,monitoring)       
        
        indicator = 11 # Wake after onset
        value = info$wake_after_onset
        send_query_indicator(db,indicator,value,monitoring)       
        
        
      }
          #' 
          #' Cochilos: Número de cochilos em um período de 24 horas.
          #' Duração de cochilo: Duração média dos cochilos em minutos.
          #' ```acho q n```Frequência de cochilo: Número de dias em um período de uma semanacom registros de cochilos
          #' 
          #'
      
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