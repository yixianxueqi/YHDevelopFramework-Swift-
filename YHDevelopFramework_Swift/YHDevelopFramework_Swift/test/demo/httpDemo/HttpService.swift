//
//  HttpService.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/10.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class HttpService: NSObject, BaseService {
    
    var handleDic: [String:Any] = [:]
    var handelList:[NSMutableDictionary] = Array()
    var handle: ((Bool, Any) -> Void)?
    var handle_post: ((Bool, Any) -> Void)?
    
    func getRequestFunc(complete: @escaping (Bool, Any) -> Void) {
        
        handle = complete
        let network = getNetworkInstance()
        network.getRequest(url: "http://bea.wufazhuce.com/OneForWeb/one/getHp_N", parameter: ["strDate":"2015-05-25","strRow":"1"]).successHandle(action: networkSuccessHandle).failureHandle(action: networkFailureHandle)
    }
    
    func postRequest(complete: @escaping (Bool, Any) -> Void) {
        
        handle_post = complete
        let network = getNetworkInstance()
        network.postRequest(url: "https://httpbin.org/post", parameter: ["foo": [1,2,3],"bar":["baz": "qux"]]).successHandle(action: networkSuccessHandle).failureHandle(action: networkFailureHandle)
    }
    
    private func getNetworkInstance() -> YHNetwork {
        
        YHNetwork.baseURL = ""
        let network = YHNetwork()
        network.header = [:]
        return network
    }
    
    // MARK: - BaseService
    func networkSuccessHandle(response: Any) {
        log.info("\(response)")
        handle?(true,response)
    }
    func networkFailureHandle(error: Error) {
        log.error("\(error)")
        handle?(false,error)
    }
}
