//
//  AddEventInteractor.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs
import RxSwift
import Foundation

protocol AddEventRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddEventPresentable: Presentable {
    var listener: AddEventPresentableListener? { get set }
    func updatePickerDate(date: Date?)
    func updateEventData(event: ScheduleEvent)
}

protocol AddEventListener: AnyObject {
    func addEvent(event: ScheduleEvent)
}

final class AddEventInteractor: PresentableInteractor<AddEventPresentable>, AddEventInteractable, AddEventPresentableListener {

    weak var router: AddEventRouting?
    weak var listener: AddEventListener?

    var event: ScheduleEvent?
    
    let component: AddEventComponent
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: AddEventPresentable, component: AddEventComponent) {
        self.component = component
        self.event = component.event
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.updatePickerDate(date: component.date)
        if let event = component.event {
            presenter.updateEventData(event: event)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapSaveButton(scheduleEvent: ScheduleEvent) {
        // 수정 버튼으로 진입한 경우, 변경 전 데이터는 삭제
        if let event = event {
            ScheduleEventManager.shared.removeEvent(event: event)
        }
        listener?.addEvent(event: scheduleEvent)
    }
}
