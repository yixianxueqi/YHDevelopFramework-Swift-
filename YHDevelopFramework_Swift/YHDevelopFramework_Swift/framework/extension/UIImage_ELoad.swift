//
//  UIImage_Eload.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension UIImage {

    //加载本地图片
    static func loadLocalImage(_ name: String, type: String) -> UIImage? {
    
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            return nil
        }
      return UIImage(contentsOfFile: path)
    }
    //圆形图片
    func circleImage() -> UIImage? {
    
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        context!.addEllipse(in: rect)
        context?.clip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    //圆角图片
    func cornerImage(_ corneradius: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIBezierPath.init(roundedRect: rect, cornerRadius: corneradius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
