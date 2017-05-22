//
//  YHLogger.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/8.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import XCGLogger

class YHLogger {

    private let consoleDestination: ConsoleDestination = {
    
        let consoleDestination = ConsoleDestination(identifier: "advancedLogger.consoleDestination")
        consoleDestination.outputLevel = .verbose
        consoleDestination.showLogIdentifier = false
        consoleDestination.showFunctionName = true
        consoleDestination.showThreadName = true
        consoleDestination.showLevel = true
        consoleDestination.showFileName = true
        consoleDestination.showLineNumber = true
        consoleDestination.showDate = true
        return consoleDestination
    }()
   private let systemDestination:AppleSystemLogDestination = {
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        systemDestination.outputLevel = .warning
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        return systemDestination
    }()
    private let fileDestination:FileDestination = {
        
        let documentDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        let logPath = documentDirPath.appending("/logger.log")
        let fileDestination = FileDestination(writeToFile: logPath, identifier: "advancedLogger.fileDestination", shouldAppend: true)
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        fileDestination.logQueue = XCGLogger.logQueue
        return fileDestination
    }()
    //单例对象
    static let logger = YHLogger()
    private init(){}
    
    private func formatterLog() {
        //颜色暂时不可用
//        let colors: XcodeColorsLogFormatter = XcodeColorsLogFormatter()
//        colors.resetFormatting()
//        log.formatters = [colors]
        let emojiLogFormatter = PrePostFixLogFormatter()
        emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
        emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
        emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
        emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
        emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
        emojiLogFormatter.apply(prefix: "💥💥💥 ", postfix: " 💥💥💥", to: .severe)
        log.formatters = [emojiLogFormatter]
    }
    
    // MARK: - public area
    public let log: XCGLogger = {
        let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        return log
    }()
    //开启日志
    public func startLog() {
        log.add(destination: consoleDestination)
        log.add(destination: systemDestination)
        log.add(destination: fileDestination)
        formatterLog()
        log.logAppDetails()
        /*
         处理未捕获的崩溃
         NSSetUncaughtExceptionHandler()只能捕获OC，尚不支持swift的runtime error
         目前建议使用一些第三方的崩溃捕获
         */
    }
}
