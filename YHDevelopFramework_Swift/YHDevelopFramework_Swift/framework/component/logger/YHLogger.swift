//
//  YHLogger.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/8.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import XCGLogger

class YHLogger:YHLoggerProtocol {

   private let systemDestination:AppleSystemLogDestination = {
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        systemDestination.outputLevel = .verbose
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
        let logPath = documentDirPath.appending("/logger")
        let fileDestination = FileDestination(writeToFile: logPath, identifier: "advancedLogger.fileDestination")
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
    
    // MARK: - public area
    public let log: XCGLogger = {
        let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        //颜色暂时不可用
//        let colors: XcodeColorsLogFormatter = XcodeColorsLogFormatter()
//        colors.resetFormatting()
//        log.formatters = [colors]
        return log
    }()
    //开启日志
    public func startLog() {
        log.add(destination: systemDestination)
        log.add(destination: fileDestination)
        log.logAppDetails()
        /*
         处理未捕获的崩溃
         NSSetUncaughtExceptionHandler()只能捕获OC，尚不支持swift的runtime error
         目前建议使用一些第三方的崩溃捕获
         */
    }
}
