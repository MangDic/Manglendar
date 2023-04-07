//
//  AddEventViewController.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import UIKit
import RxCocoa
import RIBs
import RxSwift

protocol AddEventPresentableListener: AnyObject {
    func didTapSaveButton(scheduleEvent: ScheduleEvent)
}

final class AddEventViewController: UIViewController, AddEventPresentable, AddEventViewControllable {

    weak var listener: AddEventPresentableListener?
    
    var disposeBag = DisposeBag()
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    lazy var titleField = UITextField().then {
        $0.textColor = #colorLiteral(red: 0.5429155236, green: 0.5429155236, blue: 0.5429155236, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.placeholder = R.String.AddEvent.titlePlaceholder
    }
    
    lazy var datePicker = UIDatePicker().then {
        $0.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.preferredDatePickerStyle = .inline
        $0.datePickerMode = .date
    }
    
    lazy var buttonStack = UIStackView().then {
        $0.spacing = 5
        $0.distribution = .fillEqually
    }

    lazy var cancelButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.setTitle(R.String.AddEvent.cancel, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.dismiss(animated: true)
            
        }).disposed(by: disposeBag)
    }
    
    lazy var saveButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.setTitle(R.String.AddEvent.save, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            let event = ScheduleEvent(title: self.titleField.text ?? R.String.AddEvent.emptyTitleDescription,
                                      date: self.datePicker.date,
                                      color: " ")
            self.listener?.didTapSaveButton(scheduleEvent: event)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clearData()
    }
    
    private func setupLayout() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7016903707)
        
        view.addSubview(contentView)
        
        contentView.addSubviews([titleField, datePicker, buttonStack])
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(saveButton)
        
        contentView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        titleField.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(20)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(titleField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
    }
    
    private func clearData() {
        self.titleField.text = nil
    }
    
    func updatePickerDate(date: Date?) {
        if let date = date {
            datePicker.date = date
        }
    }
}
