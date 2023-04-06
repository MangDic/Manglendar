## 2023. 04. 06
- AddEventView에 date 전달 이벤트 추가
- 메인에서 바로 일정 추가를 할 경우에는 nil값을 전달하여 datePicker가 오늘 날짜를 선택하도록
- 그렇지 않은 경우(이벤트 디테일에서 일정추가 클릭) 클릭한 날짜를 전달하여 datePicker의 날짜는 선택한 날짜로 변경

## 2023. 04. 05
- 기본적인 틀을 만들고 RIPs 구조로 변경 (SchedularView, AddEventView, EventDetailView)
- 이벤트를 추가할 경우 SchedularView의 달력(collectionView)에 반영하여 업데이트
- 일정 상세 페이지에서 일정 추가 페이지로 넘어갈 때, EventDetail를 detach 후 AddEventView를 attach (일정 상세 모달을 내린 후 일정 추가 모달을 보여줌)

## 2023. 04. 04
<img width="363" alt="스크린샷 2023-04-06 오전 11 00 29" src="https://user-images.githubusercontent.com/44960073/230253622-6be1bc60-6d52-4efc-bc20-bbac8dbd3a57.png">
- Calendar의 데이터를 사용하여 커스텀 달력 생성


## 트러블 슈팅
 #### 일정을 추가하면 어떤 셀에서는 원하는 높이로 출력되지만, 그렇지 않은 경우도 발생
 - 레이아웃이 업데이트 되면 높이를 변경하는 방식으로 변경?
