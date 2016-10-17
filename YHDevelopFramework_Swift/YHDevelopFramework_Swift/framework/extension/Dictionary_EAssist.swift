//
//  Dictionary_EAssist.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/14.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

public typealias Parameters = [String: Any]

infix operator +
extension Dictionary {

    static func + (left: Parameters, right: Parameters) ->  Parameters {
        
        var dic = Parameters()
        for (key, value) in left {
            dic.updateValue(value, forKey: key)
        }
        for (key, value) in right {
            dic.updateValue(value, forKey: key)
        }
        return dic
    }
}
