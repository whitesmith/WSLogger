//
//  Logger.swift
//  WSLoggerExample
//
//  Created by Ricardo Pereira on 15/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation
import WSLogger

extension WSLoggable {
    func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String : AnyObject]? = nil, fileName: NSString = #file, line: Int = #line, function: String = #function) {
        // Log internally
        WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: String(self.dynamicType), fileName: fileName, line: line, function: function)
        // Log remotely
        // Fabric ?!
    }
}

typealias Loggable = WSLoggable
typealias LoggerOptions = WSLoggerOptions
typealias LogLevel = WSLogLevel
