//
//  SchedularRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs

protocol SchedularInteractable: Interactable, EventDetailListener {
    var router: SchedularRouting? { get set }
    var listener: SchedularListener? { get set }
}

protocol SchedularViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SchedularRouter: ViewableRouter<SchedularInteractable, SchedularViewControllable>, SchedularRouting {
    let eventDetailBuilder: EventDetailBuilder
    
    init(interactor: SchedularInteractable,
         viewController: SchedularViewControllable,
         eventDetailBuilder: EventDetailBuilder) {
        self.eventDetailBuilder = eventDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func navigateToDetailScreen(events: [ScheduleEvent]) {
        let detailRouter = eventDetailBuilder.build(withListener: interactor)
        attachChild(detailRouter)
        let vc = detailRouter.viewControllable.uiviewController
        viewController.uiviewController.present(vc, animated: true)
    }
}
