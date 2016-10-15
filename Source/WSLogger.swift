//
//  WSLogger.swift
//  WSLogger
//
//  Created by Ricardo Pereira on 14/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//
//  Credits to Krzysztof Zabłocki: http://merowing.info/2016/07/logging-in-swift/
//

import Foundation

public struct WSLoggerOptions {
    /// Ex: if `level` is DEBUG then all the VERBOSE entries will be ignored.
    /// Default: VERBOSE, accept all log entries.
    public static var defaultLevel = WSLogLevel.Verbose
}

final public class WSLogger {

    internal var printable: WSPrintable
    internal var disabledSymbols = Set<String>()

    public private(set) static var shared = WSLogger()

    public init() {
        self.printable = WSConsole()
    }

    /// Log locally
    public func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String:AnyObject]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        guard logAllowed(className: className) else { return }
        if level.rawValue <= WSLoggerOptions.defaultLevel.rawValue {
            printable.print("\(fileName.lastPathComponent):\(line) \(className).\(function) \(String.init(level).uppercaseString) \"\(message)\" [\(customAttributes)]")
        }
    }

    ///
    public func ignoreClass(type: AnyClass) {
        disabledSymbols.insert(String(type))
    }

    private func logAllowed(className className: String) -> Bool {
        return !disabledSymbols.contains(className)
    }

}

internal protocol WSPrintable {
    func print(message: String)
}

private class WSConsole: WSPrintable {
    func print(message: String) {
        Swift.print("\(NSDate()) \(message)")
    }
}
