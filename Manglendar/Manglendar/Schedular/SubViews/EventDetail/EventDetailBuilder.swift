//
//  EventDetailBuilder.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs

protocol EventDetailDependency: Dependency {
}

final class EventDetailComponent: Component<EventDetailDependency> {
    let events: [ScheduleEvent]
    
    init(dependency: EventDetailDependency, events: [ScheduleEvent]) {
        self.events = events
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventDetailBuildable: Buildable {
    func build(withListener listener: EventDetailListener, events: [ScheduleEvent]) -> EventDetailRouting
}

final class EventDetailBuilder: Builder<EventDetailDependency>, EventDetailBuildable {
    
    override init(dependency: EventDetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EventDetailListener, events: [ScheduleEvent]) -> EventDetailRouting {
        let component = EventDetailComponent(dependency: dependency,
                                             events: events)
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(presenter: viewController,
                                               component: component)
        interactor.listener = listener
        return EventDetailRouter(interactor: interactor, viewController: viewController)
    }
}
