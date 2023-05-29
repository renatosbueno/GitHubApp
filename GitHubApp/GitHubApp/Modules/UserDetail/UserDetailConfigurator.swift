
import UIKit

public protocol UserDetailConfiguratorProtocol: AnyObject {
    func createModule(username: String) -> UIViewController
}

public final class UserDetailConfigurator: UserDetailConfiguratorProtocol {
    
    private let requestable: NetworkerProtocol
    
    init(requestable: NetworkerProtocol) {
        self.requestable = requestable
    }

    public func createModule(username: String) -> UIViewController {
        let router = UserDetailRouter()
        let interactor = UserDetailInteractor(requestable: requestable, username: username)
        let presenter = UserDetailPresenter(router: router, interactor: interactor)
        interactor.output = presenter
        let viewController = UserDetailViewController(
            presenter: presenter
        )
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
