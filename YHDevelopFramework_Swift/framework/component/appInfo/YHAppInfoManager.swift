//
//  YHAppInfoManager.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 17/1/3.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

class YHAppInfoManager: NSObject {
    
    private static let queryUrl = "http://itunes.apple.com/lookup?id=%@"
    private static let entryApp = "itms-apps://itunes.apple.com/app/id%@"
    private static let entryApp2 = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
    private static let mainQueue = DispatchQueue.main
    
    static func getAppInfoFromAppStore(appID: String, resultAction: @escaping (([String: AnyObject]) -> Void)) -> Void {
        
        guard appID.length > 0 else {
            return
        }
        let urlStr = String.init(format: queryUrl, appID)
        let url = URL.init(string: urlStr)
        var request = URLRequest.init(url: url!)
        request.timeoutInterval = 30.0
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data,response,error) in
            
           if let err = error {
                log.debug(err.localizedDescription)
                return
            }
            if data == nil {
                log.debug("appInfo data is nil")
                return
            }
            let dic = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
            let str = dic?["resultCount"] as! NSNumber
            let count = Int.init(str)
            if count > 0 {
                let result = dic?["results"]?.firstObject as! [String: AnyObject]
                mainQueue.async {
                   resultAction(result)
                }
            }
        })
        dataTask.resume()
    }
    
    static func entryAppStore(appID: String) -> Void {
    
        var str = ""
        if #available(iOS 7.0, *) {
            str = String.init(format: entryApp, appID)
        } else {
            str = String.init(format: entryApp2, appID)
        }
        openApp(str)
    }
    private static func openApp(_ urlStr: String) -> Void {
    
        UIApplication.shared.openURL(URL.init(string: urlStr)!)
    }
}
