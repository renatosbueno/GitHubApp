//
//  GitHubAppTests.swift
//  GitHubAppTests
//
//  Created by Renato Bueno on 28/05/23.
//

import XCTest
@testable import GitHubApp

final class HomeModuleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testItemSelection() {
        let router = HomeUserRouterSpy()
        
        let interactor = HomeUserInteractor(requestable: MockNetworker())
        let presenter = HomeUserPresenter(router: router, interactor: interactor)
        interactor.output = presenter
        
        presenter.fetchData()
        let exp = expectation(description: "Test after 1 second because of request")
        XCTWaiter().wait(for: [exp], timeout: 1.0)
        
        presenter.didSelectItem(id: 28)
        XCTAssertTrue(router.showUserDetailCalled)
        XCTAssertEqual(router.usernameResult, "roland")
    }
    
    func testSuccessfulViewSpy() {
        let router = HomeUserRouterSpy()
        
        let interactor = HomeUserInteractor(requestable: MockNetworker())
        let presenter = HomeUserPresenter(router: router, interactor: interactor)
        let viewSpy = HomeUserViewControllerSpy()
        interactor.output = presenter
        presenter.viewController = viewSpy
        
        presenter.fetchData()
        let exp = expectation(description: "Test after 2 seconds because of request")
        XCTWaiter().wait(for: [exp], timeout: 2.0)
        
        XCTAssertTrue(viewSpy.toggleLoadingCalled)
        XCTAssertTrue(viewSpy.didFinishRequestCalled)
        
        XCTAssertFalse(viewSpy.shouldShowErrorCalled)
        
        XCTAssertEqual(viewSpy.dataSourceResult.first, HomeUserDataSource.DataSource(id: 1, user: "mojombo", imagePath: "https://avatars.githubusercontent.com/u/1?v=4", isLoading: false))
    }
    
    func testErrorViewSpy() {
        let router = HomeUserRouterSpy()
        
        let interactor = HomeUserInteractor(requestable: MockFailingNetworker())
        let presenter = HomeUserPresenter(router: router, interactor: interactor)
        let viewSpy = HomeUserViewControllerSpy()
        interactor.output = presenter
        presenter.viewController = viewSpy
        
        presenter.fetchData()
        
        XCTAssertTrue(viewSpy.toggleLoadingCalled)
        XCTAssertFalse(viewSpy.didFinishRequestCalled)
        
        XCTAssertTrue(viewSpy.dataSourceResult.isEmpty)
        XCTAssertTrue(viewSpy.shouldShowErrorCalled)
        XCTAssertEqual(viewSpy.errorStrings.message, "Ops, something went wrong")
        XCTAssertEqual(viewSpy.errorStrings.actionTitle, "try again")
    }
    
    func testSearchText() {
        let router = HomeUserRouterSpy()
        
        let interactor = HomeUserInteractor(requestable: MockNetworker())
        let presenter = HomeUserPresenter(router: router, interactor: interactor)
        let viewSpy = HomeUserViewControllerSpy()
        interactor.output = presenter
        presenter.viewController = viewSpy
        
        presenter.fetchData()
        let exp = expectation(description: "Test after 1 second because of request")
        XCTWaiter().wait(for: [exp], timeout: 1.0)
        
        presenter.filterUsers(searchText: "moj")
        XCTAssertTrue(viewSpy.didFinishRequestCalled)
        XCTAssertEqual(viewSpy.dataSourceResult.count, 2)
        
        presenter.filterUsers(searchText: String())
        
        XCTAssertTrue(viewSpy.didFinishRequestCalled)
        XCTAssertEqual(viewSpy.dataSourceResult.count, 30)
    }

}
// MARK: - HomeUserRouterSpy
fileprivate final class HomeUserRouterSpy: HomeUserRouterProtocol {
    
    private(set) var showUserDetailCalled: Bool = false
    private(set) var usernameResult: String = String()
    
    func showUserDetail(username: String) {
        showUserDetailCalled = true
        usernameResult = username
    }
    
}

// MARK: - HomeUserViewControllerSpy
fileprivate final class HomeUserViewControllerSpy: HomeUserPresenterOutputProtocol {
    
    private(set) var didFinishRequestCalled = false
    private(set) var dataSourceResult = [HomeUserDataSource.DataSource]()
    
    private(set) var toggleLoadingCalled = false
    
    private(set) var shouldShowErrorCalled = false
    private(set) var errorStrings = (message: String(), actionTitle: String())
    
    func didFinishRequest(dataSource: [GitHubApp.HomeUserDataSource.DataSource]) {
        didFinishRequestCalled = true
        dataSourceResult = dataSource
    }
    
    func toggleLoading() {
        toggleLoadingCalled = true
    }
    
    func shouldShowError(message: String, actionTitle: String) {
        shouldShowErrorCalled = true
        errorStrings = (message: message, actionTitle: actionTitle)
    }
}

