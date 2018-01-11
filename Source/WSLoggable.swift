//
//  WSLoggable.swift
//  WSLogger
//
//  Created by Ricardo Pereira on 14/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation

public protocol WSLoggable {
    func log(_ message: String, level: WSLogLevel, customAttributes: [String : Any]?, className: String, fileName: NSString, line: Int, function: String)
    static func log(_ message: String, level: WSLogLevel, customAttributes: [String : Any]?, className: String, fileName: NSString, line: Int, function: String)
}
