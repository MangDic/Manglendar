//
//  UIView+.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/07.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
