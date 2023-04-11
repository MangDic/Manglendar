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
    // MARK: - Properties
    weak var listener: AddEventPresentableListener?
    
    var disposeBag = DisposeBag()
    let placeSelectedRelay = PublishRelay<PlaceData>()
    
    var selectedPlace: PlaceData? = nil
    
    var currentBtn: UIButton?
    
    // MARK: - Views
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    lazy var titleField = UITextField().then {
        $0.textColor = #colorLiteral(red: 0.5429155236, green: 0.5429155236, blue: 0.5429155236, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.placeholder = R.String.AddEvent.titlePlaceholder
    }
    
    lazy var placeField = UITextField().then {
        $0.textColor = #colorLiteral(red: 0.5429155236, green: 0.5429155236, blue: 0.5429155236, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.placeholder = R.String.AddEvent.placePlaceholder
    }
    
    lazy var searchButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.setTitle(R.String.AddEvent.search, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.layer.cornerRadius = 4
    }
    
    lazy var colorStack = UIStackView().then {
        $0.spacing = 5
        $0.backgroundColor = .white
        
        var tag = 0
        for color in R.Color.colorArr {
            let colorBtn = UIButton().then { btn in
                btn.backgroundColor = #colorLiteral(red: 0.9464568496, green: 0.9583716989, blue: 0.9581621289, alpha: 1)
                btn.layer.cornerRadius = 20
                btn.tag = tag
                btn.rx.tap.subscribe(onNext: { [weak self] in
                    guard let `self` = self else { return }
                    self.changeColor(tag: btn.tag, btn: btn)
                }).disposed(by: disposeBag)
            }
            
            let colorView = UIView().then {
                $0.backgroundColor = color
                $0.layer.cornerRadius = 15
                $0.isUserInteractionEnabled = false
            }
            
            $0.addArrangedSubview(colorBtn)
            colorBtn.addSubview(colorView)
            
            colorBtn.snp.makeConstraints {
                $0.size.equalTo(40)
            }
            
            colorView.snp.makeConstraints {
                $0.size.equalTo(30)
                $0.center.equalToSuperview()
            }
            
            if tag == 0 {
                self.currentBtn = colorBtn
            }
            tag += 1
        }
        $0.addArrangedSubview(UIView())
    }
    
    lazy var datePicker = UIDatePicker().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.preferredDatePickerStyle = .inline
        $0.datePickerMode = .dateAndTime
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
        $0.layer.cornerRadius = 8
        $0.setTitle(R.String.AddEvent.save, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            let event = ScheduleEvent(title: self.titleField.text ?? R.String.AddEvent.emptyTitleDescription,
                                      date: self.datePicker.date,
                                      place: self.selectedPlace,
                                      color: self.currentBtn?.tag ?? 0)
            self.listener?.didTapSaveButton(scheduleEvent: event)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    lazy var searchPlaceView = SearchPlaceView().then {
        $0.isHidden = true
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clearData()
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7016903707)
        
        view.addSubview(contentView)
        
        contentView.addSubviews([titleField,
                                 placeField,
                                 searchButton,
                                 colorStack,
                                 datePicker,
                                 buttonStack,
                                 searchPlaceView])
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(saveButton)
        
        contentView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        titleField.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(20)
        }
        
        placeField.snp.makeConstraints {
            $0.top.equalTo(titleField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        searchButton.snp.makeConstraints {
            $0.leading.equalTo(placeField.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalTo(placeField)
            $0.width.equalTo(60)
        }
        
        searchPlaceView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(placeField.snp.bottom).offset(5)
        }
        
        colorStack.snp.makeConstraints {
            $0.top.equalTo(placeField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(colorStack.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
    }
    
    // MARK: - Binding
    private func bind() {
        searchPlaceView.setupDI(placeSelectedRelay)
        
        titleField.rx.text
            .map{ $0 != "" }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        titleField.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let `self` = self else { return }
                self.saveButton.alpha = text == "" ? 0.6 : 1
                self.saveButton.backgroundColor = text == "" ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            }).disposed(by: disposeBag)
        
        placeSelectedRelay.subscribe(onNext: { [weak self] place in
            guard let `self` = self else { return }
            self.searchPlaceView.isHidden = true
            self.placeField.text = place.place_name
            self.selectedPlace = place
        }).disposed(by: disposeBag)
        
        placeField.rx.text
            .subscribe(onNext: { [weak self] text in
                guard let `self` = self else { return }
                self.searchButton.isEnabled = text != ""
                self.searchButton.backgroundColor = text == "" ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            }).disposed(by: disposeBag)
        
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                PlaceSearchService.shared.searchPlace(place: self.placeField.text ?? "")
                self.searchPlaceView.isHidden = false
                self.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Clear Date
    private func clearData() {
        self.titleField.text = nil
    }
    
    // MARK: - AddEventViewControllable
    func updatePickerDate(date: Date?) {
        if let date = date {
            datePicker.date = date
        }
    }
    
    // MARK: - Methods
    private func changeColor(tag: Int, btn: UIButton) {
        guard let _ = self.currentBtn else { return }
        self.currentBtn!.backgroundColor = #colorLiteral(red: 0.9464568496, green: 0.9583716989, blue: 0.9581621289, alpha: 1)
        btn.backgroundColor = .lightGray
        self.currentBtn! = btn
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        searchPlaceView.isHidden = true
    }
}
