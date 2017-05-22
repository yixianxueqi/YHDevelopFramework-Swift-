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
    
    /// 添加一个新项
    /// 新项数据结构形式为字典，新项可以为nil，存储时将被转化为"",取出时将被转化为[:]
    /// value值可为nil，为nil时将自动转化为"";例：
    /// ["aaa": nil] => ["aaa": ""]
    /// nil => ""
    ///
    /// - Parameters:
    ///   - loginInfo: 登录信息
    ///   - loginResult: 登录成功信息
    public func saveLoginInfo(loginInfo: Parameter, loginResult: Parameter) -> Void {
        
        dbManager.saveLoginInfo(loginInfo: self.dicToJson(loginInfo), loginResult: self.dicToJson(loginResult), loginFlag: "1", loginDate:self.getDateStamp())
    }
    
    /// 获取当前登录信息
    /// 若不存在，则返回nil
    ///
    /// - Returns: optional(Result)
    public func getCurrentLoginInfo() -> Result? {
        
        var expectResult:Result = [:]
        let result = dbManager.getCurrentLoginInfo()
        if result != nil {
            for (key, value) in result! {
                expectResult.updateValue(self.jsonToDic(value), forKey: key)
            }
            return expectResult
        }
        return nil
    }
    
    /// 获取最近几条历史记录
    ///
    /// - Parameter count: 0表示获取全部的
    /// - Returns: List of Result
    public func getHistoryList(_ count: Int) -> [Result] {
    
        var expectResultList:[Result] = []
        let result = dbManager.getRecentList(count)
        if  result.count != 0 {
            for item in result {
                var expectResult:Result = [:]
                for (key,value) in item {
                    expectResult.updateValue(self.jsonToDic(value), forKey: key)
                }
                expectResultList.append(expectResult)
            }
        }
        return expectResultList
    }
    
    /// 重置登录状态，即登出
    public func replaceLoginState() -> Void {
    
        dbManager.replaceLoginState()
    }
    
    /// 清除所有的历史信息
    public func clear() -> Void {
    
        dbManager.clear()
    }
    // MARK: - private
    
    
    /// 获取时间戳
    ///
    /// - Returns: String
    private func getDateStamp() -> String {
    
        return String.init(Date().timeIntervalSince1970)
    }
    
    
    /// 将字典转Json字符串
    /// 字典为nil返回"",value为nil转化为""
    ///
    /// - Parameter dic: 字典
    /// - Returns: Json String
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
    
    
    /// 将Json转字典
    /// json字符串为nil或"",将转为[:]
    ///
    /// - Parameter json: Json string
    /// - Returns: 字典
    private func jsonToDic(_ json: String?) -> [String: String] {
    
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
        return dic as! [String : String]
    }
}
