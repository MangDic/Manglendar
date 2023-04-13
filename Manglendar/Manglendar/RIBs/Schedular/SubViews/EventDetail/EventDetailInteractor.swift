//
//  EventDetailInteractor.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import Foundation
import RIBs
import RxCocoa
import RxSwift

protocol EventDetailRouting: ViewableRouting {
}

protocol EventDetailPresentable: Presentable {
    var listener: EventDetailPresentableListener? { get set }
    func setDateLabel(date: Date)
}

protocol EventDetailListener: AnyObject {
    func routeToAddEventScreen(date: Date?)
    func routeToEventScreen(event: ScheduleEvent)
}

final class EventDetailInteractor: PresentableInteractor<EventDetailPresentable>, EventDetailInteractable, EventDetailPresentableListener {
    
    weak var router: EventDetailRouting?
    weak var listener: EventDetailListener?
    
    var eventsRelay = BehaviorRelay<[ScheduleEvent]>(value: [])
    let component: EventDetailComponent
    init(presenter: EventDetailPresentable, component: EventDetailComponent) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
        eventsRelay.accept(component.events)
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        eventsRelay.accept(component.events.sorted(by: { $0.date < $1.date }))
        presenter.setDateLabel(date: component.date)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: EventDetailPresentableListener
    func didTapAddButton() {
        listener?.routeToAddEventScreen(date: component.date)
    }
    
    func didTapEvent(event: ScheduleEvent) {
        listener?.routeToEventScreen(event: event)
    }
}
