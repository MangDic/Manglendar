//
//  CommingEventListView.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class CommingEventListView: UIView {
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    var events = BehaviorRelay<[ScheduleEvent]>(value: [])
    /// 다가오는 일정 셀 클릭 이벤트
    var selectedEventRelay = PublishRelay<ScheduleEvent>()
    
    // MARK: Views
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.text = R.String.CommingEventList.title
        $0.textColor = #colorLiteral(red: 0.6575845101, green: 0.6575845101, blue: 0.6575845101, alpha: 1)
        $0.textAlignment = .left
    }
    
    let flowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(CommingListCell.self, forCellWithReuseIdentifier: CommingListCell.id)
    }
    
    lazy var dataEmptyDescriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.text = R.String.CommingEventList.dataEmptyDescription
        $0.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Dependency Injection
    func setupDI(_ commingEventsRelay: BehaviorRelay<[ScheduleEvent]>?) -> Self {
        commingEventsRelay?.bind(to: events).disposed(by: disposeBag)
        return self
    }
    
    func setupDI(_ selectedEventRelay: PublishRelay<ScheduleEvent>) {
        self.selectedEventRelay.bind(to: selectedEventRelay).disposed(by: disposeBag)
    }
    
    // MARK: Setup Layout
    private func setupLayout() {
        addSubviews([titleLabel, collectionView, dataEmptyDescriptionLabel])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        dataEmptyDescriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - Binding
    private func bind() {
        events.bind(to: collectionView.rx.items(cellIdentifier: CommingListCell.id)) { index, item, cell in
            guard let cell = cell as? CommingListCell else { return }
            cell.configure(event: item)
        }.disposed(by: disposeBag)
        
        events.subscribe(onNext: { [weak self] data in
            guard let `self` = self else { return }
            self.collectionView.isHidden = data.count == 0
            self.titleLabel.isHidden = data.count == 0
            self.dataEmptyDescriptionLabel.isHidden = data.count != 0
        }).disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(ScheduleEvent.self)
            .subscribe(onNext: { [weak self] item in
                guard let `self` = self else { return }
                self.selectedEventRelay.accept(item)
            }).disposed(by: disposeBag)
    }
}
