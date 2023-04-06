//
//  Date+.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import Foundation

extension Date {
    /// event 딕셔너리의 키값으로 사용합니다.
    func convertStringKey() -> String {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return "\(date.year ?? 0)\(date.month ?? 0)\(date.day ?? 0)"
    }
    
    /// A년 B월 C일 형식으로 변환합니다.
    func convertDateToTitle() -> String {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return "\(date.year ?? 0)년 \(date.month ?? 0)월 \(date.day ?? 0)일"
    }
}
