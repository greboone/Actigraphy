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
      
      if(cochilo == 0){
        
        indicator = 1 # Eficiencia
        value = info$efficiency
        monitoring <- tail(monitoring_id,1)
        send_query_indicator(db,indicator,value,monitoring)
        

        indicator = 2 # Latencia do sono
        value = info$total_sleep_time
        monitoring <- tail(monitoring_id,1)
        send_query_indicator(db,indicator,value,monitoring)
        
        #indicator = 10 #  
        #value = info$out_bed_time
        #monitoring <- tail(monitoring_id,1) 
        #send_query_indicator(db,indicator,value,monitoring)
        
        indicator = 11 # Wake after onset
        value = info$wake_after_onset
        monitoring <- tail(monitoring_id,1) 
        send_query_indicator(db,indicator,value,monitoring)       
        
        
      }else{
        if(cochilo == 1){
          #' 
          #' Cochilos: Número de cochilos em um período de 24 horas.
          #' Duração de cochilo: Duração média dos cochilos em minutos.
          #' ```acho q n```Frequência de cochilo: Número de dias em um período de uma semanacom registros de cochilos
          #' 
          #' 

          indicator = 1 # Eficiencia
          value = info$efficiency
          monitoring <- tail(monitoring_id,1)
          send_query_indicator(db,indicator,value,monitoring)
          
          
          indicator = 2 # Latencia do sono
          value = info$total_sleep_time
          monitoring <- tail(monitoring_id,1)
          send_query_indicator(db,indicator,value,monitoring)
          
          indicator = 11 # Wake after onset
          value = info$wake_after_onset
          monitoring <- tail(monitoring_id,1) 
          send_query_indicator(db,indicator,value,monitoring)   
          
          numero_cochilos = numero_cochilos + 1
          
          media_cochilos = media_cochilos + info$latency
          
          #indicator = 6 # Número de cochilos em um período de 24 horas.
          #value = info$
          #monitoring <- tail(monitoring_id,1)
          #send_query_indicator(db,indicator,value,monitoring)
          
  
          #indicator = 7 # Duracao MEDIA do cochilo
          #value = info$total_sleep_time
          #monitoring <- tail(monitoring_id,1) 
          #send_query_indicator(db,indicator,value,monitoring)
          
          #indicator = 8 # Frequencia do cochilo
          #value = 
          #monitoring <- tail(monitoring_id,1)
          #send_query_indicator(db,indicator,value,monitoring)
        }else if(cochilo == 2){
          #numero_cochilos = numero_cochilos + 1
          #media_cochilos = media_cochilos + info$latency
          media_cochilos = (media_cochilos/numero_cochilos)
          
          indicator = 1 # Eficiencia
          value = info$efficiency
          monitoring <- tail(monitoring_id,1)
          send_query_indicator(db,indicator,value,monitoring)
          
          
          indicator = 2 # Latencia do sono
          value = info$total_sleep_time
          monitoring <- tail(monitoring_id,1)
          send_query_indicator(db,indicator,value,monitoring)
          
          indicador = 6
          value = numero_cochilos
          monitoring = tail(monitoring_id,1)
          send_query_indicator(db,indicator,value,monitoring)
          
          indicator = 7
          value = media_cochilos
          monitoring <- tail(monitoring_id,1)
          send_query_indicator(db,indicator,value,monitoring)
          
          indicator = 11 # Wake after onset
          value = info$wake_after_onset
          monitoring <- tail(monitoring_id,1) 
          send_query_indicator(db,indicator,value,monitoring)   

          
        }
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