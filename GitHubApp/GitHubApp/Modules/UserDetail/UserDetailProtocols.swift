// MARK: - ViewController
protocol UserDetailPresenterOutputProtocol: AnyObject {
    func didFinishWithSuccess(dataSource: UserDetailDataSource.DataSource)
    func shouldShowError(message: String, actionTitle: String)
    func toggleLoading()
}

// MARK: - Presenter
protocol UserDetailPresenterInputProtocol: AnyObject {
    func loadData()
    func getNavigationTitle() -> String
}

// MARK: - Interactor
protocol UserDetailInteractorInputProtocol: AnyObject {
    func fetchUserDetailedInfo()
}

protocol UserDetailInteractorOutputProtocol: AnyObject {
    func didFinishWithSucceess(data: AgroupedUserDetailData)
    func didFinishWithError(errorType: NetworkErrorType)
}

// MARK: - Router
protocol UserDetailRouterProtocol: AnyObject {
}
