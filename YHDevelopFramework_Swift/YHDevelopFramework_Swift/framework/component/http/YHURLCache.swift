//
//  YHURLCache.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/19.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

let oneKB = 1024
let oneMB = 1024 * 1024
let oneGB = 1024 * 1024 * 1024

class YHURLCache {
    
    let cache = URLCache.shared
    
    private let memoryCap = 10 * oneMB
    private let diskCap = 20 * oneMB
    
    static let defaultCache = YHURLCache()
    private init() {
        customCache()
    }
    
    private func customCache() {
    
        cache.memoryCapacity = memoryCap
        cache.diskCapacity = diskCap
    }
    //获取缓存结果
    func cachedResponse(for request:URLRequest) -> CachedURLResponse? {
    
        return cache.cachedResponse(for: request)
    }
    //缓存
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
    
        checkCapacity()
        cache.storeCachedResponse(cachedResponse, for: request)
    }
    //清理缓存
    func clearCache() {
        
        cache.removeAllCachedResponses()
    }
    //检验缓存可用容量并在达到临界值时清理
    private func checkCapacity() {
        
        if cache.currentMemoryUsage > memoryCap - oneMB || cache.currentDiskUsage > diskCap - oneMB {
            clearCache()
        }
    }
    
    
    
}
