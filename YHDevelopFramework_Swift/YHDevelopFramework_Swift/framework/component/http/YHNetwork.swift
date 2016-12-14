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
    
    static var baseURL: String?//http://ip:port
    static var timeOut: TimeInterval = 15.0//超时
    var header: HTTPHeaders?//请求头
    var commonParam: Parameters?//公共参数
    var isStoreCache: Bool = false//是否缓存
    var isUseCache: Bool = false//是否使用缓存

    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let mainQueue = DispatchQueue.main
    private let cache = YHURLCache.defaultCache
    private var successAction: HttpResultHandle? {
        didSet {
            if isUseCache, let cacheResult = storeCacheResult {
                successAction!(cacheResult.0,cacheResult.1)
            }
        }
    }
    private var failureAction: HttpResultHandle?
    private var progressAction: HttpProgressHandle?
    private var sessionMnager: SessionManager?
    private var storeCacheResult: (Bool,String)?
    
    override init() {
        
        super.init()
        sessionMnager = self.getSessionManager()
    }
    // MARK: - https证书
    func setHttpsCerPath(_ path:NSString) {
    
        sessionMnager?.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器证书
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust {
                log.debug("https服务端证书认证")
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
                let cerPath = path as String
                let cerUrl = URL(fileURLWithPath:cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
                
                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential,
                            URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    
                } else {
                    return (.cancelAuthenticationChallenge, nil)
                }
            }
            // 其它情况（不接受认证）
            else {
                log.warning("https其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    // MARK: - Method
    //get
    @discardableResult
    func getRequest(url: String, parameter: Parameters? = nil) -> YHNetwork {
        
        let realUrl = getRealUrl(url)
        let realParameters = getRealParameters(parameter)
        var urlRequest: URLRequest?
        do {
            urlRequest = try URLRequest(url: realUrl, method:.get, headers: header)
            urlRequest = try URLEncoding.default.encode(urlRequest!, with: realParameters)
        } catch {
            log.error("network get urlRequest error:\(error)")
        }
        //是否使用缓 && 缓存存在
        if isUseCache, let json = useCache(urlRequest!) {
            storeCacheResult = (true,json)
            return self
        }
        sessionMnager?.request(realUrl, method: .get, parameters: realParameters, headers: header)
            .validate()
            .responseJSON(queue: utilityQueue) { (response) in
            switch response.result {
            case .success:
                log.debug("GET SUCCESS:\n\(response.request!)\n\(response.timeline)\n\(response.response!)\n\(response.result.value!)")
                if self.isStoreCache {
                    self.storeCacahe(urlRequest!, response: response.response!, data: response.data!)
                }
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
    
        let realUrl = getRealUrl(url)
        let realParameters = getRealParameters(parameter)
        var urlRequest: URLRequest?
        do {
            var identifier: String!
            if let realDic = realParameters {
                identifier = realUrl + String.init((realDic as NSDictionary).hashValue)
            } else {
                identifier = realUrl
            }
            urlRequest = try URLRequest(url: identifier, method:.post, headers: header)
        } catch {
            log.error("network get urlRequest error:\(error)")
        }
        //是否使用缓存 && 缓存存在
        if isUseCache, let json = useCache(urlRequest!) {
            storeCacheResult = (true,json)
            return self
        }
        sessionMnager?.request(realUrl, method: .post, parameters: realParameters, encoding: JSONEncoding.default, headers: header)
            .validate()
            .responseJSON { (response) in
            switch response.result {
            case .success:
                log.debug("POST SUCCESS:\n\(response.request!)\n\(response.timeline)\n\(response.response!)\n\(response.result.value!)")
                if self.isStoreCache {
                    self.storeCacahe(urlRequest!, response: response.response!, data: response.data!)
                }
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
            log.debug("download data")
            sessionMnager?.download(getRealUrl(url), method: .post, parameters: getRealParameters(parameter), encoding: JSONEncoding.default, headers: header, to: nil)
                .downloadProgress(queue: mainQueue) { progress in
                    log.debug("download progress\(progress.fractionCompleted)")
                    self.progressAction?(progress.fractionCompleted)
                }
                .responseData(queue: mainQueue) { response in
                    switch response.result {
                    case .success: self.successAction?(true,response.result.value!)
                    case .failure(let error): self.failureAction?(false,error)
                    }
            }
        } else {
            log.debug("download file")
            let destination = DownloadRequest.suggestedDownloadDestination(for: directory, in: domain)
            sessionMnager?.download(getRealUrl(url), method: .post, parameters: getRealParameters(parameter), encoding: JSONEncoding.default, headers: header, to: destination)
                .downloadProgress(queue: mainQueue) { progress in
                    log.debug("download progress\(progress.fractionCompleted)")
                    self.progressAction?(progress.fractionCompleted)
                }
                .response(queue: mainQueue) { response in
                    if response.error != nil {
                        self.failureAction?(false, response.error!)
                    } else {
                        self.successAction?(true,response.destinationURL?.path ?? "")
                    }
            }
        }
        return self
    }
    //upload
    func uploadRequest(url: String, type: HttpStreamType? = .DataStream, obj: Any) -> YHNetwork {
        
        if type == .DataStream {
            log.debug("upload data")
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
            log.debug("upload file")
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
    //是否使用缓存
    private func useCache(_ request: URLRequest) -> String? {
        let urlResponse = cache.cachedResponse(for: request)
        if let data = urlResponse?.data {
            log.debug("use cache")
            return JSON(data: data).rawString()
        }
        return nil
    }
    //是否缓存
    private func storeCacahe(_ request: URLRequest,response: HTTPURLResponse, data: Data) {
        log.debug("store cache")
        let urlResponse = CachedURLResponse.init(response: response, data: data)
        cache.storeCachedResponse(urlResponse, for: request)
    }
}
