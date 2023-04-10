//
//  CalendarCell.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/04.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "CalendarCell"
    
    // MARK: - Views
    lazy var contentStack = UIStackView().then {
        $0.spacing = 2
        $0.axis = .vertical
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
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = ""
        moreDescriptionLabel.text = ""
        moreDescriptionLabel.isHidden = true
        removeEvents()
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        layer.borderWidth = 1
        let bottomSpacingView = UIView()
        
        contentView.addSubviews([dayLabel,
                     contentStack,
                     bottomSpacingView,
                     moreDescriptionLabel])
        
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
    
    // MARK: - Configure
    func configure(date: String, isToday: Bool = false) {
        dayLabel.text = isToday ? R.String.Calendar.today : date
        contentView.backgroundColor = date == "" ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0) : #colorLiteral(red: 0.9766330912, green: 0.9766330912, blue: 0.9766330912, alpha: 1)
        layer.borderColor = isToday ? #colorLiteral(red: 0.9584831547, green: 0.03299645901, blue: 0.402612538, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0)
    }
    
    // MARK: Methods
    /// 셀에 일정들을 추가. 최대 3개까지만 출력되며 넘어가면 그 수만큼 텍스트 출력
    func addEvents(_ events: [ScheduleEvent]) {
        moreDescriptionLabel.isHidden = events.count < 4
        
        for (i, event) in events.enumerated() {
            if i == 3 {
                moreDescriptionLabel.text = R.String.Calendar.eventCount(events.count-3)
                break
            }
            let backgroundView = UIView().then {
                $0.backgroundColor = R.Color.colorArr[event.color]
            }
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            label.text = event.title
            contentStack.addArrangedSubview(backgroundView)
            backgroundView.addSubview(label)
            label.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(2)
            }
        }
    }
    
    /// 셀에서 이벤트 라벨 제거
    private func removeEvents() {
        for subview in contentStack.arrangedSubviews {
            contentStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
