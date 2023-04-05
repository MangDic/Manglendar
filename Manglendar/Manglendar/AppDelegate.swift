//
//  AppDelegate.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/03.
//

import UIKit
import RIBs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var launchRouter: LaunchRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        return true
    }
}

