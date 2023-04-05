//
//  AddEventBuilder.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs

protocol AddEventDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AddEventComponent: Component<AddEventDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AddEventBuildable: Buildable {
    func build(withListener listener: AddEventListener) -> AddEventRouting
}

final class AddEventBuilder: Builder<AddEventDependency>, AddEventBuildable {

    override init(dependency: AddEventDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddEventListener) -> AddEventRouting {
        //let component = AddEventComponent(dependency: dependency)
        let viewController = AddEventViewController()
        let interactor = AddEventInteractor(presenter: viewController)
        interactor.listener = listener
        return AddEventRouter(interactor: interactor, viewController: viewController)
    }
}
