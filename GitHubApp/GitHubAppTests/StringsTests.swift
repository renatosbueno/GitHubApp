//
//  StringsTests.swift
//  GitHubAppTests
//
//  Created by Renato Bueno on 28/05/23.
//

import XCTest
@testable import GitHubApp

final class StringsTests: XCTestCase {
    
    func test() {
        XCTAssertEqual(Strings.SFSymbolsStrings.fork, "tuningfork")
        XCTAssertEqual(Strings.SFSymbolsStrings.star, "star")
        
        XCTAssertEqual(Strings.UserDetailInfo.followersTitle, "Followers:")
        XCTAssertEqual(Strings.UserDetailInfo.locationTitle, "Location:")
        
        XCTAssertEqual(Strings.ErrorMessage.title, "Ops, something went wrong")
        XCTAssertEqual(Strings.ErrorMessage.actionTitle, "try again")
        
        XCTAssertEqual(Strings.SearchBar.placeholder, "Search...")
    }
    
}
