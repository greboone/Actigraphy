hchs_to_agd <- function(){
  
  library(magrittr)
  library(DBI)
  # Load Csv file
  a = read.csv('/home/grauber/Documentos/dev/Actigraphy/data/hchs/hchs-sol-sueno-00163225.csv')
  
  # Insert day to timestamp and table comes normalized
  b <- insert_date(a)
  
  # Create the agd database to insert data 
  file.copy("data/Model.agd","temp.agd")
  #assert_that(file.exists("temp.agd"))
  
  # Send to agd file
  db <- DBI::dbConnect(RSQLite::SQLite(), dbname = "temp.agd")
  
  dbWriteTable(db, "dataTimestamp", b$timestamp)
  
  select_dttms <- function(table, cols) {
    query <- "INSERT"
    for (col in cols) {
      query <- paste0(query,
                      " into ", table,
                      " (",col,"),")
    }
    query <- sub("$),",");",query)
    res <- dbSendQuery(db, query)
    dbFetch(res)
  }
  
  
  #select_dttms("data", "dataTimestamp")
  #select_dttms("data", "axis1")
  
  
  
  
  
  
  
  # Load the agd file
  
  # Process the data
  #b <- b %>% collapse_epochs(60)
  #c <- b %>% apply_tudor_locke()
  
}

