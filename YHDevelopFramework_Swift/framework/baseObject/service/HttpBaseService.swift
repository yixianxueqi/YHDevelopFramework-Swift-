//
//  HttpBaseService.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/10.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

typealias HttpResultHandle = (Bool, Any) -> Void
typealias HttpProgressHandle = (Double) -> Void

@objc protocol HttpBaseService: BaseService {
    
    @objc optional func networkGetRequest(_ url: String?, parameter: [String: Any]?, completet: @escaping HttpResultHandle)
    @objc optional func networkPostRequest(_ url: String?, parameter: [String: Any]?, completet: @escaping HttpResultHandle)
    @objc optional func networkDownloadRequest(_ url: String?, parameter: [String: Any]?, progressHandle: @escaping HttpProgressHandle, completet: @escaping HttpResultHandle)
    @objc optional func networkUploadRequest(_ url: String?, obj:Any, progressHandle: @escaping HttpProgressHandle, completet: @escaping HttpResultHandle)
    
}

extension HttpBaseService {

}
