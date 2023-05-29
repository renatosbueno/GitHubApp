import Foundation

final class UserDetailPresenter {
    
    // MARK: - Viper Properties
    
    weak var viewController: UserDetailPresenterOutputProtocol?
    private let router: UserDetailRouterProtocol
    private let interactor: UserDetailInteractorInputProtocol
    var data: AgroupedUserDetailData?
    
    // MARK: - Internal Properties

    // MARK: - Private Properties
    
    // MARK: - Inits
    
    init(
        router: UserDetailRouterProtocol,
        interactor: UserDetailInteractorInputProtocol
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: - Internal Methods
    
    // MARK: - Private Methods    
}

// MARK: - Input Protocol
extension UserDetailPresenter: UserDetailPresenterInputProtocol {
    
    func loadData() {
        viewController?.toggleLoading()
        interactor.fetchUserDetailedInfo()
    }
    
    func getNavigationTitle() -> String {
        return data?.userDetail.login ?? String()
    }
}

// MARK: - Output Protocol
extension UserDetailPresenter: UserDetailInteractorOutputProtocol {
    
    func didFinishWithSucceess(data: AgroupedUserDetailData) {
        self.data = data
        self.viewController?.didFinishWithSuccess(dataSource: data)
    }
    
    func didFinishWithError(errorType: NetworkErrorType) {
        viewController?.shouldShowError(message: Strings.ErrorMessage.title, actionTitle: Strings.ErrorMessage.actionTitle)
    }
    
}
