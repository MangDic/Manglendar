//
//  SchedularInteractor.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs
import RxCocoa
import RxSwift
import Foundation

protocol SchedularRouting: ViewableRouting {
    func navigateToDetailScreen(events: [ScheduleEvent], date: Date)
    func navigateToAddEventScreen(date: Date?)
    func routeToAddEventScreen(date: Date?)
}

protocol SchedularPresentable: Presentable {
    var listener: SchedularPresentableListener? { get set }
}

protocol SchedularListener: AnyObject {
}

final class SchedularInteractor: PresentableInteractor<SchedularPresentable>, SchedularInteractable, SchedularPresentableListener {
    var eventsRelay = BehaviorRelay<[String : [ScheduleEvent]]>(value: [:])
    
    weak var router: SchedularRouting?
    weak var listener: SchedularListener?
    
    var events = [String:[ScheduleEvent]]()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SchedularPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        loadEvents()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapCalendarCell(date: Date) {
        let key = date.convertStringKey()
        router?.navigateToDetailScreen(events: events[key] == nil ? [] : events[key]!, date: date)
    }
    
    func didTapAddEventButton() {
        router?.navigateToAddEventScreen(date: nil)
    }
    
    func routeToAddEventScreen(date: Date?) {
        router?.routeToAddEventScreen(date: date)
    }
    
    func addEvent(event: ScheduleEvent) {
        let key = event.date.convertStringKey()
        if events[key] == nil {
            events[key] = [event]
        }
        else {
            events[key]!.append(event)
        }
        eventsRelay.accept(events)
    }
    
    private func loadEvents() {
        
    }
}
