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
        $0.text = R.String.EventDetail.placeEmpty
    }
    
    lazy var timeLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.text = R.String.EventDetail.timeEmpty
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: ScheduleEvent) {
        let timeValue = data.date.getTimeValue()
        
        containerView.backgroundColor = R.Color.colorArr[data.color]
        titleLabel.text = data.title
        timeLabel.text = R.String.EventDetail.time(timeValue.0, timeValue.1)
        placeLabel.text = data.place == "" ? R.String.EventDetail.placeEmpty : R.String.EventDetail.place(data.place)
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews([titleLabel, placeLabel, timeLabel])
        
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
