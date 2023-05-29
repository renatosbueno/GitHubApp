//
//  HomeUserInteractor.swift
//  GitHubApp
//
//  Created by Renato Bueno on 25/05/23.
//

final class HomeUserInteractor {
    
    // MARK: - VIPER Properties

    weak var output: HomeUserInteractorOutputProtocol?

    // MARK: - Private Properties
    private let requestable: NetworkerProtocol
    
    init(requestable: NetworkerProtocol) {
        self.requestable = requestable
    }

    // MARK: - Internal Methods
    
    // MARK: - Private Methods 
}

// MARK: - Input Protocol
extension HomeUserInteractor: HomeUserInteractorInputProtocol {
    
    func fetchUsers() {
        let endpoint = UserEndpoint()
        requestable.request(endpoint: endpoint, type: [User].self) { [weak self] result in
            switch result {
            case .success(let object):
                guard let object = object else {
                    return
                }
                self?.output?.didFinishRequest(data: object)
                
            case .failure(let error):
                self?.output?.shouldShowError(errorType: error)
            }
        }
    }
}

struct UserEndpoint: NetworkEndpoint {
    
    var path: String {
        return "users"
    }
}
