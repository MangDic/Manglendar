//
//  EventViewController.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/10.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol EventViewPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapDeleteButton(event: ScheduleEvent)
    func didTapEditButton(event: ScheduleEvent)
}

final class EventViewController: UIViewController, EventViewPresentable, EventViewViewControllable {
    
    weak var listener: EventViewPresentableListener?
    
    var disposeBag = DisposeBag()
    var event: ScheduleEvent?
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var backbutton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.listener?.didTapBackButton()
        }).disposed(by: disposeBag)
    }
    
    lazy var dateLabel = UILabel().then {
        $0.textColor = #colorLiteral(red: 0.6242372399, green: 0.6242372399, blue: 0.6242372399, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = #colorLiteral(red: 0.6242372399, green: 0.6242372399, blue: 0.6242372399, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var placeLabel = UILabel().then {
        $0.textColor = #colorLiteral(red: 0.6242372399, green: 0.6242372399, blue: 0.6242372399, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    var navigationView: NavigationView?
    
    lazy var buttonStack = UIStackView().then {
        $0.spacing = 5
        $0.distribution = .fillEqually
    }
    
    lazy var deleteButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.setTitle(R.String.EventView.delete, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            guard let event = self.event else { return }
            
            let alertController = UIAlertController(title: R.String.EventView.deleteTitle,
                                                    message: R.String.EventView.deleteDescription,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: R.String.EventView.cancel,
                                             style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: R.String.EventView.delete,
                                             style: .destructive) { _ in
                self.listener?.didTapDeleteButton(event: event)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
    }
    
    
    lazy var editButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.setTitle(R.String.EventView.edit, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            guard let event = self.event else { return }
            self.listener?.didTapEditButton(event: event)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationView?.webView.stopLoading()
        navigationView = nil
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubviews([backbutton,
                          titleLabel,
                          dateLabel,
                          placeLabel,
                          buttonStack])
        
        buttonStack.addArrangedSubview(deleteButton)
        buttonStack.addArrangedSubview(editButton)
        
        backbutton.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backbutton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
        }
        
        buttonStack.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
    }
    
    // MARK: - EventViewViewControllable
    func updateEventData(event: ScheduleEvent) {
        self.event = event
        titleLabel.text = event.title
        dateLabel.text = event.date.convertDateToString(type: .comming)
        placeLabel.text = event.place == nil ? R.String.EventView.emptyPlace : event.place!.place_name
        
        if let placeData = event.place {
            navigationView = NavigationView(placeData: placeData)
            view.addSubview(navigationView!)
            navigationView!.snp.makeConstraints {
                $0.top.equalTo(placeLabel.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalTo(buttonStack.snp.top).offset(-10)
            }
        }
    }
}
