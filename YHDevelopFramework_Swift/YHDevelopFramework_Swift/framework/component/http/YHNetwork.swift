//
//  YHNetwork.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/9.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Alamofire

enum HttpStreamType {
    case DataStream
    case FileStream
}

class YHNetwork: NSObject {
    
    static var baseURL: String?
    static var timeOut: TimeInterval = 15.0
    var header: HTTPHeaders?
    var commonParam: Parameters?
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let mainQueue = DispatchQueue.main
    private var successAction: HttpResultHandle?
    private var failureAction: HttpResultHandle?
    private var progressAction: HttpProgressHandle?
    private var sessionMnager: SessionManager?
    
    override init() {
        
        super.init()
        sessionMnager = self.getSessionManager()
    }
    
    // MARK: - Method
    //get
    @discardableResult
    func getRequest(url: String, parameter: Parameters? = nil) -> YHNetwork {
        
        sessionMnager?.request(getRealUrl(url), method: .get, parameters: getRealParameters(parameter), headers: header)
            .validate()
            .responseJSON(queue: utilityQueue) { (response) in
            switch response.result {
            case .success:
                log.info("GET SUCCESS:\n\(response.request!)\n\(response.timeline)\n\(response.response!)\n\(response.result.value!)")
                self.mainQueue.async {
                    self.successAction?(true, response.result.value!)
                }
            case .failure(let error):
                log.error("GET ERROR:\n\(error)")
                self.mainQueue.async {
                    self.failureAction?(false, error)
                }
            }
        }
        return self
    }
    //post
    @discardableResult
    func postRequest(url: String, parameter: Parameters? = nil) -> YHNetwork {
    
        sessionMnager?.request(getRealUrl(url), method: .post, parameters: getRealParameters(parameter), encoding: JSONEncoding.default, headers: header)
            .validate()
            .responseJSON { (response) in
            switch response.result {
            case .success:
                log.info("POST SUCCESS:\n\(response.request!)\n\(response.timeline)\n\(response.response!)\n\(response.result.value!)")
                self.mainQueue.async {
                    self.successAction?(true, response.result.value!)
                }
            case .failure(let error):
                log.error("POST ERROR:\n\(error)")
                self.mainQueue.async {
                    self.failureAction?(false, error)
                }
            }
        }
        return self
    }
    //download
    @discardableResult
    func downLoadRequest(url: String,
                         parameter: Parameters? = nil,
                         type: HttpStreamType? = .DataStream,
                         directory: FileManager.SearchPathDirectory = .documentDirectory,
                         domain: FileManager.SearchPathDomainMask = .userDomainMask) -> YHNetwork {
        
        if type == .DataStream {
            log.info("download data")
            sessionMnager?.download(getRealUrl(url), method: .post, parameters: getRealParameters(parameter), encoding: JSONEncoding.default, headers: header, to: nil)
                .downloadProgress(queue: mainQueue) { progress in
                    log.info("download progress\(progress.fractionCompleted)")
                    self.progressAction?(progress.fractionCompleted)
                }
                .responseData(queue: mainQueue) { response in
                    switch response.result {
                    case .success: self.successAction?(true,response.result.value!)
                    case .failure(let error): self.failureAction?(false,error)
                    }
            }
        } else {
            log.info("download file")
            let destination = DownloadRequest.suggestedDownloadDestination(for: directory, in: domain)
            sessionMnager?.download(getRealUrl(url), method: .post, parameters: getRealParameters(parameter), encoding: JSONEncoding.default, headers: header, to: destination)
                .downloadProgress(queue: mainQueue) { progress in
                    log.info("download progress\(progress.fractionCompleted)")
                    self.progressAction?(progress.fractionCompleted)
                }
                .response(queue: mainQueue) { response in
                    if response.error != nil {
                        self.failureAction?(false, response.error)
                    } else {
                        self.successAction?(true,response.destinationURL?.path)
                    }
            }
        }
        return self
    }
    //upload
    func uploadRequest(url: String, type: HttpStreamType? = .DataStream, obj: Any) -> YHNetwork {
        
        if type == .DataStream {
            log.info("upload data")
            let data = obj as! Data
            sessionMnager?.upload(data, to: getRealUrl(url), method: .post, headers: header)
                .uploadProgress(queue: mainQueue, closure: { progresss in
                    self.progressAction?(progresss.fractionCompleted)
                })
                .responseJSON(queue: mainQueue, options: .allowFragments, completionHandler: { response in
                    switch response.result {
                    case .success:
                        self.successAction?(true,response.result.value!)
                    case .failure(let error):
                        self.failureAction?(false,error)
                    }
                })
        } else {
            log.info("upload file")
            let fileURL = obj as! URL
            sessionMnager?.upload(fileURL, to: getRealUrl(url), method: .post, headers: header)
                .uploadProgress(queue: mainQueue, closure: { progresss in
                    self.progressAction?(progresss.fractionCompleted)
                })
                .responseJSON(queue: mainQueue, options: .allowFragments, completionHandler: { response in
                    switch response.result {
                    case .success:
                        self.successAction?(true,response.result.value!)
                    case .failure(let error):
                        self.failureAction?(false,error)
                    }
                })
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
    
    @discardableResult
    func progressHandle(action: @escaping HttpProgressHandle) -> YHNetwork {
        
        progressAction = action
        return self
    }

    // MARK: - private Meyhod
    //获取完整url
    private func getRealUrl(_ url: String) -> String {
        
        if YHNetwork.baseURL != nil {
            return YHNetwork.baseURL! + url
        } else {
            return url
        }
    }
    //获取完整参数
    private func getRealParameters(_ parameter: Parameters?) -> Parameters? {
        
        guard let para1 = parameter else {
            return commonParam
        }
        guard  let para2 = commonParam else {
            return parameter
        }
        var realDic = Parameters()
        for (key,value) in para1 {
            realDic.updateValue(value, forKey: key)
        }
        for (key,value) in para2 {
            realDic.updateValue(value, forKey: key)
        }
        return realDic
    }
    //获取sessionManager
    private func getSessionManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = YHNetwork.timeOut
        return SessionManager(configuration: configuration)
    }
}
