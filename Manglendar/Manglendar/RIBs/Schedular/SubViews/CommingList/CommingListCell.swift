//
//  CommingListCell.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/07.
//

import UIKit
import RxSwift

class CommingListCell: UICollectionViewCell {
    // MARK: Properties
    static let id = "CommingListCell"
    var disposeBag = DisposeBag()
    
    var onEditButtonTapped: () -> () = {}
    var onDeleteButtonTapped: () -> () = {}
    
    // MARK: Views
    lazy var containerView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7857435958, blue: 0.7203170327, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    lazy var dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    lazy var moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = #colorLiteral(red: 0.9693942666, green: 0.9693942666, blue: 0.9693942666, alpha: 1)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.menuStack.isHidden = !self.menuStack.isHidden
        }).disposed(by: disposeBag)
    }
    
    lazy var menuStack = UIStackView().then {
        $0.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.layer.borderWidth = 1
        $0.distribution = .fillEqually
        $0.backgroundColor = .white
        $0.isHidden = true
        $0.layer.cornerRadius = 4
        $0.spacing = 2
        $0.axis = .vertical
    }
    
    lazy var editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.menuStack.isHidden = true
            self.onEditButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    lazy var deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.setTitleColor(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), for: .normal)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.menuStack.isHidden = true
            self.onDeleteButtonTapped()
        }).disposed(by: disposeBag)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuStack.isHidden = true
    }
    
    // MARK: - Configure
    func configure(event: ScheduleEvent) {
        dateLabel.text = event.date.convertDateToString(type: .comming)
        titleLabel.text = event.title
        containerView.backgroundColor = R.Color.colorArr[event.color]
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews([dateLabel,
                                   moreButton,
                                   titleLabel,
                                   menuStack])
        menuStack.addArrangedSubview(editButton)
        menuStack.addArrangedSubview(deleteButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(10)
        }
        
        moreButton.snp.makeConstraints {
            $0.height.equalTo(dateLabel)
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview().inset(10)
        }
        
        menuStack.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom).offset(-2)
            $0.centerX.equalTo(moreButton)
            $0.size.equalTo(50)
        }
    }
}


