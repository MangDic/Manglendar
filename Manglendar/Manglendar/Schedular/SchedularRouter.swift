//
//  SchedularRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs

protocol SchedularInteractable: Interactable {
    var router: SchedularRouting? { get set }
    var listener: SchedularListener? { get set }
}

protocol SchedularViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SchedularRouter: ViewableRouter<SchedularInteractable, SchedularViewControllable>, SchedularRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SchedularInteractable, viewController: SchedularViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
