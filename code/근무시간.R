
library(stringr)
library(tidyverse)
setwd("C:\\Users\\coin194\\Downloads\\test")
list.files()
all=matrix(nc=16)

for (i in list.files()){
  temp=read.csv(i,header=F,stringsAsFactors=FALSE)
  all=rbind(all,temp)
}
all=all[-1,]
all=all[,-6]
names(all)=c("불량","adress","contents","time","money","career","sex","age","education","employment","personnel","period","week","close","detail_adress")

write.csv(all,"all.csv")
data=vector()
temp=apply(all['time'],2,substr,1,11)
for (i in 1:length(temp)){
  print(i)
  if (nchar(temp[i,1])!=11) {
    data = c(data,"없음")
    next
  }
  dd=str_split(temp[i,],"~")[[1]]
  hour=abs(as.numeric(substr(dd[2],1,2))-as.numeric(substr(dd[1],1,2)))
  min=round(as.numeric(substr(dd[2],4,5))/60,2) - round(as.numeric(substr(dd[1],4,5))/60,2)
  hour=hour+min
  data = c(data,hour)
}

all$realtime = data

write.csv(all,"all.csv")
