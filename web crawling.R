install.packages("rvest")
library(rvest)

url='http://franchise.ftc.go.kr/user/extra/main/62/firMst/list/jsp/LayOutPage.do?column=brd&search=&searchFirRegNo=&selUpjong=&selIndus=&srow=10&spage='

page=1:5

# each page URL
pages=paste0(url, page, sep='')

# extract data from page url
extract <- function(page_url){ 
  html <- read_html(page_url)
  table <- html %>% html_nodes("table")
  td <- table %>% html_nodes("td") 
  text <- td %>% html_text() 
  text <- gsub("\\r\\n(\t)*", "", text)
  df <- as.data.frame(matrix(text, nrow=10, ncol=6, byrow=TRUE))
  
  link <- html %>% html_nodes("a.hover-link")
  dataIdx <- gsub("<a.*dataIdx=|&.*", "", link)
  dataIdx <- dataIdx[c(TRUE, FALSE)]
  df <- cbind(df, dataIdx)
}

# method 1
ptm <- proc.time()
mat <- extract(pages[1])
for(i in 2:length(page) ) mat <- rbind(mat, extract(pages[i]))
proc.time()-ptm

# method 2
ptm <- proc.time()
result <- lapply(pages, extract)
do.call(rbind, result)
proc.time()-ptm


# get total pages  
total_pages <- function(first_page){
  html <- read_html(first_page)
  li <- html %>% html_node("li.paginationLast") 
  href <- li %>% html_node("a") %>% html_attr("href") 
  sub("/user.*=", "", href)
}

total_pages(pages[1])  
