//
//  Date+.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import Foundation

extension Date {
    /// DateType에 맞는 String으로 변환합니다.
    func convertDateToString(type: DateType) -> String {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let month = String(format: "%02d", date.month ?? 0)
        let day = String(format: "%02d", date.day ?? 0)
        
        switch type {
        case .key:
            return "\(date.year ?? 0)\(month)\(day)"
        case .comming:
            return "\(date.year ?? 0)년 \(month)월 \(day)일"
        }
    }
}

enum DateType {
    case comming    // 다가오는 일정
    case key        // event 딕셔너리 키값
}
