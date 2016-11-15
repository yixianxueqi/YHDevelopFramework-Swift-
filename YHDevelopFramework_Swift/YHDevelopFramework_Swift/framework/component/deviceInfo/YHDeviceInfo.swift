//
//  YHDeviceInfo.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/11.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import CoreTelephony
import KeychainAccess

private let service = "com.yht.service"
private let uuidKey = "uuid"

class YHDeviceInfo {
    //获取app名称
    static var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    //获取Bundle Identifier
    static var bundleIdentifier: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
    }
    //获取app版本
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    //获取app build版本
    static var appBuildVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    //获取uuid
    static var uuid: String? {
        let keychain = Keychain(service:service)
        if let uuid = keychain[uuidKey], !uuid.isEmpty {
            return uuid
        } else {
            let uuid = UUID().uuidString.lowercased()
            keychain[uuidKey] = uuid
            return uuid
        }
    }
    //获取设备序列号
    static var deviceSerialNum: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    //获取设备别名
    static var deviceNameDefineByUser: String {
        return UIDevice.current.name
    }
    //获取设备名称
    static var deviceName: String {
        return UIDevice.current.systemName
    }
    //获取设备系统版本
    static var deviceSystemVersion: String {
        return UIDevice.current.systemVersion
    }
    //获取设备型号
    static var deviceModel: String {
        return UIDevice.current.model
    }
    //获取设备区域型号
    static var deviceLocalModel: String {
        return UIDevice.current.localizedModel
    }
    //获取运营商信息
    static var operatorInfo: String {
        return CTTelephonyNetworkInfo().subscriberCellularProvider?.carrierName ?? ""
    }
    //获取电池状态
    static var batteryState: UIDeviceBatteryState {
        return UIDevice.current.batteryState

    }
    //获取电量等级
    static var batteryLevel: String {
        return String(UIDevice.current.batteryLevel)
    }
}
