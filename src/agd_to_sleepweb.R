# Script that converts the AGD data to put in Sleepweb pattern
agd_to_sleepweb <- function(data){
  library(RPostgreSQL)
  print(data)
  
  tryCatch(
    expr = {
      drv <- dbDriver("PostgreSQL")
      db <- dbConnect(drv, dbname = "monitoramento",
                      host = "localhost", port = 5432,
                      user = "postgres", password = 3553)
      
      print("Tables: ")
      print(dbListTables(db))
      print("Data Table monitoring fields: ")
      print(dbListFields(db, "monitoring"))
      print("Data Table indicator fields: ")
      print(dbListFields(db, "indicator"))
      print("Data Table patient fields: ")
      print(dbListFields(db, "patient"))
      
      print(tail(data$in_bed_time,1))
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
      print("Counting lines")
      while(condition != tail(data$in_bed_time,1)){
        print(linha)
        linha = linha + 1
        condition <- data$in_bed_time[linha]
      }
      
      #condition_cochilo <- head(data$total_sleep_time,1)
      
      print("Starting While")
      while(i != linha){
        
        condition_cochilo <- data$total_sleep_time[i]
        
        if(condition_cochilo >= 250){
          insert_data(data[i,], i, 0)  
        }else{
          insert_data(data[i,], i, 1)
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

#patient <- structure(list(id = ,
 #                         uuid = ,
  #                        first_name = ,
   #                       last_name = ,
    #                      birth_date = ,
     #                     gender = ),
      #               .Names = c("id","uuid","first_name","last_name", "birth_date","gender"),
       #              class = "data.frame",
        #             row.names = c(NA, ))#number of lines)
