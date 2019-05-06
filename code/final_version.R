#install.packages("rvest")
library(rvest)
library(stringr)
library(httr)
#######main


setwd("C:/Users/korea/Documents/test")

repect = TRUE
i = 1

##################################url read

url=paste0('http://www.alba.co.kr/job/area/MainLocal.asp?schnm=LOCAL&viewtype=L&sidocd=063&gugun=&d_areacd=&WsSrchKeywordWord=&hidschContainText=&hidWsearchInOut=&hidSort=FREEORDER&hidSortOrder=&hidSortDate=&hidListView=LIST&hidSortCnt=50&hidSortFilter=Y&hidJobKind=&hidJobKindMulti=&page=1&hidSearchyn=N&strAreaMulti=&careercd=&lastschoolcd=&agelimit=&searchterm=&hidCareerCD=&hidLastSchoolCD=&hidLastPayCD=&hidPayStart=')
data=vector()
tryCatch({
  data<-read_html(url,encoding='CP949')},
  error = function(e){
    data<-read_html(url,encoding='UTF-8')
  }
)

################################## data processing

while(repect){
  if (i>100){
    i=1
    url=paste0('http://www.alba.co.kr/job/area/MainLocal.asp?schnm=LOCAL&viewtype=L&sidocd=063&gugun=&d_areacd=&WsSrchKeywordWord=&hidschContainText=&hidWsearchInOut=&hidSort=FREEORDER&hidSortOrder=&hidSortDate=&hidListView=LIST&hidSortCnt=50&hidSortFilter=Y&hidJobKind=&hidJobKindMulti=&page=2&hidSearchyn=N&strAreaMulti=&careercd=&lastschoolcd=&agelimit=&searchterm=&hidCareerCD=&hidLastSchoolCD=&hidLastPayCD=&hidPayStart=')
    data=vector()
    tryCatch({
      data<-read_html(url,encoding='CP949')},
      error = function(e){
        data<-read_html(url,encoding='UTF-8')
      }
    )
  }
  all=list()
  temp = data %>% html_nodes(xpath=paste0('//*[@id="NormalInfo"]/table/tbody/tr[',i,']')) %>% html_text()
  if (length(temp) == 0) {
    i = i + 2
    next
  }
  
  #########adress append
  
  temp = str_split(temp,"\r\n\r\n\t")
  adress = temp[[1]][1]
  temp = str_split(temp[[1]][2],"\r\n\t\r\n\t\t")
  
  #########contents append
  
  contents = temp[[1]][1]
  temp = gsub("스크랩\r\n\t\t","",temp[[1]][2])
  temp = gsub("요약보기\r\n\t\t","",temp)
  temp = gsub("새창보기\r\n\t\r\n","",temp)
  temp = gsub("전자근로계약서\r\n\r\n","",temp)
  temp = gsub("\r","",temp)
  temp = gsub("\t","",temp)
  temp = gsub("\n\n","",temp)
  temp = gsub("\n","kk",temp)
  
  temp = str_split(temp,"kk")
  
  ########input list & concat adress/contents/time/money
  
  all$adress = adress
  all$contents = contents
  all$time = temp[[1]][1]
  all$money = temp[[1]][2]
  all$when = temp[[1]][3]
  
  
  #########Want to more data so detail website
  
  
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
  
  ######## phone number
  
  phone_number = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[1]/div[2]/ul/li[2]/p[1]') %>% html_text()
  limit = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[1]/div[1]/ul') %>% html_text()
  if (length(limit) == 0) {
    i = i + 2
    next
  }
  limit=gsub("\\r","",limit)
  limit=gsub("\\t","",limit)
  limit=str_split(limit,"\\n\\n")
  
  #############input list & concat career/sex/age/school
  
  all$career = gsub("경력 ","",limit[[1]][1])
  all$sex = gsub("성별 ","",limit[[1]][2])
  all$age = gsub("연령 ","",limit[[1]][3])
  all$school = gsub("학력 ","",limit[[1]][4])
  
  content = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[1]/div[2]') %>% html_text()
  content=gsub("\\r","",content)
  content=gsub("\\t","",content)
  content=str_split(content,"\\n\\n")
  
  all$employ = gsub("고용형태 ","",content[[1]][2])
  all$people = gsub("모집인원 ","",content[[1]][3])
  
  
  ###############append condition/date
  
  
  con = in_data %>% html_nodes(xpath = '//*[@id="DetailView"]/div[2]/div[2]/div[2]') %>% html_text()
  con=gsub("\\r","",con)
  con=gsub("\\t","",con)
  con=gsub("\\n근무조건\\n","",con)
  con=str_split(con,"\\n\\n")
  
  all$long = gsub("근무기간 ","",con[[1]][2])
  all$day = gsub("근무요일 ","",con[[1]][3])
  
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
  
  #################Stop Method
  
  
  check=str_split(all$when,"")[[1]]
  if (check[length(check)-1] %in% "분") {
    repect = TRUE
  }else {
    repect = FALSE
  }
  i = i + 2
  
  ############### write csv file & save
  
  file_name=str_split(Sys.time(),"")[[1]][1:14]
  file_name=paste0(file_name,collapse = "")
  file_name=paste0(file_name,".csv")
  file_name=gsub(" ","_",file_name)
  file_name=gsub("-","_",file_name)
  file_name=gsub(":","_",file_name)
  write.table(all,file_name,sep=',',col.names = F,append=T)
}

############ auto taskscheduleR by one hour

#install.packages("taskscheduleR")
#library(taskscheduleR)
#dir = "C:/Users/korea/Documents/test/delta_version2.R"

#taskscheduler_create(taskname = "myfancyscript", rscript = dir,
#                     schedule = "MINUTE", starttime = "13:40", modifier = 60,startdate = format(Sys.Date(), "%Y/%m/%d"))


#taskscheduler_delete(taskname = "myfancyscript")



