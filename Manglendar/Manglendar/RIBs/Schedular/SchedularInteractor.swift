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
    func navigateToAddEventScreen(date: Date?, event: ScheduleEvent?)
    func navigateToEventView(event: ScheduleEvent)
    func routeToAddEventScreen(date: Date?, event: ScheduleEvent?)
    func routeToEventScreen(event: ScheduleEvent)
    func routeToEditScreen(event: ScheduleEvent)
    func popToRootViewController()
}

protocol SchedularPresentable: Presentable {
    var listener: SchedularPresentableListener? { get set }
}

protocol SchedularListener: AnyObject {
}

final class SchedularInteractor: PresentableInteractor<SchedularPresentable>, SchedularInteractable, SchedularPresentableListener {
    var disposeBag = DisposeBag()
    
    var events = [String:[ScheduleEvent]]()
    var eventsRelay = BehaviorRelay<[String : [ScheduleEvent]]>(value: [:])
    var commingEventsRelay = BehaviorRelay<[ScheduleEvent]>(value: [])
    
    weak var router: SchedularRouting?
    weak var listener: SchedularListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SchedularPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        bind()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: SchedularPresentableListener
    func didTapCalendarCell(date: Date) {
        let key = date.convertDateToString(type: .key)
        router?.navigateToDetailScreen(events: events[key] == nil ? [] : events[key]!, date: date)
    }
    
    func didTapAddEventButton() {
        router?.navigateToAddEventScreen(date: nil, event: nil)
    }
    
    // MARK: - EventViewListener
    func routeToEditScreen(event: ScheduleEvent) {
        router?.routeToEditScreen(event: event)
    }
    
    // MARK: - EventDetailPresentableListener
    func routeToAddEventScreen(date: Date?) {
        router?.routeToAddEventScreen(date: date, event: nil)
    }
    
    func routeToEventScreen(event: ScheduleEvent) {
        router?.routeToEventScreen(event: event)
    }
    
    /// 일정 추가시 수행되는 로직. 딕셔너리에 추가하고 다가오는 일정 데이터를 세팅
    func addEvent(event: ScheduleEvent) {
        let key = event.date.convertDateToString(type: .key)
        if events[key] == nil {
            events[key] = [event]
        }
        else {
            events[key]!.append(event)
        }
        ScheduleEventManager.shared.saveEvents(events: events)
        eventsRelay.accept(events)
        setCommingEvent()
    }
    
    func selectCommingEventCell(event: ScheduleEvent) {
        router?.navigateToEventView(event: event)
    }
    
    func popToRootViewController() {
        router?.popToRootViewController()
    }
    
    // MARK: Binding
    private func bind() {
        ScheduleEventManager.shared.eventsRelay.subscribe(onNext: { [weak self] events in
            guard let `self` = self else { return }
            self.events = events
            self.eventsRelay.accept(events)
            self.setCommingEvent()
        }).disposed(by: disposeBag)
    }
    
    /// 오늘 날짜 이전의 데이터는 추가하지 않음. 날짜순으로 정렬
    private func setCommingEvent() {
        let today = Date().convertDateToString(type: .key)
        
        var arr = [ScheduleEvent]()
        let sortedEvent = events.filter({ $0.key >= today }).sorted(by: { $0.key < $1.key }).map { $0.value }
        for events in sortedEvent {
            arr += events
        }
        commingEventsRelay.accept(arr.filter({ $0.eventType == .general_event }))
    }
}
