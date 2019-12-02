hchs_to_agd <- function(){
  library(magrittr)
  library(DBI)
  # Load Csv file
  a = read.csv('/home/grauber/Documentos/dev/Actigraphy/data/hchs/hchs-sol-sueno-00163225.csv')
  
  #insert day to timestamp
  a <- insert_date(a)
  
  # Normalize to send to agd file
  b = data.frame(timestamp=(a$time), 
                 axis1=(a$activity), 
                 axis2=(a$activity), 
                 axis3=(a$activity),
                 steps=(a$day),
                 lux=(a$whitelight),
                 inclineOff=(a$validday),
                 inclineStanding=(a$dayofweek),
                 inclineSitting=(a$sawa2),
                 inclineLying=(a$line))
  # Send to agd file
  
  # Load the agd file
  
  # Process the data
  b <- b %>% collapse_epochs(60)
  c <- b %>% apply_tudor_locke()
  
}

