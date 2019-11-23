#include
source(file = "src/csv_to_agd.R")


 # ideia de menu
while(1){
  i=as.numeric(readline(prompt="Number of file: "))
  if(i == 0){
    break;
  }else if(i==1){
    ola()
  }
}