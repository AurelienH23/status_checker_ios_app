//
//  StatusCheckerTests.swift
//  StatusCheckerTests
//
//  Created by Aurélien Haie on 24/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import XCTest
@testable import StatusChecker

class StatusCheckerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckStatusFunc() {
        // It doesn't work
        
        // I would have put the checkStatus func in a custom Network object, but no need in this short app to create too many files
        
        let searchVC = ServiceSearchController(style: .plain)
        
        let goodUrl = "https://www.apple.com"
        searchVC.checkStatus(forURL: goodUrl) { (response) in
            XCTAssert(response == 200, "the checkStatus(forURL:) func didn't work out for checking a good url.")
        }
        
        let badUrl = "ThisIsNotAGoodUrl"
        searchVC.checkStatus(forURL: badUrl) { (response) in
            XCTAssert(response == 404, "the checkStatus(forURL:) func didn't work out for checking a bad url.")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
