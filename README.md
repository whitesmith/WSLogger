# WSLogger

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WSLogger.svg)](https://cocoapods.org/pods/WSLogger)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](http://www.apple.com/ios/)
[![Build Status](https://app.bitrise.io/app/c0d00066e83871d0/status.svg?token=F4rPP7Jp0rT4dUqaE63fuw&branch=master)]()
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://opensource.org/licenses/MIT)

An iOS logger where it's possible to extend the log functionality.

## Usage

For example, create a `Logger.swift` and add your implementation of `WSLoggable`:

``` swift
import WSLogger

extension WSLoggable {
    func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        // Log internally
        let text = WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: String(describing: type(of: self)), fileName: fileName, line: line, function: function)
        // Log remotely using `text`.
        // Fabric, LogEntries, etc.
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

It's possible to change the log level with `LoggerOptions.defaultLevel` property. For example, if `LoggerOptions.defaultLevel ` is `debug` then all the `verbose` entries will be ignored.

You can add `LoggerOptions.defaultLevel = .none` to discard any log events on your test suite. It's also possible ignoring classes with `Logger.shared.ignoreClass(WSTableViewCell)`.

You can execute those operations in debug mode as well. Just write in the console `expr -- Logger.shared.ignoreClass(WSTableViewCell)`.


### Extend the log mechanism: example using [LogEntries](https://docs.logentries.com/docs/ios)

You can extend the log mechanism as you want. For example, if you want to access the log entries online:

![LogEntries dashboard](https://github.com/whitesmith/WSLogger/blob/6b1e61e3c82e41b2fd0596cf6b16d32c9df32f20/Example/LogEntries.png?raw=true)

``` swift
import Foundation
import WSLogger
import lelib //LogEntries iOS lib

func loggerSetup() {
    LoggerOptions.defaultLevel = .Debug
    WSLogger.shared.traceFile = true
    WSLogger.shared.traceMethod = true
    // LogEntries
    LELog.sharedInstance().token = "XXXX-XXX-XXX-XXXX"
}

extension WSLoggable {
    func log(_ message: String, level: WSLogLevel = .debug, customAttributes: [String : Any]? = nil, className: String = "", fileName: NSString = #file, line: Int = #line, function: String = #function) {
        // Log internally
        let text = WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: String(describing: type(of: self)), fileName: fileName, line: line, function: function)
        // Log remotely
        LELog.sharedInstance().log(text as NSObject)
    }
}
```

The complete example is available [here](https://github.com/whitesmith/WSLogger/tree/master/Example).


## Installation

#### <img src="https://cloud.githubusercontent.com/assets/432536/5252404/443d64f4-7952-11e4-9d26-fc5cc664cb61.png" width="24" height="24"> [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

To install it, simply add the following line to your **Cartfile**:

```ruby
github "whitesmith/WSLogger"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

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

* iOS 8.0+
* Xcode 10 (Swift 4.0)

# Contributing

The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/whitesmith/WSLogger/issues/new) if you find bugs or have questions. :octocat:

# Credits
![Whitesmith](http://i.imgur.com/Si2l3kd.png)

Checkout the excelent topic on [Logging in Swift](http://merowing.info/2016/07/logging-in-swift/) from [Krzysztof Zabłocki](https://twitter.com/merowing_).
