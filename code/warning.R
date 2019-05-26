api_url <- "http://apis.data.go.kr/1470000/FoodExaathrInfoService/getFoodExaathrItem?ServiceKey="
service_key <- "Ou%2BPZz9ro343y4DBK3wtW6ezQrmI%2FUR96%2FSQsxXUd23Xkxp4MOHzj8x4Mrw6e2R4F0dnBxJM8Fzd91w7LqNHgQ%3D%3D"


library(XML)
library(httr)
library(data.table)
total=list()
item=list()
for (i in 1:11){
  url= paste0(api_url,service_key,"&numOfRows=100&pageNo=",i)
  raw.data <- xmlTreeParse(url, useInternalNodes = TRUE,encoding='UTF-8')
  rootNode <- xmlRoot(raw.data)
  items <- rootNode[[2]][['items']]
  size <- xmlSize(items)
  
  for(j in 1:size){
    item_temp <- xmlSApply(items[[j]],xmlValue)
    tmp=regexpr("Àü¶óºÏµµ",item_temp[2])
    if (tmp != -1){
      item_temp_dt <- data.table( name = item_temp[1],
                                  adress = item_temp[2],
                                  start = item_temp[7],
                                  what = item_temp[8],
                                  day = item_temp[9],
                                  when = item_temp[12]
      )
      item[[j]]<-item_temp_dt
    }
  }
  total[[i]] <- rbindlist(item)

}
all=data.table()
for (i in 1:11){
  all=rbind(all,total[[i]])
}

write.csv(all,"warning.csv")
