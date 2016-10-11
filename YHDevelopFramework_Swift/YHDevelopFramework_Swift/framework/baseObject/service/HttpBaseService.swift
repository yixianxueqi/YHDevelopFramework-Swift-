//
//  HttpBaseService.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/10.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

typealias HttpResultHandle = (Bool, Any) -> Void

@objc protocol HttpBaseService: BaseService {
    
    @objc optional func networkSuccessHandle(response: Any)
    @objc optional func networkFailureHandle(error: Error)
    @objc optional func networkGetRequest(_ url: String?, parameter: [String: Any]?, completet: @escaping HttpResultHandle)
    @objc optional func networkPostRequest(_ url: String?, parameter: [String: Any]?, completet: @escaping HttpResultHandle)
}

extension HttpBaseService {

}
