require(httr)
require(stringr)
require(XML)

api_url = "https://openapi.naver.com/v1/search/blog.xml"

query = URLencode(iconv("안드로이드", to="UTF-8"))
query = str_c("?query=", query)

client_id     = "noG7HsziobcXP4C7VaKG"
client_secret = "je9CN9AIsl"

result = GET(str_c(api_url, query), 
             add_headers("X-Naver-Client-Id" = client_id, "X-Naver-Client-Secret" = client_secret))

xml_ = xmlParse(result)

xpathSApply(xml_, "/rss/channel/item/title", xmlValue)
xpathSApply(xml_, "/rss/channel/item/link", xmlValue)
xpathSApply(xml_, "/rss/channel/item/description", xmlValue)

# 검색 결과를 50건 출력 (최대 100건)

display_ = "&display=50"

result = GET(str_c(api_url, query, display_), 
             add_headers("X-Naver-Client-Id" = client_id, "X-Naver-Client-Secret" = client_secret))
xml_ = xmlParse(result)
xpathSApply(xml_, "/rss/channel/item/title", xmlValue)


# 101번째 검색 결과부터 출력 (최대 1000건)

start_ = "&start=50"

result = GET(str_c(api_url, query, start_), 
             add_headers("X-Naver-Client-Id" = client_id, "X-Naver-Client-Secret" = client_secret))
xml_ = xmlParse(result)
xpathSApply(xml_, "/rss/channel/item/title", xmlValue)

# 유사도가 아닌 날짜순으로 검색된 결과 출력

sort_ = "&sort=date"

result = GET(str_c(api_url, query, sort_), 
             add_headers("X-Naver-Client-Id" = client_id, "X-Naver-Client-Secret" = client_secret))
xml_ = xmlParse(result)
xpathSApply(xml_, "/rss/channel/item/title", xmlValue)

# 위의 결과 전부 적용

result = GET(str_c(api_url, query, display_, start_, sort_), 
             add_headers("X-Naver-Client-Id" = client_id, "X-Naver-Client-Secret" = client_secret))
xml_ = xmlParse(result)
xpathSApply(xml_, "/rss/channel/item/title", xmlValue)

