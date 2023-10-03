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
    func print(_ message: String, level: WSLogLevel, category: String) {
        Recorder.add(message)
    }
}

class WSLoggerTests: XCTestCase {

    var logger = WSGlobalLogger()

    override func setUp() {
        super.setUp()
        Recorder.clear()
        logger.reset()
        logger.printable = MockPrintable()
    }

    func testDefaultLog() {
        logger.log("Let's go!", category: .global)
        if let message = Recorder.messages.first {
            XCTAssertTrue(message == "DEBUG \"Let's go!\" []")
        }
    }

    func testDefaultLogIgnoresVerboseEntries() {
        logger.log("Let's go!", category: .global, level: .verbose)
        XCTAssertTrue(Recorder.messages.count == 0)
    }

    func testVerboseLog() {
        let defaultLevel = WSLoggerOptions.defaultLevel
        defer { WSLoggerOptions.defaultLevel = defaultLevel }
        WSLoggerOptions.defaultLevel = .verbose
        logger.log("ZZZzzZzZZZ", category: .global, level: .verbose, customAttributes: nil, className: String(describing: type(of: self)))
        if let message = Recorder.messages.first {
            XCTAssertEqual(message, "VERBOSE \"ZZZzzZzZZZ\" []")
        }
    }

    func testCustomAttributesLog() {
        logger.traceMethod = true
        logger.log("Nice, really nice.", category: .global, level: .info, customAttributes: ["user": 4])
        if let message = Recorder.messages.first {
            XCTAssertEqual(message, "testCustomAttributesLog() INFO \"Nice, really nice.\" [user: 4]")
        }
    }

    func testCompleteTraceLog() {
        logger.traceFile = true
        logger.traceMethod = true
        logger.log("Nice, really nice.", category: .global, level: .info, customAttributes: nil, className: String(describing: type(of: self)))
        if let message = Recorder.messages.first {
            XCTAssertEqual(message, "WSLoggerTests.swift:72 WSLoggerTests.testCompleteTraceLog() INFO \"Nice, really nice.\" []")
        }
    }

    func testLoggerIgnoreClass() {
        logger.ignoreClass(WSLoggerTests.self)
        logger.log("Great!", category: .global, level: .verbose, customAttributes: nil, className: String(describing: type(of: self)))
        XCTAssertTrue(Recorder.messages.count == 0)
    }

    func testLoggerWithCustomAttributes() {
        WSLoggerOptions.defaultLevel = .verbose
        logger.log("Oh oh", category: .global, level: .verbose, customAttributes: ["code": 1, "status": "failure", "reason": "unknown"], className: String(describing: type(of: self)))
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
        logger.log("Oh oh", category: .global, level: .verbose, customAttributes: ["code": 1, "status": "failure", "reason": "unknown"], customAttributesSortBy: sortClosure, className: String(describing: type(of: self)))
        if let message = Recorder.messages.first {
            print(message)
            let expectedResult = """
                VERBOSE "Oh oh" [status: failure, reason: unknown, code: 1]
                """
            XCTAssertEqual(message, expectedResult)
        }
    }

}
