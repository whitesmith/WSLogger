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
        WSLogger.shared.reset()
        WSLogger.shared.printable = MockPrintable()
    }

    func testDefaultLog() {
        WSLogger.shared.log("Let's go!")
        if let message = Recorder.messages.first {
            XCTAssertTrue(message == "DEBUG \"Let's go!\" [nil]")
        }
    }

    func testDefaultLogIgnoresVerboseEntries() {
        WSLogger.shared.log("Let's go!", level: .Verbose)
        XCTAssertTrue(Recorder.messages.count == 0)
    }

    func testVerboseLog() {
        let defaultLevel = WSLoggerOptions.defaultLevel
        defer { WSLoggerOptions.defaultLevel = defaultLevel }
        WSLoggerOptions.defaultLevel = .Verbose
        WSLogger.shared.log("ZZZzzZzZZZ", level: .Verbose, customAttributes: nil, className: String(self.dynamicType))
        if let message = Recorder.messages.first {
            XCTAssertTrue(message == "VERBOSE \"ZZZzzZzZZZ\" [nil]")
        }
    }

    func testCustomAttributesLog() {
        WSLogger.shared.traceMethod = true
        WSLogger.shared.log("Nice, really nice.", level: .Info, customAttributes: ["user": 4])
        if let message = Recorder.messages.first {
            XCTAssertTrue(message == "testCustomAttributesLog() INFO \"Nice, really nice.\" [Optional([\"user\": 4])]")
        }
    }

    func testCompleteTraceLog() {
        WSLogger.shared.traceFile = true
        WSLogger.shared.traceMethod = true
        WSLogger.shared.log("Nice, really nice.", level: .Info, customAttributes: nil, className: String(self.dynamicType))
        if let message = Recorder.messages.first {
            XCTAssertTrue(message == "WSLoggerTests.swift:70 WSLoggerTests.testCompleteTraceLog() INFO \"Nice, really nice.\" [nil]")
        }
    }

    func testLoggerIgnoreClass() {
        WSLogger.shared.ignoreClass(WSLoggerTests)
        WSLogger.shared.log("Great!", level: .Verbose, customAttributes: nil, className: String(self.dynamicType))
        XCTAssertTrue(Recorder.messages.count == 0)
    }

}
