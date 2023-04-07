//
//  Resource.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/07.
//

import Foundation

struct R {
    struct String { }
}

extension R.String {
    struct AddEvent {
        static let titlePlaceholder = "제목을 입력하세요."
        static let save = "저장"
        static let cancel = "취소"
        static let emptyTitleDescription = "제목이 없습니다."
    }
    
    struct EventDetail {
        static let emptyEventDescription = "일정이 없습니다 :("
        static let addEventDescription = "일정 추가"
        static let placeEmpty = "장소 : 등록한 장소가 없습니다."
        static let timeEmpty = "시간 : 등록한 시간이 없습니다."
    }
    
    struct Calendar {
        static let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
        static let month: (Int, Int) -> String = { return "\($0)년 \($1)월" }
        static let today = "오늘"
        static let eventCount: (Int) -> String = { return "+\($0)" }
    }
    
    struct CommingEventList {
        static let title = "다가오는 일정"
        static let dataEmptyDescription = "다가오는 일정이 없습니다 :(\n일정을 추가해보세요!"
    }
}


