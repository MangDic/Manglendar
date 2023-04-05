//
//  SchedularInteractor.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs
import RxSwift

protocol SchedularRouting: ViewableRouting {
    func navigateToDetailScreen(events: [ScheduleEvent])
}

protocol SchedularPresentable: Presentable {
    var listener: SchedularPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SchedularListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SchedularInteractor: PresentableInteractor<SchedularPresentable>, SchedularInteractable, SchedularPresentableListener {
    weak var router: SchedularRouting?
    weak var listener: SchedularListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SchedularPresentable) {
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
    
    func didTapCalendarCell(event: [ScheduleEvent]) {
        router?.navigateToDetailScreen(events: event)
    }
}
