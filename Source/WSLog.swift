//
//  WSLog.swift
//  WSLogger
//
//  Created by Ricardo Pereira on 14/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation

public enum WSLogLevel: Int {
    case None
    case Error
    case Warning
    case Info
    case Debug
    case Verbose
}

public struct WSLogOptions {
    /// Ex: if `level` is DEBUG then all the VERBOSE entries will be ignored.
    /// Default: VERBOSE, accept all log entries.
    public static var level = WSLogLevel.Verbose
}
