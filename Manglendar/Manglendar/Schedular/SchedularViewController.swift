//
//  SchedularViewController.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol SchedularPresentableListener: AnyObject {
    func didTapCalendarCell(event: [ScheduleEvent])
}

final class SchedularViewController: UIViewController, SchedularPresentable, SchedularViewControllable {
    weak var listener: SchedularPresentableListener?
    
    var disposeBag = DisposeBag()
    let selectedRelay = PublishRelay<[ScheduleEvent]>()
    let addEventViewActionRelay = PublishRelay<AddEventViewAction>()
    
    lazy var todoListView = TodoListView()
    lazy var calendarView = CalendarView()
    lazy var addEventView = AddEventView()
    
    lazy var addEventButton = UIButton().then {
        $0.layer.cornerRadius = 30
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.tintColor = .white
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.showAddEventScreen()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
    
    private func setupLayout() {
        view.addSubview(todoListView)
        view.addSubview(calendarView)
        view.addSubview(addEventButton)
        
        todoListView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(todoListView.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        addEventButton.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func showAddEventScreen() {
        self.present(addEventView, animated: true)
    }
    
    private func bind() {
        calendarView.setupDI(selectedRelay)
        
        addEventView.setupDI(addEventViewActionRelay)
        
        selectedRelay.subscribe(onNext: { [weak self] event in
            guard let `self` = self else { return }
            self.listener?.didTapCalendarCell(event: event)
        }).disposed(by: disposeBag)
        
//        addEventViewActionRelay.subscribe(onNext: { [weak self] event in
//            guard let `self` = self else { return }
//            switch event {
//            case .save(let event):
//                let eventDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: event.date)
//                let year = eventDateComponents.year ?? 0
//                let month = eventDateComponents.month ?? 0
//                let day = eventDateComponents.day ?? 0
//                
//                let key = "\(year)\(month)\(day)"
//                
//                if self.calendarView.events[key] == nil {
//                    self.calendarView.events[key] = [event.title]
//                }
//                else {
//                    self.calendarView.events[key]!.append(event.title)
//                }
//                self.calendarView.updateCalendar()
//            case .dismiss:
//                print(" ")
//            }
//        }).disposed(by: disposeBag)
    }
}

