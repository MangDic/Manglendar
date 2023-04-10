//
//  ScheduleEvent.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/04.
//

import Foundation

struct ScheduleEvent: Codable, Hashable {
    let title: String
    let date: Date
    let place: String
    let color: Int
}
