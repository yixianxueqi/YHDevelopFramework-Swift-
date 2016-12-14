//
//  YHPhotoResult.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/14.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

public class YHPhotoResult: NSObject {

    var thumbnail: UIImage?
    var highImage: UIImage?
    
    init(_ thumbanil: UIImage?,_ highImage: UIImage?) {
        
        self.thumbnail = thumbanil
        self.highImage = highImage
        super.init()
    }
    
}
