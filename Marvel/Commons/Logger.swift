//
//  Logger.swift
//  Marvel
//
//  Created by Anas Alhasani on 29/07/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Foundation
import os.log

protocol Logger {
    func log(level: OSLogType, message: String, file: String, function: String, line: Int)
}

extension Logger {
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message: message, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message: message, file: file, function: function, line: line)
    }

    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .default, message: message, file: file, function: function, line: line)
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message: message, file: file, function: function, line: line)
    }
}

struct DefaultLogger: Logger {
    private let logger: os.Logger

    init(category: String = "Marvel") {
        self.logger = .init(subsystem: Bundle.main.bundleIdentifier ?? "com.marvel.app", category: category)
    }

    func log(level: OSLogType, message: String, file: String, function: String, line: Int) {
        let fileName = (file as NSString).lastPathComponent
        logger.log(level: level, "\(fileName):\(line) [\(function)] \(message)")
    }
}
