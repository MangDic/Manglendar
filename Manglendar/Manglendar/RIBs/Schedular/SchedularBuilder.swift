//
//  SchedularBuilder.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs

protocol SchedularDependency: Dependency, EventDetailDependency, AddEventDependency, EventViewDependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SchedularComponent: Component<SchedularDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SchedularBuildable: Buildable {
    func build() -> SchedularRouting
}

final class SchedularBuilder: Builder<SchedularDependency>, SchedularBuildable {

    override init(dependency: SchedularDependency) {
        super.init(dependency: dependency)
    }

    func build() -> SchedularRouting {
        let component = SchedularComponent(dependency: dependency)
        let viewController = SchedularViewController()
        let interactor = SchedularInteractor(presenter: viewController)
        
        let eventDetailBuilder = EventDetailBuilder(dependency: dependency)
        let addEventBuilder = AddEventBuilder(dependency: dependency)
        let eventViewBuilder = EventViewBuilder(dependency: dependency)
        
        return SchedularRouter(interactor: interactor,
                               viewController: viewController,
                               eventDetailBuilder: eventDetailBuilder,
                               addEventBuilder: addEventBuilder,
                               eventViewBuilder: eventViewBuilder)
    }
}
