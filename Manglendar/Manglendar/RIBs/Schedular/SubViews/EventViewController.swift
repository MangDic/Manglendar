//
//  EventViewController.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/07.
//
import UIKit

class EventViewController: UIViewController {
    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        
    }
}
