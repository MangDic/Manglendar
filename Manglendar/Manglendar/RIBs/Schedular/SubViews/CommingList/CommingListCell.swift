//
//  CommingListCell.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/07.
//

import UIKit

class CommingListCell: UICollectionViewCell {
    // MARK: Properties
    static let id = "CommingListCell"
    
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
    
    // MARK: - Configure
    func configure(event: ScheduleEvent) {
        dateLabel.text = event.date.convertDateToString(type: .comming)
        titleLabel.text = event.title
        containerView.backgroundColor = R.Color.colorArr[event.color]
    }
    
    // MARK: - Setup Layout
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
