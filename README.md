# WSLogger

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WSLogger.svg)](https://cocoapods.org/pods/WSLogger)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](http://www.apple.com/ios/)
[![Build Status](https://www.bitrise.io/app/059bc89743c769dc.svg?token=Wu0zdJtTsCQlVFSG1XuGIw&branch=master)](https://www.bitrise.io/app/059bc89743c769dc)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://opensource.org/licenses/MIT)

An iOS logger where it's possible to extend the log functionality.

## Usage

``` swift
import WSLogger

// Your Loggable implementation
extension WSLoggable {
    func log(message: String, level: WSLogLevel = .Debug, customAttributes: [String : AnyObject]? = nil, fileName: NSString = #file, line: Int = #line, function: String = #function) {
        // Log internally
        WSLogger.shared.log(message, level: level, customAttributes: customAttributes, className: String(self.dynamicType), fileName: fileName, line: line, function: function)
        // Log remotely
        // Fabric, LogEntries, etc.
    }
}

struct WSTableViewCell: Loggable {
    func configure(viewModel: ViewModel) {
        log("Bind model data with views")
        ...
    }
}

```

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

#### <img src="https://dl.dropboxusercontent.com/u/11377305/resources/cocoapods.png" width="24" height="24"> [CocoaPods]

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
* Xcode 7.3 (Swift 2.2)

# Contributing

The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/whitesmith/WSLogger/issues/new) if you find bugs or have questions. :octocat:

# Credits
![Whitesmith](http://i.imgur.com/Si2l3kd.png)

