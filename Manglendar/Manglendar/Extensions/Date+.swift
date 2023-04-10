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
    /// Date에 대한 시간과 분을 리턴합니다.
    func getTimeValue() -> (Int, Int) {
        let date = Calendar.current.dateComponents([.hour, .minute], from: self)
        let hour = date.hour
        let minute = date.minute
        return (hour ?? 0, minute ?? 0)
    }
    
    func convertStringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = dateFormatter.date(from: date) {
            return date
        }
        return Date()
    }
}

enum DateType {
    case comming    // 다가오는 일정
    case key        // event 딕셔너리 키값
}
