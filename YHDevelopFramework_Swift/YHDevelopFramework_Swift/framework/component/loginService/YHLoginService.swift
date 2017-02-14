//
//  YHLoginService.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 17/2/14.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

class YHLoginService: NSObject {
    public typealias Parameter = Dictionary<String, String?>?
    public typealias Result = Dictionary<String,[String: String]>
    
    private let dbManager = YHLoginServiceDB()
    
    static let service = YHLoginService();
    private override init() {
        super.init()
    }
    
    // MARK: - public
    public func saveLoginInfo(loginInfo: Parameter, loginResult: Parameter) -> Void {
        
        dbManager.saveLoginInfo(loginInfo: self.dicToJson(loginInfo), loginResult: self.dicToJson(loginResult), loginFlag: "1", loginDate:self.getDateStamp())
    }
    public func getCurrentLoginInfo() -> Result? {
        
        var expectResult:Result = [:]
        let result = dbManager.getCurrentLoginInfo()
        if result != nil {
            for (key, value) in result! {
                expectResult.updateValue(self.jsonToDic(value)!, forKey: key)
            }
            return expectResult
        }
        return nil
    }
    public func getHistoryList(_ count: Int) -> [Result]? {
    
        var expectResultList:[Result] = []
        let result = dbManager.getRecentList(count)
        if  result != nil {
            for item in result! {
                var expectResult:Result = [:]
                for (key,value) in item {
                    expectResult.updateValue(self.jsonToDic(value)!, forKey: key)
                }
                expectResultList.append(expectResult)
            }
            return expectResultList
        }
        return nil
    }
    public func replaceLoginState() -> Void {
    
        dbManager.replaceLoginState()
    }
    public func clear() -> Void {
    
        dbManager.clear()
    }
    // MARK: - private
    private func getDateStamp() -> String {
    
        return String.init(Date().timeIntervalSince1970)
    }
    
    private func dicToJson(_ dic: Parameter) -> String {
    
        guard let dict = dic else {
            return ""
        }
        //nil change to ""
        var nonullDic = dict
        for (key,value) in nonullDic {
            if value == nil {
                nonullDic.updateValue("", forKey: key)
            }
        }
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: nonullDic, options: .prettyPrinted)
        } catch {
            log.error("dicToJson failure: \(error)")
        }
        guard let datas = data else {
            return ""
        }
        return String.init(data: datas, encoding: .utf8)!
    }
    
    private func jsonToDic(_ json: String?) -> [String: String]? {
    
        if json == nil || json?.length == 0 {
            return [:]
        }
        let data = json!.data(using: .utf8)
        var dic: Any?
        do {
            dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        }
        catch {
            log.error("jsonToDic failure: \(error)")
        }
        return dic as! [String: String]?
    }
}
