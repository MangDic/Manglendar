//
//  EventViewInteractor.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/10.
//

import RIBs
import RxCocoa
import RxSwift

protocol EventViewRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EventViewPresentable: Presentable {
    var listener: EventViewPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EventViewListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func popToRootViewController()
    func routeToEditScreen(event: ScheduleEvent)
}

final class EventViewInteractor: PresentableInteractor<EventViewPresentable>, EventViewInteractable, EventViewPresentableListener {

    weak var router: EventViewRouting?
    weak var listener: EventViewListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: EventViewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - EventViewPresentableListener
    func didTapBackButton() {
        listener?.popToRootViewController()
    }
    
    func didTapEditButton(event: ScheduleEvent) {
        listener?.routeToEditScreen(event: event)
    }
    
    func didTapDeleteButton(event: ScheduleEvent) {
        ScheduleEventManager.shared.removeEvent(event: event)
        listener?.popToRootViewController()
    }
}
