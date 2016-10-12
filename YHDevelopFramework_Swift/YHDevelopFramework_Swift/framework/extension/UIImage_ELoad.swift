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
}
