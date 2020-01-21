#include
source(file = "src/hchs_to_agd.R")

 # ideia de menu
while(1){
  cat("\014")
  message("Current Directory: ")
  message(getwd())
  cat("\014")
  message("Types of files:")
  message("0 - Exit;")
  message("1 - hchs to agd;")
  message("2 - mesa to agd; (not implemented yet)")
  message("3 -  oya to agd; (not implemented yet)")
  i=as.numeric(readline(prompt="Choose the type of file you want to insert: "))
  if(i == 0){
    break;
  }else if(i==1){
    hchs_to_agd();
  }
}

