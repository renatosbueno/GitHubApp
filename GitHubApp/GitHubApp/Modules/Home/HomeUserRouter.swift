//
//  HomeUserRouter.swift
//  GitHubApp
//
//  Created by Renato Bueno on 25/05/23.
//

import UIKit

final class HomeUserRouter {
        
    // MARK: - VIPER Properties
    
    weak var viewController: UIViewController?
    var requestable: NetworkerProtocol
    
    init(requestable: NetworkerProtocol) {
        self.requestable = requestable
    }
}

// MARK: - Router Protocol
extension HomeUserRouter: HomeUserRouterProtocol {
    
    func showUserDetail(username: String) {
        let detailController = UserDetailConfigurator(requestable: requestable).createModule(username: username)
        viewController?.navigationController?.pushViewController(detailController, animated: true)
    }
}
