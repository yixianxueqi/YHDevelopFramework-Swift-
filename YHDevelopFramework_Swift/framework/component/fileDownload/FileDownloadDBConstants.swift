//
//  FileDownloadDBConstants.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/14.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit


private let TABLE_FILEINFO = "FileInfo"
let fileID = "ID"
let fileName = "fileName"
let urlStr = "urlStr"
let downloadedSize = "downloadedSize"
let totalSize = "totalSize"
let localPath = "localPath"
let status = "status"

class FileDownloadDBConstants: NSObject {

    static func tableName() -> String {
        return TABLE_FILEINFO
    }

    static func getCreateSQL() -> String {
        return String(format: "CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ INTEGER, %@ TEXT, %@ INTEGER)", TABLE_FILEINFO, fileID, fileName, urlStr, downloadedSize, totalSize, localPath, status)
    }
    
    static func getQuerySQL() -> String {
        return String(format: "SELECT * FROM %@ WHERE %@ = ?", TABLE_FILEINFO, urlStr)
    }
    
    static func getQuerySQLV2() -> String {
        return String(format: "SELECT * FROM %@ WHERE %@ = ?", TABLE_FILEINFO, fileID)
    }
    
    static func getQuerySQLV3() -> String {
        return String(format: "SELECT * FROM %@", TABLE_FILEINFO)
    }
    
    static func getInsertSQL() -> String {
        
        return String(format: "INSERT INTO %@(%@, %@, %@, %@, %@, %@) VALUES (?,?,?,?,?,?)",  TABLE_FILEINFO,
            fileName, urlStr, downloadedSize, totalSize, localPath, status)
    }

    static func getAlterSQL() -> String {
        return String(format: "UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ?", TABLE_FILEINFO,fileName, urlStr, downloadedSize, totalSize, localPath, status, fileID)
    }
    
    static func getDeleteSQL() -> String {
        return String(format: "DELETE FROM %@ WHERE %@ = ?", TABLE_FILEINFO, fileID)
    }

    static func getDeleteAllSQL() -> String {
        return String(format: "DELETE FROM %@", TABLE_FILEINFO)
    }
}
