//
//  YHLoggerProtocol.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/8.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import XCGLogger

//任何遵守了日志协议的都可以调用log进行日志管理
protocol YHLoggerProtocol {
    
    
}

extension YHLoggerProtocol {

    var log: XCGLogger {
        return YHLogger.logger.log
    }
}
