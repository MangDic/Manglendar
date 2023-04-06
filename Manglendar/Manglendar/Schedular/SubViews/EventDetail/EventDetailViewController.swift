//
//  EventDetailViewController.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift

protocol EventDetailPresentableListener: AnyObject {
    var eventsRelay: BehaviorRelay<[ScheduleEvent]> { get }
    func didTapAddButton()
}

final class EventDetailViewController: UIViewController, EventDetailPresentable, EventDetailViewControllable {

    weak var listener: EventDetailPresentableListener?
    
    var disposeBag = DisposeBag()
    
    lazy var contentView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
    }
    
    lazy var dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    lazy var emptyDescriptionLabel = UILabel().then {
        $0.text = "일정이 없습니다 :("
        $0.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.isHidden = true
        $0.isScrollEnabled = false
        $0.rowHeight = UITableView.automaticDimension
        $0.register(EventsDetailCell.self, forCellReuseIdentifier: EventsDetailCell.id)
    }
    
    lazy var addEventButton = UIButton().then {
        $0.setTitle("일정 추가", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.listener?.didTapAddButton()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
    
    private func setupLayout() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7016903707)
        view.addSubview(contentView)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(addEventButton)
        contentView.addSubview(emptyDescriptionLabel)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        addEventButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(40)
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
    }
    
    private func bind() {
        listener?.eventsRelay.bind(to: tableView.rx.items(cellIdentifier: EventsDetailCell.id)) { row, item, cell in
            guard let cell = cell as? EventsDetailCell else { return }
            cell.selectionStyle = .none
            cell.configure(data: item)
        }.disposed(by: disposeBag)
        
        listener?.eventsRelay.subscribe(onNext: { [weak self] data in
            guard let `self` = self else { return }
            self.emptyDescriptionLabel.isHidden = data.count != 0
            self.tableView.isHidden = data.count == 0
        }).disposed(by: disposeBag)
    }
    
    // 동적 테이블뷰 높이 업데이트
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let h = tableView.contentSize.height
        if h != 0 {
            tableView.snp.updateConstraints {
                $0.height.equalTo(h)
            }
        }
    }
    
    func setDateLabel(date: Date) {
        dateLabel.text = date.convertDateToTitle()
    }
}
