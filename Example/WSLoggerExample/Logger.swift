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
    func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String : AnyObject]? = nil, fileName: NSString = #file, line: Int = #line, function: String = #function) {
        // Log internally
        let text = WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: String(self.dynamicType), fileName: fileName, line: line, function: function)
        // Log remotely
        LELog.sharedInstance().log(text)
    }
}

typealias Loggable = WSLoggable
typealias LoggerOptions = WSLoggerOptions
typealias LogLevel = WSLogLevel
