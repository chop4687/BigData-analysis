
install.packages("tidyverse")
library(tidyverse)
setwd("C:/Users/korea/Downloads/test")
list.files()
all=matrix(nc=16)

for (i in list.files()){
  temp=read.csv(i,header=F,stringsAsFactors=FALSE)
  all=rbind(all,temp)
}
all=all[-1,]
all=all[,-6]
names(all)=c("불량","adress","contents","time","money","career","sex","age","education","employment","personnel","period","week","close","detail_adress")


bad=read.csv("C:/Users/korea/Documents/불량.csv",stringsAsFactors=FALSE)
check=bad["사업장명"]


for (i in check$사업장명){
  tmp=regexpr(i,all[,3])
  idx=which(tmp != -1)
  all[idx,1]="불량"
}

write.csv(all,file="C:/Users/korea/Downloads/all.csv")
