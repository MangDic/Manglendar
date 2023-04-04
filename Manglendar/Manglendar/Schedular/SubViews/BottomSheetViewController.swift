//
//  BottomSheetViewController.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/04.
//

import UIKit

class BottomSheetViewController: UIViewController {
    lazy var content = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupContent()
    }
    
    
    private func setupContent() {
        view.addSubview(content)
        
        content.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
    }
    // 백그라운드 터치로 닫기
    @objc private func handleBackgroundTap() {
        self.dismiss(animated: true, completion: nil)
    }
    // 아래로 드래그해서 닫기
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        if gesture.state == .changed, translation.y > 0 {
            content.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        
        if gesture.state == .ended {
            if translation.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.content.transform = .identity
                }
            }
        }
    }
}
