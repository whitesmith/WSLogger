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
    static func add(_ message: String) {
        messages.append(message)
    }
    static func clear() {
        messages = []
    }
}

private class MockPrintable: WSPrintable {
    func print(_ message: String) {
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
            XCTAssertTrue(message == "DEBUG \"Let's go!\" []")
        }
    }

    func testDefaultLogIgnoresVerboseEntries() {
        WSLogger.shared.log("Let's go!", level: .verbose)
        XCTAssertTrue(Recorder.messages.count == 0)
    }

    func testVerboseLog() {
        let defaultLevel = WSLoggerOptions.defaultLevel
        defer { WSLoggerOptions.defaultLevel = defaultLevel }
        WSLoggerOptions.defaultLevel = .verbose
        WSLogger.shared.log("ZZZzzZzZZZ", level: .verbose, customAttributes: nil, className: String(describing: type(of: self)))
        if let message = Recorder.messages.first {
            XCTAssertEqual(message, "VERBOSE \"ZZZzzZzZZZ\" []")
        }
    }

    func testCustomAttributesLog() {
        WSLogger.shared.traceMethod = true
        WSLogger.shared.log("Nice, really nice.", level: .info, customAttributes: ["user": 4])
        if let message = Recorder.messages.first {
            XCTAssertEqual(message, "testCustomAttributesLog() INFO \"Nice, really nice.\" [user: 4]")
        }
    }

    func testCompleteTraceLog() {
        WSLogger.shared.traceFile = true
        WSLogger.shared.traceMethod = true
        WSLogger.shared.log("Nice, really nice.", level: .info, customAttributes: nil, className: String(describing: type(of: self)))
        if let message = Recorder.messages.first {
            XCTAssertEqual(message, "WSLoggerTests.swift:70 WSLoggerTests.testCompleteTraceLog() INFO \"Nice, really nice.\" []")
        }
    }

    func testLoggerIgnoreClass() {
        WSLogger.shared.ignoreClass(WSLoggerTests.self)
        WSLogger.shared.log("Great!", level: .verbose, customAttributes: nil, className: String(describing: type(of: self)))
        XCTAssertTrue(Recorder.messages.count == 0)
    }

    func testLoggerWithCustomAttributes() {
        WSLoggerOptions.defaultLevel = .verbose
        WSLogger.shared.log("Oh oh", level: .verbose, customAttributes: ["code": 1, "status": "failure", "reason": "unknown"], className: String(describing: type(of: self)))
        if let message = Recorder.messages.first {
            print(message)
            let expectedResult = """
                VERBOSE "Oh oh" [code: 1, reason: unknown, status: failure]
                """
            XCTAssertEqual(message, expectedResult)
        }
    }

    func testLoggerWithCustomAttributesAndCustomSort() {
        WSLoggerOptions.defaultLevel = .verbose
        let sortClosure: (String, String) throws -> Bool = { a, b in
            return a > b
        }
        WSLogger.shared.log("Oh oh", level: .verbose, customAttributes: ["code": 1, "status": "failure", "reason": "unknown"], customAttributesSortBy: sortClosure, className: String(describing: type(of: self)))
        if let message = Recorder.messages.first {
            print(message)
            let expectedResult = """
                VERBOSE "Oh oh" [status: failure, reason: unknown, code: 1]
                """
            XCTAssertEqual(message, expectedResult)
        }
    }

}
