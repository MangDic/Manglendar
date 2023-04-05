//
//  EventDetailRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs

protocol EventDetailInteractable: Interactable {
    var router: EventDetailRouting? { get set }
    var listener: EventDetailListener? { get set }
}

protocol EventDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EventDetailRouter: ViewableRouter<EventDetailInteractable, EventDetailViewControllable>, EventDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: EventDetailInteractable, viewController: EventDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
