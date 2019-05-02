#install.packages("rvest")
library(rvest)
library(stringr)

#######main

repect = TRUE
i = 1
j = 1
all=list()
url='http://www.alba.co.kr/job/area/MainLocal.asp?page=1&pagesize=50&viewtype=L&sidocd=063&gugun=&dong=&d_area=&d_areacd=&strAreaMulti=&hidJobKind=&hidJobKindMulti=&WorkTime=&searchterm=&AcceptMethod=&ElecContract=&HireTypeCD=&CareerCD=&CareercdUnRelated=&LastSchoolCD=&LastSchoolcdUnRelated=&GenderCD=&GenderUnRelated=&AgeLimit=0&AgeUnRelated=&PayCD=&PayStart=&WelfareCD=&Special=&WorkWeekCD=&WeekDays=&hidSortCnt=50&hidSortOrder=&hidSortDate=&WorkPeriodCD=&hidSort=&hidSortFilter=Y&hidListView=LIST&WsSrchKeywordWord=&hidWsearchInOut=&hidSchContainText='
data=read_html(url,encoding='CP949')
while(repect){
  temp = data %>% html_nodes(xpath=paste0('//*[@id="NormalInfo"]/table/tbody/tr[',i,']')) %>% html_text()
  temp = str_split(temp,"\r\n\r\n\t")
  adress = temp[[1]][1]
  temp = str_split(temp[[1]][2],"\r\n\t\r\n\t\t")
  contents = temp[[1]][1]
  temp = gsub("스크랩\r\n\t\t요약보기\r\n\t\t새창보기\r\n\t\r\n\r\n\r\n","",temp[[1]][2])
  temp = str_split(temp,"\r\n")
  
  all$adress[j] = adress
  all$contents[j] = contents
  all$time[j] = temp[[1]][1]
  all$money[j] = temp[[1]][2]
  all$when[j] = temp[[1]][3]
  
  temp = data %>% html_nodes(xpath=paste0('//*[@id="NormalInfo"]/table/tbody/tr[',i,']','/td[2]/a'))%>% html_attr("href")
  url=paste0("http://www.alba.co.kr",temp)
  ## phone number
  in_data=read_html(url,encoding='CP949')
  phone_number = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[1]/div[2]/ul/li[2]/p[1]') %>% html_text()
  limit = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[1]/div[1]/ul') %>% html_text()
  limit=gsub("\\r","",limit)
  limit=gsub("\\t","",limit)
  limit=str_split(limit,"\\n\\n")
  
  all$career[j] = limit[[1]][1]
  all$sex[j] = limit[[1]][2]
  all$age[j] = limit[[1]][3]
  all$school[j] = limit[[1]][4]
  
  content = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[1]/div[2]') %>% html_text()
  content=gsub("\\r","",content)
  content=gsub("\\t","",content)
  content=str_split(content,"\\n\\n")
  
  all$employ[j] = content[[1]][2]
  all$people[j] = content[[1]][3]
  
  
  ########Condition 조건
  con = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[2]') %>% html_text()
  con=gsub("\\r","",con)
  con=gsub("\\t","",con)
  con=gsub("\\n근무조건\\n","",con)
  con=str_split(con,"\\n\\n")
  
  all$long[j] = con[[1]][2]
  all$day[j] = con[[1]][3]
  
  
  if (i==5) break
  check=str_split(all$when[j],"")[[1]]
  if (check[length(check)] %in% "전") {
    repect = TRUE
  }
  else {
    repect = FALSE
  }
  i = i + 2
  j = j + 1
  
}
write.csv(all,"test.csv")
all
