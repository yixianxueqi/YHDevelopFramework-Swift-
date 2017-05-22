//
//  FileDownloadDBUtil.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/14.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import FMDB


private let DATABASE_NAME = "FileDownload.db"

class FileDownloadDBUtil: NSObject {
    
    static func getDBQueue() -> FMDatabaseQueue {
        
        let dbPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appendingFormat("/%@", DATABASE_NAME)
        print("🐶🐶DataBasePath = \(dbPath)🐶🐶")
        
        //创建数据库，如果路径不存在会自动创建
        let dbQueue = FMDatabaseQueue(path: dbPath)
        
        dbQueue?.inDatabase({ (database) in
            
            if let db = database {
                if db.open() {
                    db.setShouldCacheStatements(true)
                    print("Open database succeed")
                } else {
                    print("Open database failed")
                }
                
                //如果需要建表
                if !db.tableExists(FileDownloadDBConstants.tableName()) {
                    do {
                        try db.executeUpdate(FileDownloadDBConstants.getCreateSQL(), values: nil)
                    } catch {
                        CFShow("create table fail" as CFTypeRef!)
                        print(error)
                    }
                }
            }
        })
        
        return dbQueue!
    }
}
