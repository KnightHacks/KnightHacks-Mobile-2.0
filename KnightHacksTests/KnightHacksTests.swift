//
//  KnightHacksTests.swift
//  KnightHacksTests
//
//  Created by Lloyd Dapaah on 6/23/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import XCTest
@testable import KnightHacks

class KnightHacksTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let TITLE_FONT = UIFont(name: LatoFont.bold.rawValue, size: 20)
        XCTAssertNotNil(TITLE_FONT)
    }
    
    func testFoo() {
        let date = Date(timeIntervalSinceNow: 0)
        print(date.timeIntervalSince1970)
    }
}
