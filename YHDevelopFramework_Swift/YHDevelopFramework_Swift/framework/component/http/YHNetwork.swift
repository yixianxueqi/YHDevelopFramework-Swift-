//
//  YHNetwork.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/9.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Alamofire

typealias CompleteSuccess = (Any) -> Void
typealias CompleteFailure = (Error) -> Void

class YHNetwork: YHLoggerProtocol {
    
    static var baseURL: String?
    var header: HTTPHeaders?
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let mainQueue = DispatchQueue.main
    private var successAction: CompleteSuccess?
    private var failureAction: CompleteFailure?
    
    @discardableResult
    func getRequest(url: String, parameter: Parameters? = nil) -> YHNetwork {
        
        Alamofire.request(getRealUrl(url), method: .get, parameters: parameter, headers: header).validate().responseJSON(queue: utilityQueue) { (response) in
            switch response.result {
            case .success:
                self.log.info("** network success:\n\(response.request!)\n\(response.timeline)\n\(response.response)\n\(response.result.value)")
                self.mainQueue.async {
                    self.successAction!(response.result.value!)
                }
            case .failure(let error):
                self.log.error("** network error:\n\(error)")
                self.mainQueue.async {
                    self.failureAction!(error)
                }
            }
        }
        return self
    }
    
    @discardableResult
    func postRequest(url: String, parameter: Parameters? = nil ) -> YHNetwork {
    
        Alamofire.request(getRealUrl(url), method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                self.log.info("** network success:\n\(response.request!)\n\(response.timeline)\n\(response.response)\n\(response.result.value)")
                self.mainQueue.async {
                    self.successAction!(response.result.value!)
                }
            case .failure(let error):
                self.log.error("** network error:\n\(error)")
                self.mainQueue.async {
                    self.failureAction!(error)
                }
            }
        }
        return self
    }
    
    @discardableResult
    func successHandle(action: @escaping CompleteSuccess) -> YHNetwork {
        
        successAction = action
        return self
    }
    
    @discardableResult
    func failureHandle(action: @escaping CompleteFailure) -> YHNetwork {
        
        failureAction = action
        return self
    }
    //获取完整url
    func getRealUrl(_ url: String) -> String {
        
        if YHNetwork.baseURL != nil {
            return YHNetwork.baseURL! + url
        } else {
            return url
        }
    }
    
}
