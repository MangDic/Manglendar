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
    func didTapCalendarCell(date: Date)
    func didTapAddEventButton()
    var eventsRelay: BehaviorRelay<[String:[ScheduleEvent]]> { get }
}

final class SchedularViewController: UIViewController, SchedularPresentable, SchedularViewControllable {
    weak var listener: SchedularPresentableListener?
    
    var disposeBag = DisposeBag()
    let selectedRelay = PublishRelay<Date>()
    let reloadTrigger = PublishRelay<Void>()
    
    private var targetViewController: ViewControllable?
    private var animationInProgress = false
    
    lazy var todoListView = TodoListView()
    lazy var calendarView = CalendarView()
    
    lazy var addEventButton = UIButton().then {
        $0.layer.cornerRadius = 30
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.tintColor = .white
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.listener?.didTapAddEventButton()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
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
    
    private func bind() {
        calendarView
            .setupDI(listener?.eventsRelay)
            .setupDI(selectedRelay)
        
        selectedRelay.subscribe(onNext: { [weak self] date in
            guard let `self` = self else { return }
            self.listener?.didTapCalendarCell(date: date)
        }).disposed(by: disposeBag)
    }
    
    func replaceModal(viewController: ViewControllable?) {
        targetViewController = viewController
        
        guard !animationInProgress else {
            return
        }
        
        if presentedViewController != nil {
            animationInProgress = true
            dismiss(animated: true) { [weak self] in
                if self?.targetViewController != nil {
                    self?.presentTargetViewController()
                } else {
                    self?.animationInProgress = false
                }
            }
        } else {
            presentTargetViewController()
        }
    }
    
    private func presentTargetViewController() {
        if let targetViewController = targetViewController {
            animationInProgress = true
            present(targetViewController.uiviewController, animated: true) { [weak self] in
                self?.animationInProgress = false
            }
        }
    }
}

