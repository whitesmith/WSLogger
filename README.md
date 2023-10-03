# WSLogger

[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg)](https://www.swift.org/package-manager/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WSLogger.svg)](https://cocoapods.org/pods/WSLogger)
[![Platforms](https://img.shields.io/badge/platforms-iOS%2C%20macOS%2C%20watchOS%2C%20tvOS%2C%20visionOS-lightgrey.svg)](http://www.apple.com/ios/)

An extensible iOS logger on top of [OSLog](https://developer.apple.com/documentation/os/oslog) - the replacement for `print`, and `NSLog` and Apple’s recommended way of logging.

> OSLog has a low-performance overhead and is archived on the device for later retrieval. You can read logs using the external Console app or benefit from structured logging directly inside Xcode 15. Altogether, obtaining structured logging via OSLog is far better than using print statements.

## Usage

An example of expanding all log entries using `WSLoggable`:

``` swift
import WSLogger

extension WSLoggable {
    func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        // Log internally
        let text = WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: String(describing: type(of: self)), fileName: fileName, line: line, function: function)
        // Log remotely using `text`.
        // Sentry, DataDog, LogEntries, etc.
    }
}
```

You can add a `typealias` to avoid importing the `WSLogger` on every file:

``` swift
typealias Loggable = WSLoggable
typealias LoggerOptions = WSLoggerOptions
typealias LogLevel = WSLogLevel
```

Then use the protocol `Loggable` where you want. The function `log` will be accessible:

``` swift
struct WSTableViewCell: Loggable {
    func configure(viewModel: ViewModel) {
        log("Bind model data with views")
        ...
    }
}
```

It is possible to change the log level with `LoggerOptions.defaultLevel` property. For example, if `LoggerOptions.defaultLevel ` is `debug` then all the `verbose` entries will be ignored.

You can add `LoggerOptions.defaultLevel = .none` to discard any log events on your test suite. It's also possible ignoring classes with `Logger.shared.ignoreClass(WSTableViewCell)`.

You can execute those operations in debug mode as well. Just write in the console `expr -- Logger.shared.ignoreClass(WSTableViewCell)`.


### Extend the log mechanism: example using [LogEntries](https://docs.logentries.com/docs/ios)

You can extend the log mechanism as you want. For example, if you want to access the log entries online:

![LogEntries dashboard](https://github.com/whitesmith/WSLogger/blob/6b1e61e3c82e41b2fd0596cf6b16d32c9df32f20/Example/LogEntries.png?raw=true)

``` swift
import Foundation
import WSLogger
import LogEntries //LogEntries iOS lib

public enum LoggerCategory: String, CaseIterable {
    case global
    case network
    case ui
    case cache
}

private var loggerQueue: DispatchQueue!
private var logger: WSLogger<LoggerCategory>!

func loggerSetup() {
    LoggerOptions.defaultLevel = .verbose
    loggerQueue = DispatchQueue(label: "Logger", qos: .utility)
    logger = WSLogger<LoggerCategory>()
    logger.traceFile = true
    logger.traceMethod = true
    // LogEntries
    LELog.sharedInstance().token = "XXXX-XXX-XXX-XXXX"
}

extension WSLoggable {
    func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
    loggerQueue.async {
        // Log internally
        let text = logger.log(message, level: level, customAttributes: customAttributes, className: String(describing: type(of: self)), fileName: fileName, line: line, function: function)
        // Log remotely
        LELog.sharedInstance().log(text as NSObject)
    }
}
```

The complete example is available [here](https://github.com/whitesmith/WSLogger/tree/master/Example).


## Installation

#### <img src="https://raw.githubusercontent.com/ricardopereira/resources/master/img/cocoapods.png" width="24" height="24"> [CocoaPods]

[CocoaPods]: http://cocoapods.org

To install it, simply add the following line to your **Podfile**:

```ruby
pod 'WSLogger'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 1.0 or newer.

#### Manually

Download all the source files and drop them into your project.

## Requirements

* iOS 12.0+
* Xcode 13 (Swift 5.0)

# Contributing

The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/whitesmith/WSLogger/issues/new) if you find bugs or have questions. :octocat:

# Credits
![Whitesmith](http://i.imgur.com/Si2l3kd.png)

Checkout the excelent topic on [Logging in Swift](http://merowing.info/2016/07/logging-in-swift/) from [Krzysztof Zabłocki](https://twitter.com/merowing_).
