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
#if canImport(OSLog)
import OSLog
#endif

public struct WSLoggerOptions {
    /// Ex: if `level` is DEBUG then all the VERBOSE entries will be ignored.
    /// Default: DEBUG.
    public static var defaultLevel = WSLogLevel.debug
}

public enum WSLoggerCategory: String, CaseIterable {
    case global
}

public typealias WSGlobalLogger = WSLogger<WSLoggerCategory>

final public class WSLogger<C: RawRepresentable & CaseIterable> where C.RawValue == String {

    internal var printable: WSPrintable
    internal var disabledSymbols = Set<String>()

    /// Show the filename and line number on the log entry.
    public var traceFile: Bool = false
    /// Show the class and function on the log entry.
    public var traceMethod: Bool = false

    public init(customPrintable: WSPrintable? = nil) {
        if let customPrintable {
            self.printable = customPrintable
        }
        else if #available(iOS 14.0, macOS 10.10, macCatalyst 13.0, tvOS 14.0, watchOS 7.0, *) {
            #if canImport(OSLog)
            self.printable = WSOSLogPrint()
            #else
            self.printable = WSSwiftPrint()
            #endif
        }
        else {
            self.printable = WSSwiftPrint()
        }
    }

    /// Log locally
    @discardableResult
    public func log(_ message: String, category: C, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, customAttributesSortBy: ((String, String) throws -> Bool)? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) -> String {
        guard 
            logAllowed(level, className: className)
        else {
            return "" //ignore
        }

        var traceInfo = ""
        if traceFile {
            traceInfo += fileName.lastPathComponent + ":" + String(line) + " "
        }
        if traceMethod {
            traceInfo += className.isEmpty ? function : className + "." + function
            traceInfo += " "
        }

        var customAttributesText = "[]"
        if let customAttributes = customAttributes, !customAttributes.isEmpty {
            let sortedCustomAttributes = customAttributesSortBy == nil ? customAttributes.keys.sorted() : try! customAttributes.keys.sorted(by: customAttributesSortBy!)
            customAttributesText = "["
            customAttributesText += sortedCustomAttributes.map({ key in
                return "\(key): \(customAttributes[key]!)"
            }).joined(separator: ", ")
            customAttributesText += "]"
        }

        let text = "\(traceInfo)\(String(describing: level).uppercased()) \"\(message)\" \(customAttributesText)"
        printable.print(text, level: level, category: category.rawValue)
        return text
    }

    /// Reset logger settings.
    public func reset() {
        traceFile = false
        traceMethod = false
        disabledSymbols.removeAll()
    }

    /// Ignore log entries that derived from a class.
    public func ignoreClass(_ type: AnyClass) {
        disabledSymbols.insert(String(describing: type))
    }

    fileprivate func logAllowed(_ level: WSLogLevel, className: String) -> Bool {
        return level != .none && level.rawValue <= WSLoggerOptions.defaultLevel.rawValue && !disabledSymbols.contains(className)
    }

}

public protocol WSPrintable {
    func print(_ message: String, level: WSLogLevel, category: String)
}

private class WSSwiftPrint: WSPrintable {

    func print(_ message: String, level: WSLogLevel, category: String) {
        let symbol: String
        switch (level) {
        case .debug:
            symbol = ""
        case .none:
            symbol = ""
        case .error:
            symbol = "🔴"
        case .warning:
            symbol = "🟡"
        case .info:
            symbol = "🔵"
        case .verbose:
            symbol = ""
        }

        Swift.print("\(symbol) \(Date()) |\(category.uppercased())| \(message)")
    }

}

#if canImport(OSLog)
@available(iOS 14.0, macOS 10.10, macCatalyst 13.0, tvOS 14.0, watchOS 7.0, *)
private class WSOSLogPrint: WSPrintable {

    private var loggers: [String: Logger] = [:]

    func getLogger(category: String) -> Logger {
        if let existingLogger = loggers[category] {
            return existingLogger
        } 
        else {
            let newLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: category)
            loggers[category] = newLogger
            return newLogger
        }
    }

    func print(_ message: String, level: WSLogLevel, category: String) {
        let oslogger = getLogger(category: category.lowercased())
        switch (level) {
        case .none:
            break
        case .debug:
            oslogger.debug("\(message)")
        case .error:
            oslogger.critical("\(message)")
        case .warning:
            oslogger.warning("\(message)")
        case .info:
            oslogger.info("\(message)")
        case .verbose:
            oslogger.trace("\(message)")
        }
    }

}
#endif
