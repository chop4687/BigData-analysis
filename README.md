### JunKyu

대학생이라면 한번쯤은 찾아보는 아르바이트
자리에 따라 편하고 시급이 높은 좋은 아르바이트
최저시급을 안챙겨주거나 매우 힘든 아르바이트
그 스펙트럼이 매우 다양하다.

예를 들어 상시모집이거나 매일 다시 글이 올라오거나 오랫동안 남아있는 아르바이트같은 경우 그다지 질이 안좋은 아르바이트일 경우가 많다.
이러한 현상들을 찾아보기 위해

알바몬, 알바천국과 같은 곳에서 데이터를 모은다

질 좋은 알바자리 꿀알바 등등 좋은  사기 등 여러가지를 분석하기 위해 데이터를 수집한다.

#2019/4/4

rvest 사용법과 어떠한 정보가 현재 알바구직 사이트에 존재하는지를 조사해보았다.

#2019/4/7

유용한 정보가 무엇인지 내부 XML구조와 정규표현식을 통해 데이터 전처리 방법을 어떻게 할지 찾아보았다.

#2019/4/8
전처리 과정과 이를 더 효율적으로 저장 / 관리 및 데이터를 모으는 방법을 정리 중이다.

#2019/4/9

taskscheduleR를 이용하여 주기적으로 R 프로그램을 자동으로 실행하는 방법을 익혔다.

#2019/4/11

test file을 생성 및 관리하는 방법을 알아보고 만들어 보았다.

alpha version complete

구축중인 데이터셋 : 아르바이트 기준
장소, 내용 , 시간, 월급, 구인시작시간, 경력, 성별, 나이, 약력, 고용형태, 모집인원, 근무기간, 근무요일

#2019/4/16

beta version complete
근무지 주소와 구인 기간 추가 
코드를 일반화 시켰다.

#2019/05/02
2시간마다 ip 차단이 풀리는 것을 확인.
매 시간마다 정보를 크롤링하여 데이터를 구축해나간다.

문제점
100회 반복시 해당 사이트에서 접속 IP를 차단한다. 24시간후에 다시 lock은 풀린다.
이에따라 한번에 모든 아르바이트 정보를 크롤링하는것이 불가능하다.
