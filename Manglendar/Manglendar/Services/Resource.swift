//
//  Resource.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/07.
//

import Foundation
import UIKit

struct R {
    struct Color { }
    struct String { }
}

extension R.Color {
    static let colorArr: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
}

extension R.String {
    struct AddEvent {
        static let titlePlaceholder = "제목을 입력하세요."
        static let placePlaceholder = "장소를 입력하세요. (선택)"
        static let save = "저장"
        static let cancel = "취소"
        static let search = "검색"
        static let select = "선택"
        static let emptyTitleDescription = "제목이 없습니다."
        static let emptyPlaceDescription = "검색 결과가 없습니다 :("
    }
    
    struct EventDetail {
        static let emptyEventDescription = "일정이 없습니다 :("
        static let addEventDescription = "일정 추가"
        static let placeEmpty = "장소 : 등록한 장소가 없습니다."
        static let timeEmpty = "시간 : 등록한 시간이 없습니다."
        static let place: (String) -> String = { return "장소: \($0)" }
        static let time: (Int, Int) -> String = { return "시간: \($0)시 \($1)분" }
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
    
    struct EventView {
        static let edit = "수정"
        static let cancel = "취소"
        static let delete = "삭제"
        static let deleteTitle = "이벤트 삭제"
        static let deleteDescription = "이 이벤트를 삭제하시겠습니까?"
        static let emptyPlace = "등록한 장소가 없습니다."
    }
}


