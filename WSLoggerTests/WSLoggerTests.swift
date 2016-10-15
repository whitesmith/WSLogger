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
        WSLogger.shared.printable = MockPrintable()
    }

    func testInternalLog() {
        WSLogger.shared.log("Let's go!", level: .Debug, customAttributes: nil, className: String(self.dynamicType))
        XCTAssertTrue(Recorder.messages[0] == "WSLoggerTests.swift:37 WSLoggerTests.testInternalLog() DEBUG \"Let's go!\" [nil]")
    }

}
