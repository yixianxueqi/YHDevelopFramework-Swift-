//
//  UIColor_EColor.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/11.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension UIColor {

    //根据三原色返回颜色
    static func RGBAColor(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: Float(red)/255.0, green: Float(green)/255.0, blue: Float(blue)/255.0, alpha: alpha)
    }
    
    /// 根据16进制返回颜色
    ///
    /// - parameter value: 0x......(16进制数字表示法)
    /// - parameter alpha: Float
    ///
    /// - returns: UIColor
    static func XColor(value: Int, alpha: Float) -> UIColor {
        
        let rgb = XColorToRGBColor(num: value)
        return RGBAColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: alpha)
        
    }
    /// 将16进制色转化为RGB三原色数值
    ///
    /// - parameter num: 0x......(16进制数字表示法)
    ///
    /// - returns: UIColor
    static func XColorToRGBColor(num:Int) -> (Int,Int,Int) {

        let redComponent = (num & 0xFF0000) >> 16
        let greenComponent = (num & 0x00FF00) >> 8
        let blueComponent = num & 0x0000FF
        return (redComponent,greenComponent,blueComponent)
    }
    
}
