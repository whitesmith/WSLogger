//
//  Logger.swift
//  WSLoggerExample
//
//  Created by Ricardo Pereira on 15/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation
import WSLogger

public enum LoggerCategory: String, CaseIterable {
    case global
    case network
    case ui
    case cache
}

private var loggerQueue: DispatchQueue!
private var logger: WSLogger<LoggerCategory>!

func loggerSetup() {
    LoggerOptions.defaultLevel = .verbose
    loggerQueue = DispatchQueue(label: "Logger", qos: .utility)
    logger = WSLogger<LoggerCategory>()
    logger.traceFile = true
    logger.traceMethod = true
}

typealias LoggerOptions = WSLoggerOptions
typealias LogLevel = WSLogLevel

func logEntry(_ message: String, level: LogLevel = LoggerOptions.defaultLevel, category: LoggerCategory = .global, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    loggerQueue.async {
        // Log internally
        let text = logger.log(message, category: category, level: level, customAttributes: customAttributes, className: className, fileName: fileName, line: line, function: function)
        // If not simulator:
        #if !targetEnvironment(simulator)
            // Ignore DEBUG and VERBOSE
            if level.rawValue <= LogLevel.info.rawValue {
                // Log remotely (external service)
                //LELog.sharedInstance().log(text as NSObject)
            }
        #endif
    }
}

func logEntry(identifier: String, message: String, level: LogLevel, category: LoggerCategory = .global, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    logEntry(message, level: level, category: category, customAttributes: ["ID": identifier], className: className, fileName: fileName, line: line, function: function)
}

func logEntryIf(_ condition: Bool, message: String, level: LogLevel, category: LoggerCategory = .global, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    if !condition {
        return
    }
    logEntry(message, level: level, category: category, className: className, fileName: fileName, line: line, function: function)
}

func logError(_ error: Error, category: LoggerCategory = .global, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    let e = error as NSError
    logEntry(e.localizedDescription, level: .error, category: category, customAttributes: ["Code": NSNumber(value: e.code), "Domain": e.domain as NSString], className: className, fileName: fileName, line: line, function: function)
}

//fileprivate var logsInMemory: [String]?

//fileprivate func addInMemoryLog(_ text: String) {
//    if text.isBlank {
//        return
//    }
//    if logsInMemory == nil {
//        logsInMemory = []
//    }
//    if logsInMemory!.count <= 1000 {
//        logsInMemory!.append(text)
//    }
//    else {
//        logsInMemory!.removeFirst()
//        logsInMemory!.append(text)
//    }
//}
