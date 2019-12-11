# Script que converte um AGD para o modelo de dados do SleepWeb
agd_to_sleepweb <- function(data){
  library(RPostgreSQL)
  
  insert_data <- function(info, linha, cochilo){
    print("Inside insert_data")
    print(info)
    if(cochilo == 0){
      
    #monitoring <- list(patient = "5b3edff7-e011-4388-8be4-dd9a20fe92ec", # UUID do paciente
     #                            monitoring_begin = data$in_bed_time[i],
      #                           monitoring_end = data$out_bed_time[i])  
    
    monitoring <- structure(list(patient = '5b3edff7-e011-4388-8be4-dd9a20fe92ec', # UUID do paciente
                                 monitoring_begin = info$in_bed_time,
                                 monitoring_end = info$out_bed_time), 
                            .Names = c("patient","monitoring_begin","monitoring_end"), 
                            class = "data.frame", 
                            row.names = c(NA, 1))#, tail(info,1)))  
    
    
    #utilizar querys
    print(monitoring)
    print("Inserting into table monitoring")
    dbWriteTable(db,"monitoring", monitoring, append = TRUE)
    print("Inserted into table")
    dbReadTable(db, "monitoring")
    
    
    query <- paste0("SELECT id 
                     FROM monitoring 
                     WHERE last_update IS NOT NULL; ")
    print("Sending Query")
    monitoring_id <- dbSendQuery(db, query)
      
    indicator <- structure(list(indicator = 1, # Eficiencia
                                 value = info$efficiency,
                            monitoring = monitoring_id), 
                .Names = c("indicator","value","monitoring"), 
                class = "data.frame", 
                row.names = c(NA, 1))
    dbWriteTable(db,"indicator", indicator, append=TRUE)
    
    indicator <- structure(list(indicator = 2, # Latencia do sono
                                value = info$total_sleep_time,
                                monitoring = monitoring_id), 
                           .Names = c("indicator","value","monitoring"), 
                           class = "data.frame", 
                           row.names = c(NA, 1))
    dbWriteTable(db,"indicator", indicator, append=TRUE)
    
    
    
    }else{}
    
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
  
  print(tail(data$in_bed_time,1))
  
  condition <- data$in_bed_time[1]
  linha <- 1
  i <- 1
  print("Counting lines")
  while(condition != tail(data$in_bed_time,1)){
    print(linha)
    linha = linha + 1
    condition <- data$in_bed_time[linha]
  }
  
  print("Starting While")
  while(i != linha){
    insert_data(data[i,], i, 0)
    i = i+1
  }
  
  dbDisconnect(db)
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
