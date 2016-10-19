//
//  YHNetworkReachability.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/19.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Alamofire

let YHNotificationListener = "YHNetworkNotificationListener"
let statusInfo = "status"

enum YHNetworkStatus: String {
    case unknown = "network unknown"
    case notReachable = "network  notReachable"
    case ethernetOrWiFi = "network ethernetOrWiFi"
    case wwan = "network wwan"
}

class YHNetworkReachability {
    
    static let reachability = YHNetworkReachability()
    private init(){}
    
    private var reachability: NetworkReachabilityManager?
    private var manager: NetworkReachabilityManager? {
    
        reachability = NetworkReachabilityManager()
        reachability?.listener = { status in
            var networkStatus: YHNetworkStatus?
            switch status {
            case .unknown:
                networkStatus = .unknown
            case .notReachable:
                networkStatus = .notReachable
            case .reachable(.ethernetOrWiFi):
                networkStatus = .ethernetOrWiFi
            case .reachable(.wwan):
                networkStatus = .wwan
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YHNotificationListener), object: self, userInfo: [statusInfo: networkStatus!])
        }
        return reachability
    }
    
    func startListenNetwork() {
        
        manager?.startListening()
    }
}
