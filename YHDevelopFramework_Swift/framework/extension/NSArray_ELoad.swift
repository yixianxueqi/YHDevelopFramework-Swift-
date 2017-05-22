//
//  NSArray_ELoad.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension NSArray {

    //从plist文件获取数组
    static func arrayFromPlist(_ name: String) -> NSArray? {
    
        guard let path = Bundle.main.path(forResource: name, ofType: ".plist") else {
            return nil
        }
        return NSArray.init(contentsOfFile: path)
    }
}
