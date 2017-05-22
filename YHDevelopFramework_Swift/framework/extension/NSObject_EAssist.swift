//
//  NSObject_EAssist.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/9.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension NSObject {

    //根据类名创建类
    func swiftClassFromString(_ className: String) -> AnyClass? {
        // 1.获取命名空间
        guard let clsName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as! String? else {
            log.error("命名空间不存在")
            return nil
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString(clsName + "." + className)
        return cls
    }
    //沙盒存
    func sandBoxStore(_ key: String, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    //沙盒存字典数组
    func sanBoxStoreList(keyValues: [String: Any]) {
        UserDefaults.standard.setValuesForKeys(keyValues)
    }
    //沙盒取
    func sandBoxTake(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
}
