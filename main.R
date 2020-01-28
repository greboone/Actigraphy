#include
source(file = "src/hchs_to_agd.R")
source(file = "src/mesa_to_agd.R")
source(file = "src/oya_to_agd.R")
source(file = "src/file_to_agd.R")

 # ideia de menu
while(1){
  cat("\014")
  message("Current Directory: ")
  message(getwd())
  cat("\014")
  message("Types of files:")
  message("0 - Exit;")
  message("1 - hchs database; (Usually epochs of 30 seconds)")
  message("2 - mesa database; (Usually epochs of 30 seconds)")
  message("3 -  oya database; (Usually epochs of 01 second, it takes longer)")
  i=as.numeric(readline(prompt="Choose the type of file you want to insert: "))
  if(i == 0){
    break;
  }else if(i==1){
    file_to_agd(1);
  }else if(i==2){
    file_to_agd(2);
  }else if(i==3){
    file_to_agd(3);
  }
}

