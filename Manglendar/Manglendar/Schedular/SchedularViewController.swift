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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SchedularViewController: UIViewController, SchedularPresentable, SchedularViewControllable {
    weak var listener: SchedularPresentableListener?
    
    var disposeBag = DisposeBag()
    let selectedRelay = PublishRelay<Void>()
    
    lazy var todoListView = TodoListView()
    lazy var calendarView = CalendarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
    
    private func setupLayout() {
        view.addSubview(todoListView)
        view.addSubview(calendarView)
        
        todoListView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        calendarView.snp.makeConstraints {
            $0.top.equalTo(todoListView.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func showBottomSheet() {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.modalTransitionStyle = .crossDissolve
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    private func bind() {
        calendarView.setupDI(selectedRelay)
        selectedRelay.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.showBottomSheet()
        }).disposed(by: disposeBag)
    }
}

