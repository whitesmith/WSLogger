//
//  Logger.swift
//  WSLoggerExample
//
//  Created by Ricardo Pereira on 15/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation
import WSLogger
import lelib

func loggerSetup() {
    LoggerOptions.defaultLevel = .debug
    WSLogger.shared.traceFile = true
    WSLogger.shared.traceMethod = true
    // LogEntries
    LELog.sharedInstance().token = "XXXX-XXX-XXX-XXXX"
}

extension WSLoggable {

    func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        logEntry(message, level: level, customAttributes: customAttributes, className: String(describing: type(of: self)), fileName: fileName, line: line, function: function)
    }

    static func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        logEntry(message, level: level, customAttributes: customAttributes, className: String(describing: type(of: self)), fileName: fileName, line: line, function: function)
    }

}

typealias Loggable = WSLoggable
typealias LoggerOptions = WSLoggerOptions
typealias LogLevel = WSLogLevel

private func logEntry(_ message: String, level: LogLevel = .debug, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    DispatchQueue.global().async {
        // Log internally
        let text = WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: className, fileName: fileName, line: line, function: function)
        // If not simulator:
        #if !(TARGET_OS_SIMULATOR)
            // Ignore DEBUG and VERBOSE
            if level.rawValue <= LogLevel.info.rawValue {
                // Log remotely
                LELog.sharedInstance().log(text as NSObject)
            }
        #endif
    }
}

func logEntry(identifier: String, message: String, level: LogLevel, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    logEntry(message, level: level, customAttributes: ["ID": identifier], className: className, fileName: fileName, line: line, function: function)
}

func logEntryIf(_ condition: Bool, message: String, level: LogLevel, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    if !condition {
        return
    }
    logEntry(message, level: level, className: className, fileName: fileName, line: line, function: function)
}

func logError(_ error: Error, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    let e = error as NSError
    logEntry(e.localizedDescription, level: .error, customAttributes: ["Code": NSNumber(value: e.code), "Domain": e.domain as NSString], className: className, fileName: fileName, line: line, function: function)
}
