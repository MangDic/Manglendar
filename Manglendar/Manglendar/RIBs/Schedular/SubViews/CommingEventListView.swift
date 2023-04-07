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
    var disposeBag = DisposeBag()
    
    var events = BehaviorRelay<[ScheduleEvent]>(value: [])
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.text = R.String.CommingEventList.title
        $0.textColor = #colorLiteral(red: 0.6575845101, green: 0.6575845101, blue: 0.6575845101, alpha: 1)
        $0.textAlignment = .left
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.register(TodoListCell.self, forCellWithReuseIdentifier: TodoListCell.id)
    }
    
    lazy var dataEmptyDescriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.text = R.String.CommingEventList.dataEmptyDescription
        $0.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func setupDI(_ commingEventsRelay: BehaviorRelay<[ScheduleEvent]>?) {
        commingEventsRelay?.bind(to: events).disposed(by: disposeBag)
    }
    
    private func bind() {
        events.bind(to: collectionView.rx.items(cellIdentifier: TodoListCell.id)) { index, item, cell in
            guard let cell = cell as? TodoListCell else { return }
            cell.configure(event: item)
        }.disposed(by: disposeBag)
        
        events.subscribe(onNext: { [weak self] data in
            guard let `self` = self else { return }
            self.collectionView.isHidden = data.count == 0
            self.titleLabel.isHidden = data.count == 0
            self.dataEmptyDescriptionLabel.isHidden = data.count != 0
        }).disposed(by: disposeBag)
    }
    
    /// 셀 높이에 맞춰 컬렉션뷰 높이를 업데이트 합니다.
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
        
        return layout
    }
}

class TodoListCell: UICollectionViewCell {
    static let id = "TodoListCell"
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7857435958, blue: 0.7203170327, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    lazy var dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(event: ScheduleEvent) {
        dateLabel.text = event.date.convertDateToString(type: .comming)
        titleLabel.text = event.title
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview().inset(10)
        }
    }
}
