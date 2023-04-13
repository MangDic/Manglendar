//
//  ScheduleEventManager.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/07.
//

import Foundation
import RxCocoa

class ScheduleEventManager {
    static let shared = ScheduleEventManager()
    let eventsRelay = BehaviorRelay<[String: [ScheduleEvent]]>(value: [:])
    private var eventsArr = [String: [ScheduleEvent]]()
    private let userDefaults = UserDefaults.standard
    private let eventKey = "events"
    
    private init() {
        loadEvents()
    }
    
    /// UserDefaults에 저장된 일정들을 가져옵니다.
    private func loadEvents() {
        guard let data = userDefaults.data(forKey: eventKey) else { return }
        do {
            let events = try JSONDecoder().decode([String: [ScheduleEvent]].self, from: data)
            eventsArr = events
            eventsRelay.accept(eventsArr)
        }
        catch {
            print("Error decoding events: \(error)")
            return
        }
    }
    
    /// API를 사용하여 공휴일 데이터를 가져옵니다. (XML)
    func getHolidays(year: Int) {
        let apiKey = "GzVslgn%2BgMpKn90xZ5QetTQxeuOU9iT7Dl05LHqFt2ZiU3XU4BDElQFEt9HyCruoDyCjcQDTI9CK2siJNisQqw%3D%3D"
        let urlString = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo?solYear=\(year)&numOfRows=100&ServiceKey=\(apiKey)&type=json"

        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            let delegate = HolidayXMLParserDelegate()
            parser.delegate = delegate
            parser.parse()
            
            DispatchQueue.main.async {
                let holidays = delegate.holidays
                for holiday in holidays {
                    if holiday.name == "1" { continue }
                    let holidayEvent = ScheduleEvent(eventType: .hoilday_event,
                                                     title: holiday.name,
                                                     date: Date().convertStringToDate(date: holiday.date),
                                                     place: nil,
                                                     color: 2)
                    
                    let key = holidayEvent.date.convertDateToString(type: .key)
                    
                    if self.eventsArr[key] == nil {
                        self.eventsArr[key] = [holidayEvent]
                    } else {
                        var isDuplicate = false
                        
                        for event in self.eventsArr[key]! {
                            if event.title == holidayEvent.title && event.date == holidayEvent.date {
                                isDuplicate = true
                                break
                            }
                        }
                        
                        if !isDuplicate {
                            self.eventsArr[key]!.append(holidayEvent)
                        }
                    }
                }
                
                self.saveEvents(events: self.eventsArr)
                self.eventsRelay.accept(self.eventsArr)
            }

        }
        task.resume()
    }
    
    func saveEvents(events: [String: [ScheduleEvent]]) {
        do {
            let data = try JSONEncoder().encode(events)
            userDefaults.set(data, forKey: eventKey)
        }
        catch {
            print("Error encoding events: \(error)")
        }
    }
    
    func removeEvent(event: ScheduleEvent) {
        let key = event.date.convertDateToString(type: .key)
        if let events = eventsArr[key], let index = events.firstIndex(where: { $0 == event }) {
            eventsArr[key]?.remove(at: index)
        }
        eventsRelay.accept(eventsArr)
        saveEvents(events: eventsArr)
    }
    
    func removeEvents() {
        userDefaults.removeObject(forKey: eventKey)
    }
}

class HolidayXMLParserDelegate: NSObject, XMLParserDelegate {
    var holidays: [Holiday] = []
    var isDate = false
    var isHoliday = false
    var date: String = ""
    var holidayName: String = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "locdate" {
            isDate = true
        } else if elementName == "dateName" {
            isHoliday = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isDate {
            date = string
            isDate = false
        } else if isHoliday {
            holidayName = string
            isHoliday = false
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let holiday = Holiday(date: date, name: holidayName)
            holidays.append(holiday)
        }
    }
}
struct Holiday {
    let date: String
    let name: String
}
