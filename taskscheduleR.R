install.packages("taskscheduleR")
library(taskscheduleR)
dir = "C:/Users/korea/Documents/test/check.R"

taskscheduler_create(taskname = "myfancyscript", rscript = dir,
                     schedule = "MINUTE", starttime = "12:01", modifier = 1,startdate = format(Sys.Date(), "%Y/%m/%d"))
taskscheduler_delete(taskname = "myfancyscript")

taskscheduler_create(taskname = "myfancyscriptdaily", rscript = myscript, 
                     schedule = "DAILY", starttime = "09:10", startdate = format(Sys.Date()+1, "%Y/%m/%d"))

#############test file

library(stringr)
x <- matrix(1:10, ncol = 5)
i=Sys.time()
temp=strsplit(as.character(i), split=" ")
temp=paste0(temp[[1]][1],".csv")
getwd()
write.csv(x, file = paste0("C:/Users/korea/Documents/test/",temp))
