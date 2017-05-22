//
//  NSNumber_EFromatter.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/13.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension NSNumber {

    //金钱格式化
    func moneyFormatter() -> String? {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00"
        return numberFormatter.string(from: self)
    }
    //科学计数法
    func scienceFormatter() -> String? {
    
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "00.00E+00"
        return numberFormatter.string(from: self)
    }
    //百分比
    func percentageFormatter() -> String? {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "0.00%"
        return numberFormatter.string(from: self)
    }

    //保留几位小数
    func formatterDecimal(_ max: Int, min: Int = 0) -> String? {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = max
        numberFormatter.minimumFractionDigits = min
        return numberFormatter.string(from: self)
    }
}
