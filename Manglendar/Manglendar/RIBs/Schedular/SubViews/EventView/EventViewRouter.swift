//
//  EventViewRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/10.
//

import RIBs

protocol EventViewInteractable: Interactable {
    var router: EventViewRouting? { get set }
    var listener: EventViewListener? { get set }
}

protocol EventViewViewControllable: ViewControllable {
    func updateEventData(event: ScheduleEvent)
}

final class EventViewRouter: ViewableRouter<EventViewInteractable, EventViewViewControllable>, EventViewRouting {
    
    init(interactor: EventViewInteractable,
         viewController: EventViewViewControllable,
         component: EventViewComponent) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        viewController.updateEventData(event: component.event)
    }
}
