setwd("C:/Users/korea/Downloads")
csv_data=read.csv("all.csv",stringsAsFactors = F)
csv_data=csv_data[,-1]


#######################
data=head(sort(table(csv_data[,2]),decreasing = T),10)
color=sample(colors(),10)
bar=barplot(data,col=color,ylim=c(0,max(data)*1.2),main="주소 빈도수")
text(bar, data+50, data)

########################

data=head(sort(table(csv_data["time"]),decreasing = T),10)
color=sample(colors(),10)
pct <- round(data/sum(data)*100)
lbls <- paste(names(data),"\n", pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(data,labels = lbls, col=color,
    main="시간")

########################
csv_data['time']
new_data1=apply(csv_data["money"],1,substr,1,2)
new_data2=as.numeric(gsub(",","",apply(csv_data["money"],1,substr,3,100)))
table(new_data1)
new_data2[which(new_data1=="건별")]
