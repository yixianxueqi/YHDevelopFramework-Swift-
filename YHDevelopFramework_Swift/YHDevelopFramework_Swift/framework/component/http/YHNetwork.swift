//
//  YHNetwork.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/9.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Alamofire

class YHNetwork: NSObject {
    
    static var baseURL: String?
    var header: HTTPHeaders?
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let mainQueue = DispatchQueue.main
    private var successAction: HttpResultHandle?
    private var failureAction: HttpResultHandle?
    
    @discardableResult
    func getRequest(url: String, parameter: Parameters? = nil) -> YHNetwork {
        
        Alamofire.request(getRealUrl(url), method: .get, parameters: parameter, headers: header).validate().responseJSON(queue: utilityQueue) { (response) in
            switch response.result {
            case .success:
                log.info("GET SUCCESS:\n\(response.request!)\n\(response.timeline)\n\(response.response!)\n\(response.result.value!)")
                self.mainQueue.async {
                    if self.successAction != nil {
                        self.successAction!(true, response.result.value!)
                    }
                }
            case .failure(let error):
                log.error("GET ERROR:\n\(error)")
                self.mainQueue.async {
                    if self.failureAction != nil {
                        self.failureAction!(false, error)
                    }
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
                log.info("POST SUCCESS:\n\(response.request!)\n\(response.timeline)\n\(response.response!)\n\(response.result.value!)")
                self.mainQueue.async {
                    if self.successAction != nil {
                        self.successAction!(true, response.result.value!)
                    }
                }
            case .failure(let error):
                log.error("POST ERROR:\n\(error)")
                self.mainQueue.async {
                    if self.failureAction != nil {
                        self.failureAction!(false, error)
                    }
                }
            }
        }
        return self
    }
    
    @discardableResult
    func successHandle(action: @escaping HttpResultHandle) -> YHNetwork {
        
        successAction = action
        return self
    }
    
    @discardableResult
    func failureHandle(action: @escaping HttpResultHandle) -> YHNetwork {
        
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
