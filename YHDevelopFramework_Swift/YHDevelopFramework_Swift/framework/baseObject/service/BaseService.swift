//
//  BaseService.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/10.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

@objc protocol BaseService: NSObjectProtocol {

    @objc optional func networkSuccessHandle(response: Any)
    @objc optional func networkFailureHandle(error: Error)
   
}

extension BaseService {

    
}
