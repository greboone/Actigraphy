# Script que converte um AGD para o modelo de dados do SleepWeb
agd_to_sleepweb <- function(data){
  library(RPostgreSQL)
  
  
  indicator <- function(){
    dele <- structure(list(indicator = ,
                               value = ,
                          monitoring = ), 
              .Names = c("indicator","value","monitoring"), 
              class = "data.frame", 
              row.names = c(NA, 1))
  }
  monitoring <- function(){
    
    dale  <- structure(list(patient = , # UUID do paciente
                   monitoring_begin = data$in_bed_time,
                   monitoring_end = data$out_bed_time), 
              .Names = c("patient","monitoring_begin","monitoring_end"), 
              class = "data.frame", 
              row.names = c(NA, 1))
  }
  
  
  
  
  print(data)
  
  # Connect to monitoramento
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
  
  while(data$onset[lines] != tail(data$onset,1)){
    lines = lines+1
  }
  
  indicator() 
  
  monitoring()
  
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
