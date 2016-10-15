//
//  WSLoggerExampleTests.swift
//  WSLoggerExampleTests
//
//  Created by Ricardo Pereira on 15/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import XCTest
@testable import WSLoggerExample

class WSLoggerExampleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        LoggerOptions.defaultLevel = .None
    }

    func testExample() {
        ViewModel().configure()
    }

}
