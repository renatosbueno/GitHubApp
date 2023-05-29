//
//  UserDetailModuleTests.swift
//  GitHubAppTests
//
//  Created by Renato Bueno on 28/05/23.
//

import XCTest
@testable import GitHubApp

final class UserDetailModuleTests: XCTestCase {
    
    private var username = "roland"

    override func setUp() {
        super.setUp()
        
    }
    
    func testSucessfullFlow() {
        let interactor = UserDetailInteractor(requestable: MockNetworker(), username: username)
        let presenter = UserDetailPresenter(router: UserDetailRouter(), interactor: interactor)
        interactor.output = presenter
        let viewSpy = UserDetailViewSpy()
        presenter.viewController = viewSpy
        
        presenter.loadData()
        let exp = expectation(description: "Test after 2 seconds because of request")
        XCTWaiter().wait(for: [exp], timeout: 2.0)
        
        XCTAssertTrue(viewSpy.toggleLoadingCalled)
        XCTAssertTrue(viewSpy.didFinishWithSuccessCalled)
        XCTAssertFalse(viewSpy.shouldShowErrorCalled)
        
        XCTAssertEqual(presenter.getNavigationTitle(), username)
        
        XCTAssertEqual(viewSpy.dataSourceResult?.userDetail, UserDetailInfo(avatarUrl: "https://avatars.githubusercontent.com/u/28?v=4", login: username, location: "Tirana", name: "Roland Guy", id: 28, followers: 22))
        
        XCTAssertEqual(viewSpy.dataSourceResult?.userRepos.first, UserRepoData(id: 26899533, forksCount: 4, stargazersCount: 7, name: "30daysoflaptops.github.io", language: "CSS"))
        XCTAssertEqual(viewSpy.dataSourceResult?.userRepos.count, 30)
    }
    
    func testErrorFlow() {
        let interactor = UserDetailInteractor(requestable: MockFailingNetworker(), username: username)
        let presenter = UserDetailPresenter(router: UserDetailRouter(), interactor: interactor)
        interactor.output = presenter
        let viewSpy = UserDetailViewSpy()
        presenter.viewController = viewSpy
        
        presenter.loadData()
        
        XCTAssertTrue(viewSpy.toggleLoadingCalled)
        XCTAssertFalse(viewSpy.didFinishWithSuccessCalled)
        
        XCTAssertTrue(presenter.getNavigationTitle().isEmpty)
        
        XCTAssertNil(viewSpy.dataSourceResult?.userDetail)
        XCTAssertNil(viewSpy.dataSourceResult?.userRepos)
        
        XCTAssertTrue(viewSpy.shouldShowErrorCalled)
        XCTAssertEqual(viewSpy.errorStrings.message, "Ops, something went wrong")
        XCTAssertEqual(viewSpy.errorStrings.actionTitle, "try again")
    }

}

fileprivate final class UserDetailViewSpy: UserDetailPresenterOutputProtocol {
    
    private(set) var didFinishWithSuccessCalled = false
    private(set) var dataSourceResult: UserDetailDataSource.DataSource?
    
    private(set) var toggleLoadingCalled = false
    
    private(set) var shouldShowErrorCalled = false
    private(set) var errorStrings = (message: String(), actionTitle: String())
    
    func didFinishWithSuccess(dataSource: GitHubApp.UserDetailDataSource.DataSource) {
        didFinishWithSuccessCalled = true
        dataSourceResult = dataSource
    }
    
    func shouldShowError(message: String, actionTitle: String) {
        shouldShowErrorCalled = true
        errorStrings = (message: message, actionTitle: actionTitle)
    }
    
    func toggleLoading() {
        toggleLoadingCalled = true
    }
        
}
