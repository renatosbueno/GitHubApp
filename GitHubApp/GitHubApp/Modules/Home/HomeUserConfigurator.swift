//
//  HomeUserConfigurator.swift
//  GitHubApp
//
//  Created by Renato Bueno on 25/05/23.
//

import UIKit

public protocol HomeUserConfiguratorProtocol: AnyObject {
    func createModule() -> UIViewController
}

public final class HomeUserConfigurator: HomeUserConfiguratorProtocol {
    
    private let requestable: NetworkerProtocol
    
    init(requestable: NetworkerProtocol) {
        self.requestable = requestable
    }

    public func createModule() -> UIViewController {
        let router = HomeUserRouter(requestable: requestable)
        let interactor = HomeUserInteractor(requestable: requestable)
        let presenter = HomeUserPresenter(router: router, interactor: interactor)
        interactor.output = presenter
        let viewController = HomeUserViewController(
            presenter: presenter
        )
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
