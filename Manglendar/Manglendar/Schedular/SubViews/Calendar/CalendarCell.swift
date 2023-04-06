//
//  CalendarCell.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/04.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    static let identifier = "CalendarCell"
    
    lazy var contentStack = UIStackView().then {
        $0.spacing = 3
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    lazy var dayLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7304589095, blue: 0.6792636578, alpha: 1)
        $0.textColor = .white
    }
    
    lazy var moreDescriptionLabel = UILabel().then {
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        $0.textColor = .white
        $0.layer.cornerRadius = 8
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = ""
        moreDescriptionLabel.text = ""
        moreDescriptionLabel.isHidden = true
        removeEvents()
    }
    
    func configure(date: String, isToday: Bool = false) {
        dayLabel.text = isToday ? "오늘" : date
        contentStack.layer.borderColor = date == "" ? #colorLiteral(red: 0.9633767737, green: 0.9633767737, blue: 0.9633767737, alpha: 1) : #colorLiteral(red: 0.8794001822, green: 0.8794001822, blue: 0.8794001822, alpha: 1)
        contentStack.backgroundColor = date == "" ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0) : #colorLiteral(red: 0.9766330912, green: 0.9766330912, blue: 0.9766330912, alpha: 1)
        layer.borderColor = isToday ? #colorLiteral(red: 0.9584831547, green: 0.03299645901, blue: 0.402612538, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0)
    }
    
    func addEvents(_ events: [ScheduleEvent]) {
        let colorArr = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
        moreDescriptionLabel.isHidden = events.count < 4
        
        for (i, event) in events.enumerated() {
            if i == 3 {
                moreDescriptionLabel.text = "+\(events.count-3)"
                break
            }
            let rand = Int.random(in: 0...colorArr.count-1)
            let label = UILabel()
            label.backgroundColor = colorArr[rand]
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            label.text = event.title
            
            contentStack.addArrangedSubview(label)
            
            label.snp.makeConstraints {
                $0.height.equalTo((contentView.frame.height - dayLabel.frame.height) / 3 - 12)
            }
        }
    }
    
    private func setupLayout() {
        layer.borderWidth = 1
        let bottomSpacingView = UIView()
        
        addSubview(dayLabel)
        addSubview(contentStack)
        addSubview(bottomSpacingView)
        addSubview(moreDescriptionLabel)
        
        dayLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview()
        }
        
        bottomSpacingView.snp.makeConstraints {
            $0.top.equalTo(contentStack.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        moreDescriptionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: 30, height: 18))
        }
    }
    
    private func removeEvents() {
        // 셀에서 이벤트 라벨 제거
        for subview in contentStack.arrangedSubviews {
            contentStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
