//
//  EventDetailBuilder.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs

protocol EventDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EventDetailComponent: Component<EventDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol EventDetailBuildable: Buildable {
    func build(withListener listener: EventDetailListener) -> EventDetailRouting
}

final class EventDetailBuilder: Builder<EventDetailDependency>, EventDetailBuildable {

    override init(dependency: EventDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EventDetailListener) -> EventDetailRouting {
        let component = EventDetailComponent(dependency: dependency)
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return EventDetailRouter(interactor: interactor, viewController: viewController)
    }
}
