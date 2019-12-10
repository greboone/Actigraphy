hchs_to_agd <- function(){
  #librarys 
  library(magrittr)
  library(DBI)
  library(RSQLite)
  library(actigraph.sleepr)
  
  # Read local file
  file <- readline(prompt="Enter: /path_to_file/file_name.csv: ")
  
  # Load Csv file
  a = read.csv(file)
  
  # Verify if file has NA in Activity collumn and change to 0
  a = verify_NA(a)
  
  # Insert day to timestamp and table comes normalized
  print("Calling insert_date")
  b <- insert_date(a)
  print(as_datetime(b$dataTimestamp))
  print("Calling timestamp_to_agd")
  
  b <- timestamp_to_agd(b)
  
  # Create the agd database to insert data 
  file.copy("data/Model.agd","temp.agd")

  # Send to agd file
  db <- DBI::dbConnect(RSQLite::SQLite(), dbname = "temp.agd")
  print("Tables: ")
  print(dbListTables(db))
  print("Data Table fields: ")
  print(dbListFields(db, "data"))
  dbWriteTable(db,"data", b, append=TRUE)
  dbDisconnect(db)
  
  # Load the agd file
  print("Reading .agd File")
  dataRaw_30 <- read_agd('temp.agd')
  
  print("Has missing epochs? ")
  print(has_missing_epochs(dataRaw_30))
  
  # Process the data
  print("Collapsing epochs")
  dataRaw_60 <- dataRaw_30 %>% collapse_epochs(60)
  print("Applying Sadeh")
  dataRaw_60 <- dataRaw_60 %>% apply_sadeh()
  print("Applying tudor locke")
  dataResult <- dataRaw_60 %>% apply_tudor_locke()
  #print(dataResult)
  file.remove("temp.agd")
  
  agd_to_sleepweb(dataResult)
  
}

