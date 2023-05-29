//
//  HomeUserProtocols.swift
//  GitHubApp
//
//  Created by Renato Bueno on 25/05/23.
//

// MARK: - ViewController
protocol HomeUserPresenterOutputProtocol: AnyObject {
    func didFinishRequest(dataSource: [HomeUserDataSource.DataSource])
    func toggleLoading()
    func shouldShowError(message: String, actionTitle: String)
}

// MARK: - Presenter
protocol HomeUserPresenterInputProtocol: AnyObject {
    func fetchData()
    func didSelectItem(id: Int)
    func filterUsers(searchText: String)
}

// MARK: - Interactor
protocol HomeUserInteractorInputProtocol: AnyObject {
    func fetchUsers()
}

protocol HomeUserInteractorOutputProtocol: AnyObject {
    func didFinishRequest(data: [User])
    func shouldShowError(errorType: NetworkErrorType)
}

// MARK: - Router
protocol HomeUserRouterProtocol: AnyObject {
    func showUserDetail(username: String)
}
