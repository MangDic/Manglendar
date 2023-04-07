//
//  AppComponent.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
