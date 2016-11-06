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
    public static var defaultLevel = WSLogLevel.debug
}

final public class WSLogger {

    internal var printable: WSPrintable
    internal var disabledSymbols = Set<String>()

    public fileprivate(set) static var shared = WSLogger()

    /// Show the filename and line number on the log entry.
    public var traceFile: Bool = false
    /// Show the class and function on the log entry.
    public var traceMethod: Bool = false

    public init() {
        self.printable = WSConsole()
    }

    /// Log locally
    @discardableResult
    public func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String:Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) -> String {
        assert(level != .none)
        guard logAllowed(level, className: className) else { return "" }

        var traceInfo = ""
        if traceFile {
            traceInfo += fileName.lastPathComponent + ":" + String(line) + " "
        }
        if traceMethod {
            traceInfo += className.isEmpty ? function : className + "." + function
            traceInfo += " "
        }
        let text = "\(traceInfo)\(String.init(describing: level).uppercased()) \"\(message)\" [\(customAttributes)]"
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
    public func ignoreClass(_ type: AnyClass) {
        disabledSymbols.insert(String(describing: type))
    }

    fileprivate func logAllowed(_ level: WSLogLevel, className: String) -> Bool {
        return level.rawValue <= WSLoggerOptions.defaultLevel.rawValue && !disabledSymbols.contains(className)
    }

}

internal protocol WSPrintable {
    func print(_ message: String)
}

private class WSConsole: WSPrintable {
    func print(_ message: String) {
        Swift.print("\(Date()) \(message)")
    }
}
