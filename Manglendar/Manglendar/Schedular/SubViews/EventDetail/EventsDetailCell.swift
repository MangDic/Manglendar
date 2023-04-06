//
//  EventsDetailCell.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/04.
//

import UIKit
import RxCocoa
import RxSwift

class EventsDetailCell: UITableViewCell {
    static let id = "EventsDetailCell"
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7978581524, blue: 0.7656132604, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var placeLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.text = "장소 : 등록한 장소가 없습니다."
    }
    
    lazy var timeLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.text = "시간 : 등록한 시간이 없습니다."
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: ScheduleEvent) {
        titleLabel.text = data.title
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(placeLabel)
        containerView.addSubview(timeLabel)
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(10)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(10)
            $0.leading.bottom.trailing.equalToSuperview().inset(10)
        }
    }
}
