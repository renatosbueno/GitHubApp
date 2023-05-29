//
//  HomeUserPresenter.swift
//  GitHubApp
//
//  Created by Renato Bueno on 25/05/23.
//

import Foundation

final class HomeUserPresenter {
    
    // MARK: - Viper Properties
    
    weak var viewController: HomeUserPresenterOutputProtocol?
    private let router: HomeUserRouterProtocol
    private let interactor: HomeUserInteractorInputProtocol
    private var userData: [User] = []
    
    // MARK: - Internal Properties

    // MARK: - Private Properties
    
    // MARK: - Inits
    
    init(
        router: HomeUserRouterProtocol,
        interactor: HomeUserInteractorInputProtocol
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: - Internal Methods
    
    // MARK: - Private Methods
    
    private func getDataSource(data: [User]) -> [HomeUserDataSource.DataSource] {
        data.compactMap({ HomeUserDataSource.DataSource(id: $0.id, user: $0.login, imagePath: $0.avatarUrl, isLoading: false) })
    }
}

// MARK: - Input Protocol
extension HomeUserPresenter: HomeUserPresenterInputProtocol {
    
    func fetchData() {
        viewController?.toggleLoading()
        interactor.fetchUsers()
    }
    
    func didSelectItem(id: Int) {
        guard let selectedItem = userData.first(where: { $0.id == id }) else {
            return
        }
        router.showUserDetail(username: selectedItem.login)
    }
    
    func filterUsers(searchText: String) {
        guard searchText.count > 2 else {
            if searchText.isEmpty {
                viewController?.didFinishRequest(dataSource: getDataSource(data: userData))
            }
            return
        }
        let filtered = userData.filter({ $0.login.contains(searchText.lowercased()) })
        if !filtered.isEmpty {
            viewController?.didFinishRequest(dataSource: getDataSource(data: filtered))
        }
    }
}

// MARK: - Output Protocol
extension HomeUserPresenter: HomeUserInteractorOutputProtocol {
    
    func didFinishRequest(data: [User]) {
        userData = data
        let dataSource = getDataSource(data: data)
        
        viewController?.didFinishRequest(dataSource: dataSource)
    }
    
    func shouldShowError(errorType: NetworkErrorType) {
        viewController?.shouldShowError(message: Strings.ErrorMessage.title, actionTitle: Strings.ErrorMessage.actionTitle)
    }
}
