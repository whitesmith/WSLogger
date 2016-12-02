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
    LoggerOptions.defaultLevel = .Debug
    WSLogger.shared.traceFile = true
    WSLogger.shared.traceMethod = true
    // LogEntries
    LELog.sharedInstance().token = "XXXX-XXX-XXX-XXXX"
}

extension WSLoggable {

    func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String : AnyObject]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        logEntry(message, level: level, customAttributes: customAttributes, className: String(self.dynamicType), fileName: fileName, line: line, function: function)
    }

    static func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String : AnyObject]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        logEntry(message, level: level, customAttributes: customAttributes, className: String(self.dynamicType), fileName: fileName, line: line, function: function)
    }

}

typealias Loggable = WSLoggable
typealias LoggerOptions = WSLoggerOptions
typealias LogLevel = WSLogLevel

private func logEntry(message: String, level: LogLevel = .Debug, customAttributes: [String:AnyObject]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(queue) {
        // Log internally
        let text = WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: className, fileName: fileName, line: line, function: function)
        // If not simulator:
        #if !((arch(i386) || arch(x86_64)) && os(iOS))
            // Ignore DEBUG and VERBOSE
            if level.rawValue <= LogLevel.Info.rawValue {
                // Log remotely
                LELog.sharedInstance().log(text)
            }
        #endif
    }
}
