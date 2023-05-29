import Foundation

final class UserDetailInteractor {
    
    // MARK: - VIPER Properties

    weak var output: UserDetailInteractorOutputProtocol?

    // MARK: - Private Properties
    private let requestable: NetworkerProtocol
    private let username: String
    private lazy var requestFacade: UserDetailsRequestFacade = {
       return UserDetailsRequestFacade(requestable: requestable, username: username)
    }()
    
    init(requestable: NetworkerProtocol, username: String) {
        self.requestable = requestable
        self.username = username
    }

    // MARK: - Internal Methods
    
    // MARK: - Private Methods 
}

// MARK: - Input Protocol
extension UserDetailInteractor: UserDetailInteractorInputProtocol {
    
    func fetchUserDetailedInfo() {
        requestFacade.fetch { [weak self] result in
            switch result {
            case .success(let data):
                guard let userDetailedInfo = data else {
                    self?.output?.didFinishWithError(errorType: .error(code: .unkown))
                    return
                }
                self?.output?.didFinishWithSucceess(data: userDetailedInfo)
            case .failure(let failure):
                self?.output?.didFinishWithError(errorType: failure)
            }
        }
    }

}
