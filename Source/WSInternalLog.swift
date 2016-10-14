//
//  WSInternalLog.swift
//  WSLogger
//
//  Created by Ricardo Pereira on 14/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation

protocol WSPrintable {
    func print(message: String)
}

private class WSConsole: WSPrintable {
    func print(message: String) {
        Swift.print("\(NSDate()) \(message)")
    }
}

public class WSInternalLog {

    private var printable: WSPrintable

    public init() {
        self.printable = WSConsole()
    }

    init(printable: WSPrintable) {
        self.printable = printable
    }

    /// Log locally
    public func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String:AnyObject]? = nil, filename: NSString = #file, line: Int = #line, function: String = #function) {
        if level.rawValue <= WSLogOptions.level.rawValue {
            printable.print("\(filename.lastPathComponent):\(line) \(function) \(String.init(level).uppercaseString) \"\(message)\" [\(customAttributes)]")
        }
    }

}
