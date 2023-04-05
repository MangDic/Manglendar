//
//  AddEventInteractor.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs
import RxSwift

protocol AddEventRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddEventPresentable: Presentable {
    var listener: AddEventPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddEventListener: AnyObject {
    func addEvent(event: ScheduleEvent)
}

final class AddEventInteractor: PresentableInteractor<AddEventPresentable>, AddEventInteractable, AddEventPresentableListener {

    weak var router: AddEventRouting?
    weak var listener: AddEventListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AddEventPresentable) {
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
    
    func didTapSaveButton(scheduleEvent: ScheduleEvent) {
        listener?.addEvent(event: scheduleEvent)
    }
}
