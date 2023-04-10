# Manglendar
 - RIPs 구조를 이해하기 위한 예제 프로젝트입니다.
 
# 사용 기술
 - RxSwift, SnapKit, RIPs

# 주요 기능
<img width="200" height="350" alt="스크린샷 2023-04-07 오후 2 02 45" src="https://user-images.githubusercontent.com/44960073/230545071-25375c9a-ebb2-4ba6-bda3-f8127012f1d9.png"><img width="200" height="350" alt="스크린샷 2023-04-10 오후 5 01 47" src="https://user-images.githubusercontent.com/44960073/230856524-d937674e-0555-4f62-8ec7-87056ed9fad4.png"><img width="200" height="350" alt="스크린샷 2023-04-10 오후 5 01 25" src="https://user-images.githubusercontent.com/44960073/230856539-6da6212e-b9e0-49cb-9444-fe7f82e6e8b5.png"><img width="200" height="350" alt="스크린샷 2023-04-10 오후 5 02 10" src="https://user-images.githubusercontent.com/44960073/230856547-d8d163d4-9f42-4fd3-833a-3308dc6e62c9.png">


 - 일정 추가
 - 일정의 레이블 색상 지정 (예정)
 - 날짜별 일정 조회
 - 다가오는 일정 조회
 - 약속 장소 경로 검색 (예정)

# History
## 2023. 04. 10
 - 다가오는 일정 더보기 버튼 추가 (수정 및 삭제)
 - 공휴일 API 연동 (일정들 가져올 때 중복체크)
 - 다가오늘 일정 컬렉션뷰 크기를 셀에 맞춤 (estimatedItemSize = UICollectionViewFlowLayout.automaticSize)
 
## 2023. 04. 07
 - CommingEventListView 데이터 바인딩
 - AddEventView titleField 바인딩 추가 (텍스트 유무에 따라 저장 버튼 isEnabled과 백그라운드 색 설정) 
 - ScheduleEventManager(UserDefaults)로 일정 데이터 관리

## 2023. 04. 06
- AddEventView에 date 전달 이벤트 추가
- 메인에서 바로 일정 추가를 할 경우에는 nil값을 전달하여 datePicker가 오늘 날짜를 선택하도록
- 그렇지 않은 경우(이벤트 디테일에서 일정추가 클릭) 클릭한 날짜를 전달하여 datePicker의 날짜는 선택한 날짜로 변경
 <br/>
 
## 2023. 04. 05
- 기본적인 틀을 만들고 RIPs 구조로 변경 (SchedularView, AddEventView, EventDetailView)
- 이벤트를 추가할 경우 SchedularView의 달력(collectionView)에 반영하여 업데이트
- 일정 상세 페이지에서 일정 추가 페이지로 넘어갈 때, EventDetail를 detach 후 AddEventView를 attach (일정 상세 모달을 내린 후 일정 추가 모달을 보여줌)
<br/>

## 2023. 04. 04
<img width="200" alt="스크린샷 2023-04-06 오전 11 00 29" src="https://user-images.githubusercontent.com/44960073/230253622-6be1bc60-6d52-4efc-bc20-bbac8dbd3a57.png">

- Calendar의 데이터를 사용하여 커스텀 달력 생성
<br/>

## 트러블 슈팅
 #### 일정을 추가하면 어떤 셀에서는 원하는 높이로 출력되지만, 그렇지 않은 경우도 발생
 - 레이아웃이 업데이트 되면 높이를 변경하는 방식으로 변경?
