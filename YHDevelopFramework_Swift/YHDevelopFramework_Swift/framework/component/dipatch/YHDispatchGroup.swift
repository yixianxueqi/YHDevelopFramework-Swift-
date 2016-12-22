//
//  YHDispatchGroup.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/22.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class YHDispatchGroup: NSObject {

    private let globalQueue = DispatchQueue(label: "com.group.queue", attributes: .concurrent)
    private let mainQueue = DispatchQueue.main
    private let group = DispatchGroup.init()
    
    @discardableResult
    func doTask(task: @escaping ((Void) -> Void)) -> YHDispatchGroup {
        
        globalQueue.async(group: group, execute: {
            task()
        })
        return self
    }
    func finallyTask(task: @escaping ((Void) -> Void)) -> Void {
    
        group.notify(queue: mainQueue, execute: {
            task()
        })
    }
}
