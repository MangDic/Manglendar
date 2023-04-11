//
//  SchedularRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs
import Foundation

protocol SchedularInteractable: Interactable, EventDetailListener, AddEventListener, EventViewListener {
    var router: SchedularRouting? { get set }
    var listener: SchedularListener? { get set }
}

protocol SchedularViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
    func pushViewController(viewController: ViewControllable?)
    func popToRootViewController()
}

final class SchedularRouter: ViewableRouter<SchedularInteractable, SchedularViewControllable>, SchedularRouting {
    let eventDetailBuilder: EventDetailBuilder
    let addEventBuilder: AddEventBuilder
    let eventViewBuilder: EventViewBuilder
    
    private var currentChild: ViewableRouting?
    
    init(interactor: SchedularInteractable,
         viewController: SchedularViewControllable,
         eventDetailBuilder: EventDetailBuilder,
         addEventBuilder: AddEventBuilder,
         eventViewBuilder: EventViewBuilder) {
        self.eventDetailBuilder = eventDetailBuilder
        self.addEventBuilder = addEventBuilder
        self.eventViewBuilder = eventViewBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToAddEventScreen(date: Date?) {
        detachCurrentChild()
        navigateToAddEventScreen(date: date)
    }
    
    func navigateToDetailScreen(events: [ScheduleEvent], date: Date) {
        detachCurrentChild()
        let detailRouter = eventDetailBuilder.build(withListener: interactor,
                                                    events: events,
                                                    date: date)
        attachChild(detailRouter)
        viewController.replaceModal(viewController: detailRouter.viewControllable)
        currentChild = detailRouter
    }

    func navigateToAddEventScreen(date: Date?) {
        detachCurrentChild()
        let addEventRouter = addEventBuilder.build(withListener: interactor, date: date)
        attachChild(addEventRouter)
        viewController.replaceModal(viewController: addEventRouter.viewControllable)
        currentChild = addEventRouter
    }
    
    func navigateToEventView(event: ScheduleEvent) {
        let eventViewRouter = eventViewBuilder.build(withListener: interactor, event: event)
        attachChild(eventViewRouter)
        viewController.pushViewController(viewController: eventViewRouter.viewControllable)
        currentChild = eventViewRouter
    }
    
    func popToRootViewController() {
        viewController.popToRootViewController()
    }
    
    private func detachCurrentChild() {
        if let currentChild = currentChild {
            detachChild(currentChild)
            viewController.replaceModal(viewController: nil)
        }
    }
}
