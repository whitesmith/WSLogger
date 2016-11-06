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
    func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, fileName: NSString = #file, line: Int = #line, function: String = #function) {
        // Log internally
        let text = WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: String(describing: type(of: self)), fileName: fileName, line: line, function: function)
        // Log remotely
        LELog.sharedInstance().log(text as NSObject!)
    }
}

typealias Loggable = WSLoggable
typealias LoggerOptions = WSLoggerOptions
typealias LogLevel = WSLogLevel
