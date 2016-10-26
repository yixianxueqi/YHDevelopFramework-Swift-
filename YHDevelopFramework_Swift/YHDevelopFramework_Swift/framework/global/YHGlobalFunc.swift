//
//  YHGlobalFunc.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import Foundation

//自定义日志
func YHLog<T>(_ message: T, file: String = #file,funcName: String = #function, lineNumber: Int = #line) {
    
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("🐞🐞🐞\n \(fileName)->\(funcName)->\(lineNumber):\(message)\n🐞🐞🐞")
    #endif
    
}
//延时执行
func dispatch_after(_ seconds: Double, execute: @escaping (Void)->Void) {

    let delay = DispatchTime.now() + Double(seconds)
    DispatchQueue.main.asyncAfter(deadline: delay, execute: execute)
}

