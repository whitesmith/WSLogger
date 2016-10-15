//
//  WSLoggable.swift
//  WSLogger
//
//  Created by Ricardo Pereira on 14/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation

public protocol WSLoggable {
    func log(message: String, level: WSLogLevel, customAttributes: [String:AnyObject]?, fileName: NSString, line: Int, function: String)
}
