//
//  ViewController.swift
//  WSLoggerExample
//
//  Created by Ricardo Pereira on 15/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Loggable {

    override func viewDidLoad() {
        super.viewDidLoad()
        log("Test using Loggable")
        logEntry(identifier: NSUUID().uuidString, message: "App has started", level: .info)
        logEntryIf(true, message: "App is not ready", level: .warning)
        logEntryIf(false, message: "App is ready", level: .warning)
        logError(NSError.init(domain: "co.whitesmith.WSLoggerExample", code: 100, userInfo: [NSLocalizedDescriptionKey: "App is not running"]))
    }

    class func register() {
        log("Test using Loggable")
    }

}
