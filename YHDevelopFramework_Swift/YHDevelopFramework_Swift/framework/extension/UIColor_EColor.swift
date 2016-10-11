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
    //根据16进制返回颜色
    static func XColor(value: String, alpha: Float) -> UIColor {
        
        let str = value.replacingOccurrences(of: "#", with: "")
        let num = Int(str)
        let rgb = XColorToRGBColor(num: num!)
        return RGBAColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: alpha)
        
    }
    //将16进制色转化为三原色数值
    static func XColorToRGBColor(num:Int) -> (Int,Int,Int) {

        let redComponent = (num & 0xFF0000) >> 16
        let greenComponent = (num & 0x00FF00) >> 8
        let blueComponent = num & 0x0000FF
        return (redComponent,greenComponent,blueComponent)
    }
    
}
