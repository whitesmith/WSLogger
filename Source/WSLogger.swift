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
    /// Default: DEBUG.
    public static var defaultLevel = WSLogLevel.Debug
}

final public class WSLogger {

    internal var printable: WSPrintable
    internal var disabledSymbols = Set<String>()

    public private(set) static var shared = WSLogger()

    /// Show the filename and line number on the log entry.
    public var traceFile: Bool = false
    /// Show the class and function on the log entry.
    public var traceMethod: Bool = false

    public init() {
        self.printable = WSConsole()
    }

    /// Log locally
    public func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String:AnyObject]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) -> String {
        assert(level != .None)
        guard logAllowed(level, className: className) else { return "" }

        var traceInfo = ""
        if traceFile {
            traceInfo += fileName.lastPathComponent + ":" + String(line) + " "
        }
        if traceMethod {
            traceInfo += className.isEmpty ? function : className + "." + function
            traceInfo += " "
        }
        let text = "\(traceInfo)\(String.init(level).uppercaseString) \"\(message)\" [\(customAttributes)]"
        printable.print(text)
        return text
    }

    /// Reset logger settings.
    public func reset() {
        printable = WSConsole()
        traceFile = false
        traceMethod = false
        disabledSymbols.removeAll()
    }

    /// Ignore log entries that derived from a class.
    public func ignoreClass(type: AnyClass) {
        disabledSymbols.insert(String(type))
    }

    private func logAllowed(level: WSLogLevel, className: String) -> Bool {
        return level.rawValue <= WSLoggerOptions.defaultLevel.rawValue && !disabledSymbols.contains(className)
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
