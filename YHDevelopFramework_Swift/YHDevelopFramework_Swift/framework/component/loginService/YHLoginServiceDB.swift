//
//  YHLoginServiceDB.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 17/2/14.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import FMDB

/*
 数据库表结构：
 列               类型          说明
 ——————————————————————————————————————————————
 id:             integer       主键，自增长
 loginInfo:      text          登录信息
 loginResult:    text          登陆成功返回结果信息
 loginFlag:      string        登录标识
 loginDate:      string        更新日期
 */

class YHLoginServiceDB: NSObject {
    
    public typealias Parameter = Dictionary<String,String?>?
    let tableName = "loginTable"
    let loginInfo = "loginInfo"
    let loginResult = "loginResult"
    let loginFlag = "loginFlag"
    let loginDate = "loginDate"
    var dbQueue: FMDatabaseQueue? = {
    
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("loginDB.sqlite")
        guard let database = FMDatabaseQueue.init(path: fileURL.path)  else {
            log.error("create loginDB failure")
            return nil;
        }
        return database
    }()
    
    // MARK: - public
    public override init() {
        super.init()
        createTable()
    }
    
    public func saveLoginInfo(loginInfo: String, loginResult: String, loginFlag: String, loginDate: String) -> Void {
    
        dbQueue?.inTransaction({ (database, rollback) in
            guard database!.open() else {
                log.error("Unable to open database")
                return
            }
            //先判断是否存在，若存在则更新，不存在则添加
            //无论添加还是更新，需维护登录是否失效标示唯一
            let querySql = "select * from \(self.tableName) where \(self.loginInfo) = \'\(loginInfo)\'"
            let updateOldState = "update \(self.tableName) set \(self.loginFlag) = \'\("0")\' where \(self.loginFlag) = \'\("1")\'"
            do{
                let resultState = database?.executeUpdate(updateOldState, withArgumentsIn: nil)
                let resultSet = try database?.executeQuery(querySql, values: nil)
                if resultSet!.next() {
                    //存在
                    let updateSql = "update \(self.tableName) set \(self.loginResult) = \'\(loginResult)\', \(self.loginFlag) = \'\(loginFlag)\', \(self.loginDate) = \'\(loginDate)\' where \(self.loginInfo) = \'\(loginInfo)\'"
                    let res = database?.executeUpdate(updateSql, withArgumentsIn: nil)
                    if !(res!) || !(resultState!) {
                        rollback?.pointee = true
                        log.debug("update item failure")
                        return
                    }
                } else {
                    //不存在
                    let insertSql = "insert into \(self.tableName) (\(self.loginInfo), \(self.loginResult), \(self.loginFlag), \(self.loginDate)) values (?, ?, ?, ?);"
                    let res = database?.executeUpdate(insertSql, withArgumentsIn: [loginInfo,loginResult,loginFlag,loginDate])
                    if !(res!) || !(resultState!) {
                        rollback?.pointee = true
                        log.debug("update item failure")
                        return
                    }
                }
                resultSet?.close()
            }
            catch {
                rollback?.pointee = true
                log.debug("update item failure: \(error)")
            }
        })
    }
    
    public func getRecentList(_ recentCount: Int) -> [[String: String]] {
    
        var resultList: [[String: String]] = []
        dbQueue?.inDatabase({ (database) in
            guard database!.open() else {
                log.error("Unable to open database")
                return
            }
            var querySql: String
            if recentCount == 0 {
                querySql = "select * from \(self.tableName) order by \(self.loginDate) DESC"
            } else {
                querySql = "select * from \(self.tableName) order by \(self.loginDate) DESC limit \(recentCount)"
            }
            do {
                let resultSet = try database?.executeQuery(querySql, values: nil)
                while resultSet!.next() {
                    let result = [self.loginInfo: resultSet!.string(forColumn: self.loginInfo),
                                  self.loginResult:resultSet!.string(forColumn: self.loginResult)]
                    resultList.append(result as! [String : String])
                }
            }
            catch {
                log.error("query recentList failure: \(error)")
            } 
        })
        return resultList
    }
    
    public func getCurrentLoginInfo() -> [String: String]? {
    
        var result: [String: String]?
        dbQueue?.inDatabase({ (database) in
            guard database!.open() else {
                log.error("Unable to open database")
                return
            }
            let querySql = "select * from \(self.tableName) where \(self.loginFlag) = \'\("1")\'"
            do {
               let resultSet = try database?.executeQuery(querySql, values: nil)
                while resultSet!.next() {
                    result = [self.loginInfo: resultSet!.string(forColumn: self.loginInfo),
                              self.loginResult:resultSet!.string(forColumn: self.loginResult)]
                }
            }
            catch {
                log.error("query current LoginInfo error: \(error)")
            }
        })
        return result
    }
    
    public func replaceLoginState() -> Void {
        dbQueue?.inDatabase({ (database) in
            guard database!.open() else {
                log.error("Unable to open database")
                return
            }
            let updateSql = "update \(self.tableName) set \(self.loginFlag) = \'\("0")\' where \(self.loginFlag) = \'\("1")\'"
            let result = database?.executeUpdate(updateSql, withArgumentsIn: nil)
            if result! {
                log.debug("replace loginState success")
            } else {
                log.debug("replace loginState failure")
            }
        })
    }
    
    public func clear() -> Void {
        
        dbQueue?.inDatabase({ (database) in
            guard database!.open() else {
                log.error("Unable to open database")
                return
            }
            let deleteAllSql = "DELETE FROM \(self.tableName)"
            let result = database?.executeUpdate(deleteAllSql, withArgumentsIn: nil)
            if result! {
                log.debug("clear loginTable success")
            } else {
                log.debug("clear loginTable failure")
            }
        })
    }
    // MARK: - private
    private func createTable() -> Void {
        
        dbQueue?.inDatabase({ (database) in
            guard database!.open() else {
                log.error("Unable to open database")
                return
            }
            do {
                let createSql = "create TABLE IF NOT EXISTS \(self.tableName) (id integer PRIMARY KEY AUTOINCREMENT, \(self.loginInfo) text, \(self.loginResult) text, \(self.loginFlag) string, \(self.loginDate) string);"
                try database?.executeUpdate(createSql, values: nil)
            }
            catch {
                log.error("create loginTable failure: \(error)")
            }
        })
    }
}







