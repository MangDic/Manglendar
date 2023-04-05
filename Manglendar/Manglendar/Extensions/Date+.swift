//
//  Date+.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import Foundation

extension Date {
    func convertStringKey() -> String {
        let date = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return "\(date.year ?? 0)\(date.month ?? 0)\(date.day ?? 0)"
    }
}
