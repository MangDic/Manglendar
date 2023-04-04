//
//  TodoList.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class TodoListView: UIView {
    var disposeBag = DisposeBag()
    
    lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 150, height: 100)
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(TodoListCell.self, forCellWithReuseIdentifier: TodoListCell.id)
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
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
    }
    
    private func bind() {
        let data = BehaviorRelay<[String]>(value: [])
        data.accept(["", "", "", "", "", "", ""])
        data.bind(to: collectionView.rx.items(cellIdentifier: TodoListCell.id)) { index, item, cell in
            guard let cell = cell as? TodoListCell else { return }
        }.disposed(by: disposeBag)
    }
}

class TodoListCell: UICollectionViewCell {
    static let id = "TodoListCell"
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9980114506, green: 0.9358230085, blue: 0.8072304099, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
    }
}
