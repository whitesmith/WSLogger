//
//  WSLoggerTests.swift
//  WSLoggerTests
//
//  Created by Ricardo Pereira on 14/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import XCTest
@testable import WSLogger

private struct Recorder {
    static var messages: [String] = []
    static func add(message: String) {
        messages.append(message)
    }
    static func clear() {
        messages = []
    }
}

private class MockPrintable: WSPrintable {
    func print(message: String) {
        Recorder.add(message)
    }
}

class WSLoggerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Recorder.clear()
    }

    func testInternalLog() {
        WSInternalLog(printable: MockPrintable()).log("Let's go!")
        XCTAssertTrue(Recorder.messages[0] == "WSLoggerTests.swift:36 testInternalLog() DEBUG \"Let's go!\" [nil]")
    }

}
