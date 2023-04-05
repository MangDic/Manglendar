//
//  CalendarView.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class CalendarView: UIView {
    var disposeBag = DisposeBag()
    
    var selectedRelay = PublishRelay<[ScheduleEvent]>()
    
    private let daysPerWeek = 7
    private let totalGrids = 42
    private var daysInMonth = [Int]()
    
    private var currentMonthIndex: Int = 0
    private var currentYear: Int = 0
    
    private var calendar = Calendar.current
    
    private let months = Array(1...12)
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private var selectedDate: Date?
    var events: [String: [ScheduleEvent]] = [:]
    
    private lazy var monthLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private lazy var nextMonthButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        $0.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.currentMonthIndex += 1
            if self.currentMonthIndex > 11 {
                self.currentMonthIndex = 0
                self.currentYear += 1
            }
            self.updateCalendar()
        }).disposed(by: disposeBag)
    }
    
    private lazy var prevMonthButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        $0.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.currentMonthIndex -= 1
            if self.currentMonthIndex < 0 {
                self.currentMonthIndex = 11
                self.currentYear -= 1
            }
            self.updateCalendar()
        }).disposed(by: disposeBag)
    }
    
    lazy var layout = UICollectionViewFlowLayout().then {
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }
    
    private lazy var gridView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupDI(_ selectedRelay: PublishRelay<[ScheduleEvent]>) {
        self.selectedRelay.bind(to: selectedRelay).disposed(by: disposeBag)
    }
    
    private func setupView() {
        let daysOfWeekStackView = createDayOfWeekLabels()
        addSubview(prevMonthButton)
        addSubview(monthLabel)
        addSubview(nextMonthButton)
        addSubview(daysOfWeekStackView)
        addSubview(gridView)
        initCalendar()
        
        monthLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        prevMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        nextMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        daysOfWeekStackView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
        gridView.snp.makeConstraints {
            $0.top.equalTo(daysOfWeekStackView.snp.bottom)
            $0.leading.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func createDayOfWeekLabels() -> UIStackView {
        let stackView = UIStackView()
        stackView.backgroundColor = #colorLiteral(red: 0.9486155907, green: 0.9486155907, blue: 0.9486155907, alpha: 1)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        for (i, day) in daysOfWeek.enumerated() {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            label.textColor = .black
            if i == 0 { label.textColor = .red }
            if i == daysOfWeek.count - 1 { label.textColor = .blue }
            stackView.addArrangedSubview(label)
        }
        
        return stackView
    }
    
    private func initCalendar() {
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? calendar.timeZone
        currentMonthIndex = calendar.component(.month, from: Date()) - 1
        currentYear = calendar.component(.year, from: Date())
        
        monthLabel.text = "\(currentYear)년 \(months[currentMonthIndex])월"
        calculateDaysInMonth()
        gridView.reloadData()
    }
    
    private func calculateDaysInMonth() {
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? calendar.timeZone
        for month in months {
            let date = "\(month)/01/\(currentYear)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = calendar.timeZone
            if let firstDateOfMonth = dateFormatter.date(from: date) {
                let days = calendar.range(of: .day, in: .month, for: firstDateOfMonth)!.count
                daysInMonth.append(days)
            } else {
                print("Error: Unable to create date from string.")
            }
        }
    }
    
    func updateCalendar() {
        monthLabel.text = "\(currentYear)년 \(months[currentMonthIndex])월"
        gridView.reloadData()
    }
}

extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalGrids
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let firstDayOfMonth = calculateFirstDayOfMonth()
        let day = indexPath.item - firstDayOfMonth + 1
        if indexPath.item < firstDayOfMonth || day > daysInMonth[currentMonthIndex] {
            cell.configure(date: "")
        }
        else {
            cell.configure(date: "\(day)", isToday: isToday(year: currentYear, month: currentMonthIndex + 1, day: day))
            
            let key = "\(currentYear)\(currentMonthIndex + 1)\(day)"
            if let events = events[key], !events.isEmpty {
                cell.addEvents(events)
            }
        }
        return cell
    }
    
    private func calculateFirstDayOfMonth() -> Int {
        let dateComponents = DateComponents(year: currentYear, month: currentMonthIndex + 1)
        let date = calendar.date(from: dateComponents)!
        let firstDay = calendar.component(.weekday, from: date) + 1
        let firstDayOfMonth = (firstDay + 5) % 7
        return firstDayOfMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
        
        let firstDayOfMonth = calculateFirstDayOfMonth()
        let day = indexPath.item - firstDayOfMonth + 1
        if day > 0 && day <= daysInMonth[currentMonthIndex] {
            let selectedDateComponents = DateComponents(year: currentYear, month: currentMonthIndex + 1, day: day)
            selectedDate = calendar.date(from: selectedDateComponents)
            let event = events["\(currentYear)\(currentMonthIndex + 1)\(day)"] ?? []
            selectedRelay.accept(event)
        } else {
            selectedDate = nil
        }
    }
    
    func isToday(year: Int, month: Int, day: Int) -> Bool {
        let today = Date()
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        return todayComponents.year ?? 0 == year
            && todayComponents.month ?? 0 == month
            && todayComponents.day ?? 0 == day
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(daysPerWeek)
        let height = collectionView.frame.height / CGFloat((totalGrids / daysPerWeek))
        return CGSize(width: width, height: height)
    }
}
