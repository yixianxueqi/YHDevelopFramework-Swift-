//
//  YHDispatchObject.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/22.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class YHDispatchTimer: NSObject {

    private let globalQueue = DispatchQueue.global(qos: .default)
    private let mainQueue = DispatchQueue.main
    private var timer: DispatchSourceTimer?
    
    func timerIncident(_ time: Int, isMainThread: Bool, task:@escaping ((Void) -> Void)) -> Void {
    
        timer?.cancel()
        if isMainThread {
            timer = DispatchSource.makeTimerSource(queue: mainQueue)
        } else {
            timer = DispatchSource.makeTimerSource(queue: globalQueue)
        }
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(time), leeway: .seconds(1))
        timer?.setEventHandler(handler: { 
            task()
        })
        timer?.resume()
    }
    
    func cancelTimer(completionTask: @escaping ((Void) -> Void)) -> Void {
        
        timer?.setCancelHandler(handler: { 
            completionTask()
        })
        timer?.cancel()
        timer = nil
    }
    
}
