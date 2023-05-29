//
//  HomeThemeTests.swift
//  GitHubAppTests
//
//  Created by Renato Bueno on 28/05/23.
//

import XCTest
@testable import GitHubApp

final class HomeThemeTests: XCTestCase {

    func testDefaultTheme() {
        let theme = UserViewDefaultTheme()
        XCTAssertEqual(theme.titleLabelHeight, 22)
        XCTAssertEqual(theme.spacing, 4)
        XCTAssertEqual(theme.titleLabelFont, UIFont.systemFont(ofSize: 16, weight: .semibold))
        XCTAssertEqual(theme.imageContentMode, .scaleAspectFit)
        XCTAssertEqual(theme.stackSpacing, 8)
    }
    
    func testDetailViewUsageTheme() {
        let theme = UserViewDetailTheme()
        XCTAssertEqual(theme.titleLabelHeight, 22)
        XCTAssertEqual(theme.spacing, 4)
        XCTAssertEqual(theme.titleLabelFont, UIFont.systemFont(ofSize: 16, weight: .semibold))
        XCTAssertEqual(theme.imageContentMode, .scaleAspectFill)
        XCTAssertEqual(theme.stackSpacing, 8)
    }
}
