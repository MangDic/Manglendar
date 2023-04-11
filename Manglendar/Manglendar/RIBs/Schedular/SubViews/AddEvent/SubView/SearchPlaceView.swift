//
//  SearchPlaceView.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/11.
//

import UIKit
import RxCocoa
import RxSwift

class SearchPlaceView: UIView {
    var disposeBag = DisposeBag()
    
    let placeSelectedRelay = PublishRelay<PlaceData>()
    
    lazy var tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.register(SearchPlaceCell.self, forCellReuseIdentifier: SearchPlaceCell.id)
        $0.isHidden = true
    }
    
    lazy var dataEmptyLabel = UILabel().then {
        $0.text = R.String.AddEvent.emptyPlaceDescription
        $0.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDI(_ placeSelectedRelay: PublishRelay<PlaceData>) {
        self.placeSelectedRelay.bind(to: placeSelectedRelay).disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.borderWidth = 2
        
        addSubviews([tableView, dataEmptyLabel])
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.bottom.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
        
        dataEmptyLabel.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
    }
    
    private func bind() {
        PlaceSearchService.shared.placeRelay
            .bind(to: tableView.rx.items(cellIdentifier: SearchPlaceCell.id)) { row, item, cell in
                guard let cell = cell as? SearchPlaceCell else { return }
                cell.configure(place: item)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PlaceData.self)
            .subscribe(onNext: { [weak self] item in
                guard let `self` = self else { return }
                self.placeSelectedRelay.accept(item)
            }).disposed(by: disposeBag)
        
        // 검색 결과 바인딩
        PlaceSearchService.shared.placeRelay.subscribe(onNext: { data in
            DispatchQueue.main.async {
                self.tableView.isHidden = data.count == 0
                self.dataEmptyLabel.isHidden = data.count != 0
                
                var h = self.tableView.contentSize.height == 0 ? 20 : self.tableView.contentSize.height
                h = h > 200 ? 200 : h
                self.tableView.snp.updateConstraints {
                    $0.height.equalTo(h)
                }
            }
        }).disposed(by: disposeBag)
    }
}

class SearchPlaceCell: UITableViewCell {
    static let id = "SearchPlaceCell"
    
    lazy var placeLabel = UILabel().then {
        $0.textColor = #colorLiteral(red: 0.5658581919, green: 0.5658581919, blue: 0.5658581919, alpha: 1)
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    lazy var addressLabel = UILabel().then {
        $0.textColor = #colorLiteral(red: 0.5658581919, green: 0.5658581919, blue: 0.5658581919, alpha: 1)
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    lazy var selectButton = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.layer.cornerRadius = 4
        $0.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.setTitle(R.String.AddEvent.select, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(place: PlaceData) {
        placeLabel.text = place.place_name
        addressLabel.text = place.address_name
    }
    
    private func setupLayout() {
        contentView.addSubviews([placeLabel,
                                 addressLabel,
                                 selectButton])
        
        placeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(selectButton.snp.leading).inset(10)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(selectButton.snp.leading).inset(10)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(15)
        }
        
        selectButton.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 20))
        }
    }
}
