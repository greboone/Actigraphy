# Script that converts the AGD data to put in Sleepweb pattern
agd_to_sleepweb <- function(data){
  source(file = "src/insert_data.R")
  library(RPostgreSQL)
  print(data)
  
  new_patient <- readline(prompt="New Patient? (Y/N): ")
  
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
    },
    finally = {
      condition <- data$in_bed_time[1]
      linha <- 1
      i <- 1
      while(condition != tail(data$in_bed_time,1)){
        print(linha)
        linha = linha + 1
        condition <- data$in_bed_time[linha]
      }
      
      query <- paste0("SELECT * 
                     FROM patient;")
      print("Sending Query")
      patients <- dbSendQuery(db, query)
      patients <- dbFetch(patients)
      
      
      if(new_patient == 'Y'|| new_patient == 'y'){
        uuid <- UUIDgenerate(TRUE)
        first_name <- readline(prompt="Patient First Name: ")
        last_name <- readline(prompt="Patient Last Name: ")
        birth_date <- readline(prompt = "Birth Date: ")
        gender <- readline(prompt = "Gender (1/2): ")
        
        query <- paste0("INSERT into patient
                         (uuid, first_name, last_name, birth_date, gender)
                         VALUES
                         ('",uuid, "', '", first_name, "', '", last_name, "', '", birth_date,"', ", gender,")")
        new_patient <- dbSendQuery(db, query)
        
        patient_uuid <- uuid
        
      }else{
        if(new_patient == 'N' || new_patient == 'n'){
          print(patients)
          patient_id <- readline(prompt="Which is your patient? (Select by id): ")
          
          query <- paste0("SELECT uuid 
                           FROM patient
                           WHERE id = ",patient_id,";")
          uuid <- dbSendQuery(db, query)
          uuid <- dbFetch(uuid)
          print(uuid)
          patient_uuid = uuid
        }
      }
      
      
      print("Starting While")
      while(i <= linha){
        
        condition_cochilo <- data$total_sleep_time[i]
        
        if(condition_cochilo <= 300){
          if(i != linha){
            insert_data(data[i,], i, 1, patient_uuid)  
          }else{
            insert_data(data[i,], i, 3, patient_uuid)
          }
        }else{
          if(i != linha){
            insert_data(data[i,], i, 0, patient_uuid)  
          }else{
            insert_data(data[i,], i, 2, patient_uuid)
          }
        }
        
        i = i+1
      }
      
      dbDisconnect(db)
    }
  )
}

#
# Código  |  Indicador
# ------------------------
#      1  |  Eficiência do sono    
#      2  |  Latência do sono
#      3  |  Sono REM
#      4  |  Sono não-REM 1 e 2
#      5  |  Sono não-REM 3 e 4
#      6  |  Cochilos
#      7  |  Duração do cochilo
#      8  |  Frequência do cochilo
#      9  |  Excitações
#     10  |  Despertar
#     11  |  Consciência após o início do sono (WASO)
# 
