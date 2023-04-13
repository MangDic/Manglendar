//
//  ScheduleEvent.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/04.
//

import Foundation

struct ScheduleEvent: Codable, Hashable {
    let eventType: EventType
    let title: String
    let date: Date
    let place: PlaceData?
    let color: Int
}

enum EventType: Codable {
    case general_event
    case hoilday_event
}
