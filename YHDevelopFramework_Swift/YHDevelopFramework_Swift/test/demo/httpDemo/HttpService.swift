//
//  HttpService.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/10.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class HttpService: NSObject, BaseService {
    
    var handle:((Bool, Any) -> Void)?
    
    func getRequestFunc(complete: @escaping (Bool, Any) -> Void) {
        
        handle = complete
        let network = getNetworkInstance()
        network.getRequest(url: "http://bea.wufazhuce.com/OneForWeb/one/getHp_N", parameter: ["strDate":"2015-05-25","strRow":"1"]).successHandle(action: networkSuccessHandle).failureHandle(action: networkFailureHandle)
    }
    
    private func getNetworkInstance() -> YHNetwork {
    
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
