//
//  RootViewController.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {
    

    weak var listener: RootPresentableListener?
    
    func push(viewControllable: ViewControllable) {
        pushViewController(viewControllable.uiviewController, animated: false)
    }
}
