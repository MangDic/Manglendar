//
//  SchedularRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs

protocol SchedularInteractable: Interactable, EventDetailListener, AddEventListener {
    var router: SchedularRouting? { get set }
    var listener: SchedularListener? { get set }
}

protocol SchedularViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

final class SchedularRouter: ViewableRouter<SchedularInteractable, SchedularViewControllable>, SchedularRouting {
    let eventDetailBuilder: EventDetailBuilder
    let addEventBuilder: AddEventBuilder
    
    private var currentChild: ViewableRouting?
    
    init(interactor: SchedularInteractable,
         viewController: SchedularViewControllable,
         eventDetailBuilder: EventDetailBuilder,
         addEventBuilder: AddEventBuilder) {
        self.eventDetailBuilder = eventDetailBuilder
        self.addEventBuilder = addEventBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToAddEventScreen() {
        detachCurrentChild()
        navigateToAddEventScreen()
    }
    
    func navigateToDetailScreen(events: [ScheduleEvent]) {
        detachCurrentChild()
        let detailRouter = eventDetailBuilder.build(withListener: interactor,
                                                    events: events)
        attachChild(detailRouter)
        viewController.replaceModal(viewController: detailRouter.viewControllable)
        currentChild = detailRouter
    }

    func navigateToAddEventScreen() {
        detachCurrentChild()
        let addEventRouter = addEventBuilder.build(withListener: interactor)
        attachChild(addEventRouter)
        viewController.replaceModal(viewController: addEventRouter.viewControllable)
        currentChild = addEventRouter
    }

    
    private func detachCurrentChild() {
        if let currentChild = currentChild {
            detachChild(currentChild)
            viewController.replaceModal(viewController: nil)
        }
    }
}
