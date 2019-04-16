#install.packages("rvest")
library(rvest)
library(stringr)

#######main

repect = TRUE
i = 1
j = 1

url='http://www.alba.co.kr/job/area/MainLocal.asp?page=1&pagesize=50&viewtype=L&sidocd=063&gugun=&dong=&d_area=&d_areacd=&strAreaMulti=&hidJobKind=&hidJobKindMulti=&WorkTime=&searchterm=&AcceptMethod=&ElecContract=&HireTypeCD=&CareerCD=&CareercdUnRelated=&LastSchoolCD=&LastSchoolcdUnRelated=&GenderCD=&GenderUnRelated=&AgeLimit=0&AgeUnRelated=&PayCD=&PayStart=&WelfareCD=&Special=&WorkWeekCD=&WeekDays=&hidSortCnt=50&hidSortOrder=&hidSortDate=&WorkPeriodCD=&hidSort=&hidSortFilter=Y&hidListView=LIST&WsSrchKeywordWord=&hidWsearchInOut=&hidSchContainText='
data=read_html(url,encoding='CP949')
while(repect){
  all=list()
  temp = data %>% html_nodes(xpath=paste0('//*[@id="NormalInfo"]/table/tbody/tr[',i,']')) %>% html_text()
  temp = str_split(temp,"\r\n\r\n\t")
  adress = temp[[1]][1]
  temp = str_split(temp[[1]][2],"\r\n\t\r\n\t\t")
  contents = temp[[1]][1]
  temp = gsub("스크랩\r\n\t\t요약보기\r\n\t\t새창보기\r\n\t\r\n\r\n\r\n","",temp[[1]][2])
  temp = str_split(temp,"\r\n")
  
  all$adress = adress
  all$contents = contents
  all$time = temp[[1]][1]
  all$money = temp[[1]][2]
  all$when = temp[[1]][3]
  
  temp = data %>% html_nodes(xpath=paste0('//*[@id="NormalInfo"]/table/tbody/tr[',i,']','/td[2]/a'))%>% html_attr("href")
  url=paste0("http://www.alba.co.kr",temp)
  in_data=vector()
  ## phone number
  tryCatch({
    in_data<<-read_html(url,encoding='CP949')},
    error = function(e){
      in_data<<-read_html(url,encoding='UTF-8')
    }
  )
  phone_number = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[1]/div[2]/ul/li[2]/p[1]') %>% html_text()
  limit = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[1]/div[1]/ul') %>% html_text()
  if (length(limit) == 0) next
  limit=gsub("\\r","",limit)
  limit=gsub("\\t","",limit)
  limit=str_split(limit,"\\n\\n")
  
  all$career = limit[[1]][1]
  all$sex = limit[[1]][2]
  all$age = limit[[1]][3]
  all$school = limit[[1]][4]
  
  content = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[1]/div[2]') %>% html_text()
  content=gsub("\\r","",content)
  content=gsub("\\t","",content)
  content=str_split(content,"\\n\\n")
  
  all$employ = content[[1]][2]
  all$people = content[[1]][3]
  
  
  ########Condition 조건
  con = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[2]') %>% html_text()
  con=gsub("\\r","",con)
  con=gsub("\\t","",con)
  con=gsub("\\n근무조건\\n","",con)
  con=str_split(con,"\\n\\n")
  
  all$long = con[[1]][2]
  all$day = con[[1]][3]
  
  time = in_data %>% html_nodes(xpath = '//*[@id="InfoApply"]/ul/li[1]') %>% html_text()
  time = gsub('\\r','',time)
  time = gsub('\\t','',time)
  time = gsub('모집마감일\\n','',time)
  time = gsub('\\n\\n','',time)
  time = gsub('마감임박! 입사지원을 서둘러 주세요.','',time)
  all$deadline = time[2]
  
  com_adr = in_data %>% html_nodes(xpath = '//*[@id="InfoWork"]/ul/li[3]') %>% html_text()
  com_adr = gsub('근무지주소 ','',com_adr)
  all$com_adr = com_adr[2]
  if (i>100) break
  i = i + 2
  j = j + 1
  write.table(all,"test.csv",sep=',',col.names = F,append=T)
}

all
