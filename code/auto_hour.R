install.packages("taskscheduleR")
library(taskscheduleR)
dir = "C:/Users/korea/Documents/test/delta_version.R"

taskscheduler_create(taskname = "myfancyscript", rscript = dir,
                     schedule = "MINUTE", starttime = "09:30", modifier = 60,startdate = format(Sys.Date(), "%Y/%m/%d"))
taskscheduler_delete(taskname = "myfancyscript")

