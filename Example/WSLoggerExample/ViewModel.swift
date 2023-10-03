//
//  ViewModel.swift
//  WSLoggerExample
//
//  Created by Ricardo Pereira on 15/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation

struct ViewModel {

    func configure() {
        logEntry("Bind model data with views")
    }

    static func create() {
        logEntry("Create a new view model")
    }

}
