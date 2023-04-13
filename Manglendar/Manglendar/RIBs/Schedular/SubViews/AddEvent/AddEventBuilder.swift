//
//  AddEventBuilder.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs
import Foundation

protocol AddEventDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AddEventComponent: Component<AddEventDependency> {
    var date: Date?
    var event: ScheduleEvent?
}

// MARK: - Builder

protocol AddEventBuildable: Buildable {
    func build(withListener listener: AddEventListener, date: Date?, event: ScheduleEvent?) -> AddEventRouting
}

final class AddEventBuilder: Builder<AddEventDependency>, AddEventBuildable {

    override init(dependency: AddEventDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddEventListener, date: Date? = nil, event: ScheduleEvent? = nil) -> AddEventRouting {
        let component = AddEventComponent(dependency: dependency)
        component.date = date
        component.event = event
        
        let viewController = AddEventViewController()
        let interactor = AddEventInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return AddEventRouter(interactor: interactor, viewController: viewController)
    }
}
