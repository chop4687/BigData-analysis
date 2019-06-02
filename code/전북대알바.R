#install.packages("rvest")
library(rvest)
library(stringr)
library(httr)


all=list()
for (j in 1:1364){
  url = paste0("https://www.jbnu.ac.kr/kor/?menuID=425&pno=",j)
  data = read_html(url,encoding='UTF-8')
  for (i in 1:9){
    temp = data %>% html_nodes(xpath=paste0('//*[@id="print_area"]/div[3]/table/tbody/tr[',i,']/td[3]/span/a'))%>% html_attr("href")
    url=paste0("https://www.jbnu.ac.kr/kor/",temp)
    in_data=vector()
    
    in_data = read_html(url,encoding='UTF-8')%>% html_nodes(xpath = '//*[@id="form_view"]/div/div[2]/ul')%>% html_text()
    in_data = gsub("\t","",in_data)
    in_data = str_split(in_data,"\n")
    what = paste0(in_data[[1]][2]," : ",in_data[[1]][3])
    name = paste0(in_data[[1]][5]," : ",in_data[[1]][6])
    adress = paste0(in_data[[1]][8]," : ",in_data[[1]][9])
    long = paste0(in_data[[1]][11]," : ",in_data[[1]][12])
    people = paste0(in_data[[1]][14]," : ",in_data[[1]][15])
    time = paste0(in_data[[1]][17]," : ",in_data[[1]][18])
    money = paste0(in_data[[1]][20]," : ",in_data[[1]][21])
    master = paste0(in_data[[1]][23]," : ",in_data[[1]][24])
    
    all$adress = adress
    all$contents = name
    all$time = time
    all$money = money
    all$what = what
    all$long = long
    all$people = people
    all$master = master
    
    write.table(all,"test.csv",sep=',',append=T,col.names = F)
    print(j)
  }
  
}
