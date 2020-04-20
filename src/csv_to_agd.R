#' Use any database, verify if the file has 'NA' data in activity collumn, insert the date that is 
#' missing,convert the timestamp to .agd format and the data to a .agd file. After that the .agd file is 
#' loaded and the library actigraph.sleepr is used to process the data. Then the agd_to_sleepweb is called.
#' 

csv_to_agd <- function(file_type){
  
  source("src/insert_date_hchs.R")
  source("src/insert_date_mesa.R")
  source("src/insert_date_oya.R")
  source("src/timestamp_to_agd.R")
  source("src/agd_to_sleepweb.R")
  source("src/verify_NA_oya.R")
  
  library(magrittr,DBI)
  library(RSQLite)
  library(actigraph.sleepr)
  library(uuid)
  
  file <- file.choose()
  a = read.csv(file)
  
  if(file_type == 1){         # HCHS
    a = verify_NA(a)
    b <- insert_date_hchs(a)
  }else if(file_type == 2){   # MESA
    a = verify_NA(a)
    b <- insert_date_mesa(a)
  }else if(file_type == 3){   # OYA
    a = verify_NA_oya(a)
    b <- insert_date_oya(a) 
  }
  b <- timestamp_to_agd(b)
  
  file.copy("data/Model.agd","temp.agd")
  
  db <- DBI::dbConnect(RSQLite::SQLite(), dbname = "temp.agd")
  print("Tables: ")
  print(dbListTables(db))
  print("Data Table fields: ")
  print(dbListFields(db, "data"))
  dbWriteTable(db,"data", b, append=TRUE)
  dbDisconnect(db)
  
    
  dataRaw_01 <- read_agd('temp.agd')
  print(has_missing_epochs(dataRaw_01))

  dataRaw_60 <- dataRaw_01 %>% collapse_epochs(60)

  #dataRaw_60 <- dataRaw_60 %>% apply_sadeh()
  dataRaw_60 <- dataRaw_60 %>% apply_cole_kripke()

  dataResult <- dataRaw_60 %>% apply_tudor_locke()
  
  file.remove("temp.agd")
  
  agd_to_sleepweb(dataResult)
  
  
}