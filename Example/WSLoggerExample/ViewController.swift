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
        log("Test from WSLogger")
    }

    class func register() {
        log("Test using Loggable")
    }

}
