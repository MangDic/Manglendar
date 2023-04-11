//
//  EventViewBuilder.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/10.
//

import RIBs

protocol EventViewDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EventViewComponent: Component<EventViewDependency> {
    var event: ScheduleEvent
    
    init(dependency: EventViewDependency, event: ScheduleEvent) {
        self.event = event
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventViewBuildable: Buildable {
    func build(withListener listener: EventViewListener, event: ScheduleEvent) -> EventViewRouting
}

final class EventViewBuilder: Builder<EventViewDependency>, EventViewBuildable {

    override init(dependency: EventViewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EventViewListener, event: ScheduleEvent) -> EventViewRouting {
        let component = EventViewComponent(dependency: dependency, event: event)
        let viewController = EventViewController()
        let interactor = EventViewInteractor(presenter: viewController)
        interactor.listener = listener
        return EventViewRouter(interactor: interactor,
                               viewController: viewController,
                               component: component)
    }
}
