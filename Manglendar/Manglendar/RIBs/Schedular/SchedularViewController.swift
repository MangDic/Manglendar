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
    func selectCommingEventCell(event: ScheduleEvent)
    func didTapAddEventButton()
    var eventsRelay: BehaviorRelay<[String:[ScheduleEvent]]> { get }
    var commingEventsRelay: BehaviorRelay<[ScheduleEvent]> { get }
}

final class SchedularViewController: UIViewController, SchedularPresentable, SchedularViewControllable {
    // MARK: - Properties
    weak var listener: SchedularPresentableListener?
    
    var disposeBag = DisposeBag()
    let selectedScheduleRelay = PublishRelay<Date>()
    let selectedCommingEventRelay = PublishRelay<ScheduleEvent>()
    let reloadTrigger = PublishRelay<Void>()
    
    private var targetViewController: ViewControllable?
    private var animationInProgress = false
    
    // MARK: - Views
    lazy var commingEventListView = CommingEventListView()
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
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubviews([commingEventListView, calendarView, addEventButton])
        
        commingEventListView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(commingEventListView.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        addEventButton.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - Binding
    private func bind() {
        calendarView
            .setupDI(listener?.eventsRelay)
            .setupDI(selectedScheduleRelay)
        
        commingEventListView
            .setupDI(listener?.commingEventsRelay)
            .setupDI(selectedCommingEventRelay)
        
        selectedScheduleRelay
            .subscribe(onNext: { [weak self] date in
                guard let `self` = self else { return }
                self.listener?.didTapCalendarCell(date: date)
            }).disposed(by: disposeBag)
        
        selectedCommingEventRelay
            .subscribe(onNext: { [weak self] event in
                guard let `self` = self else { return }
                self.listener?.selectCommingEventCell(event: event)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - SchedularViewControllable
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
    
    func pushViewController(viewController: ViewControllable?) {
        if let vc = viewController?.uiviewController {
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func popToRootViewController() {
        navigationController?.popViewController(animated: false)
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

