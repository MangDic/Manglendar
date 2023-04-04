//
//  AppDelegate.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        
        let vc = SchedularViewController()
        window.backgroundColor = .white
        window.rootViewController = vc
        window.makeKeyAndVisible()
        return true
    }
}

