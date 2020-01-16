#' Use the Hchs database, verify if the file has 'NA' data in activity collumn, insert the date that is missing,
#' convert the timestamp to .agd format and the data to a .agd file. After that the .agd file is loaded and the
#' library actigraph.sleepr is used to process the data. Then the agd_to_sleepweb is called.
#' 
#' 

library("print.R")


hchs_to_agd <- function(){
  
  
  library(magrittr,DBI)
  library(RSQLite)
  library(actigraph.sleepr)
  library(uuid)

  file <- readline(prompt="Enter: /path_to_file/file_name.csv: ")
  a = read.csv(file)
  a = verify_NA(a)
  b <- insert_date(a)
  b <- timestamp_to_agd(b)
  
  file.copy("data/Model.agd","temp.agd")
  
  db <- DBI::dbConnect(RSQLite::SQLite(), dbname = "temp.agd")
  print("Tables: ")
  print(dbListTables(db))
  print("Data Table fields: ")
  print(dbListFields(db, "data"))
  dbWriteTable(db,"data", b, append=TRUE)
  dbDisconnect(db)
  
  dataRaw_30 <- read_agd('temp.agd')
  print(has_missing_epochs(dataRaw_30))

  dataRaw_60 <- dataRaw_30 %>% collapse_epochs(60)
  dataRaw_60 <- dataRaw_60 %>% apply_sadeh()
  dataResult <- dataRaw_60 %>% apply_tudor_locke()
    
  file.remove("temp.agd")
  
  agd_to_sleepweb(dataResult)


}


ddd <- function() {
  print1();
  print2();
  print3();
}
