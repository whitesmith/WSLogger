//
//  ViewModel.swift
//  WSLoggerExample
//
//  Created by Ricardo Pereira on 15/10/2016.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation

struct ViewModel: Loggable {

    func configure() {
        log("Bind model data with views")
    }

    static func create() {
        log("Create a new view model")
    }

}
