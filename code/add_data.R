
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
names(all)=c("�ҷ�","adress","contents","time","money","career","sex","age","education","employment","personnel","period","week","close","detail_adress")


bad=read.csv("C:/Users/korea/Documents/�ҷ�.csv",stringsAsFactors=FALSE)
check=bad["������"]


for (i in check$������){
  tmp=regexpr(i,all[,3])
  idx=which(tmp != -1)
  all[idx,1]="�ҷ�"
}

write.csv(all,file="C:/Users/korea/Downloads/all.csv")