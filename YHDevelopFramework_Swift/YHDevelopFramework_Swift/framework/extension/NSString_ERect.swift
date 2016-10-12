//
//  NSString_ERect.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension NSString {

    //获取文本高度
    func stringHeight(width: CGFloat, fontSize: CGFloat) -> CGFloat {
        
        return boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
    //获取文本宽度
    func stringWidth(height: CGFloat, fontSize: CGFloat) -> CGFloat {
        
        return boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)], context: nil).size.width
    }
}
