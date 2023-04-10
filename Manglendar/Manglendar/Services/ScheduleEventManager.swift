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
    private var holidaySet = Set<ScheduleEvent>()
    private let userDefaults = UserDefaults.standard
    private let eventKey = "events"
    
    private init() {
        loadEvents()
        getHolidays(year: 2023)
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
        let urlString = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getHoliDeInfo?solYear=\(year)&ServiceKey=\(apiKey)&type=json"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            let delegate = HolidayXMLParserDelegate()
            parser.delegate = delegate
            parser.parse()
            let holidays = delegate.holidays
            
            for holiday in holidays {
                self.holidaySet.insert(ScheduleEvent(title: holiday.name,
                                                     date: Date().convertStringToDate(date: holiday.date),
                                                     place: "",
                                                     color: 2))
            }
            
            DispatchQueue.main.async {
                for holiday in self.holidaySet {
                    let key = holiday.date.convertDateToString(type: .key)
                    if self.eventsArr[key] == nil {
                        self.eventsArr[key] = [holiday]
                    }
                    else {
                        self.eventsArr[key]!.append(holiday)
                    }
                }
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
