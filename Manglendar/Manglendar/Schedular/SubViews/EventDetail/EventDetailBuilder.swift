//
//  EventDetailBuilder.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs
import Foundation

protocol EventDetailDependency: Dependency {
}

final class EventDetailComponent: Component<EventDetailDependency> {
    let events: [ScheduleEvent]
    let date: Date
    init(dependency: EventDetailDependency, events: [ScheduleEvent], date: Date) {
        self.events = events
        self.date = date
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventDetailBuildable: Buildable {
    func build(withListener listener: EventDetailListener, events: [ScheduleEvent], date: Date) -> EventDetailRouting
}

final class EventDetailBuilder: Builder<EventDetailDependency>, EventDetailBuildable {
    
    override init(dependency: EventDetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EventDetailListener, events: [ScheduleEvent], date: Date) -> EventDetailRouting {
        let component = EventDetailComponent(dependency: dependency,
                                             events: events,
                                             date: date)
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(presenter: viewController,
                                               component: component)
        interactor.listener = listener
        return EventDetailRouter(interactor: interactor, viewController: viewController)
    }
}
