//
//  UIView_EAssist.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension UIView {

    // MARK: - 快捷属性
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var x: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    var y: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    var height: CGFloat {
        get { return bounds.size.height }
        set { bounds.size.height = newValue }
    }
    var width: CGFloat {
        get { return bounds.size.width }
        set { bounds.size.width = width }
    }
    var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }
    var size: CGSize {
        get { return bounds.size }
        set { bounds.size = newValue }
    }
    var minX: CGFloat {
        return frame.minX
    }
    var midX: CGFloat {
        return frame.midX
    }
    var maxX: CGFloat {
        return frame.maxX
    }
    var minY: CGFloat {
        return frame.minY
    }
    var midY: CGFloat {
        return frame.midY
    }
    var maxY: CGFloat {
        return frame.maxY
    }
    
    // MARK: - 便利方法
    //加载xib创建的view
    func loadNibView(_ className: AnyClass) -> UIView? {
        
        let nibName = (NSStringFromClass(className) as NSString).lastPathComponent
        return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.last as? UIView
    }
    
}
