//
//  HttpService.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/10.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class HttpService: NSObject, HttpBaseService {
    
    
    
    private func getNetworkInstance() -> YHNetwork {
        
        YHNetwork.baseURL = ""
        YHNetwork.timeOut = 30
        let network = YHNetwork()
        network.header = [:]
        network.commonParam = ["":""]
        return network
    }
    
    // MARK: - HttpBaseService
    func networkGetRequest(_ url: String?, parameter: [String : Any]?, completet: @escaping HttpResultHandle) {
        
        let network = getNetworkInstance()
        guard url != nil else {
            return
        }
        network.getRequest(url: url!, parameter: parameter).successHandle(action: completet).failureHandle(action: completet)
    }

    func networkPostRequest(_ url: String?, parameter: [String : Any]?, completet: @escaping HttpResultHandle) {
        
        let network = getNetworkInstance()
        guard url != nil else {
            return
        }
        network.postRequest(url: url!, parameter: parameter).successHandle { (isSuccess, response) in
            // do something else
            let json = JSON(response)
            completet(isSuccess,json)
        }.failureHandle { (isSuccess, error) in
            // do something else
            completet(isSuccess,error)
        }
    }
    @nonobjc func networkDownloadRequest(_ url: String?, parameter: [String : Any]?, progressHandle: @escaping HttpProgressHandle, completet: @escaping HttpResultHandle) {
       
        let network = getNetworkInstance()
        guard url != nil else {
            return
        }
        network.downLoadRequest(url: url!, type: .FileStream)
        .progressHandle { progress in
            // do something else
            progressHandle(progress)
        }
        .successHandle { (isSuccess, response) in
            // do something else
            completet(isSuccess,response)
        }
        .failureHandle { (isSuccess, error) in
            // do something else
            completet(isSuccess,error)
        }
    }
    func networkUploadRequest(_ url: String?, obj: Any, progressHandle: @escaping HttpProgressHandle, completet: @escaping HttpResultHandle) {
        
        let network = getNetworkInstance()
        guard url != nil else {
            return
        }
        network.uploadRequest(url: url!, type: .DataStream, obj: obj)
        .progressHandle { progress in
            // do something else
            progressHandle(progress)
        }
        .successHandle { (isSuccess, response) in
            // do something else
            completet(true,response)
        }
        .failureHandle { (isSuccess, error) in
            // do something else
            completet(false,error)
        }
    }
}


