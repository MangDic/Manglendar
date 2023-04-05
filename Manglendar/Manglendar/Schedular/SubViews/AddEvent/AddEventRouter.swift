//
//  AddEventRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs

protocol AddEventInteractable: Interactable {
    var router: AddEventRouting? { get set }
    var listener: AddEventListener? { get set }
}

protocol AddEventViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AddEventRouter: ViewableRouter<AddEventInteractable, AddEventViewControllable>, AddEventRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AddEventInteractable, viewController: AddEventViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
