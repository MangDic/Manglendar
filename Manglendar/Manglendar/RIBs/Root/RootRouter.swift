//
//  RootRouter.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/05.
//

import RIBs

protocol RootInteractable: Interactable {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func push(viewControllable: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    let schedularBuilder: SchedularBuilder
    
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         schedularBuilder: SchedularBuilder) {
        self.schedularBuilder = schedularBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        pushSchedularScreen()
    }
    
    private func pushSchedularScreen() {
        let schedularRouter = schedularBuilder.build()
        attachChild(schedularRouter)
        viewController.push(viewControllable: schedularRouter.viewControllable)
    }
}
