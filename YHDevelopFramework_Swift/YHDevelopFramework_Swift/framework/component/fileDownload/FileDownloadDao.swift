//
//  FileDownloadDao.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/7.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import FMDB

class FileDownloadDao: NSObject {
    
    var dbQueue = FileDownloadDBUtil.getDBQueue()
    
    deinit {
        dbQueue.close()
    }
    /**
     * 根据下载记录ID查询
     */
    func queryWithID(ID: Int) -> FileDownloadVO? {

        var vo: FileDownloadVO? = nil

        dbQueue.inDatabase { (database) in
            if let db = database {
               let result = db.executeQuery(FileDownloadDBConstants.getQuerySQLV2(), withArgumentsIn: [ID])
                
                if let rs = result {
                    if rs.next() {
                        vo = self.assignEntityFromFMResultSet(rs)
                    }
                    rs.close()
                }
            }
        }
        
        return vo
    }
    
    /**
     *  根据下载地址查询
     */
    func queryWithURL(_ url: String) -> FileDownloadVO? {
        
        var vo:FileDownloadVO? = nil
        
        dbQueue.inDatabase { (database) in
            if let db = database {
                let result = db.executeQuery(FileDownloadDBConstants.getQuerySQL(), withArgumentsIn: [url])
                if let rs = result {
                    if rs.next() {
                        vo = self.assignEntityFromFMResultSet(rs)
                    }
                    rs.close()
                }
            }
        }
        
        return vo
    }
    
    /**
     *  查询所有记录
     */
    func queryAll() -> [FileDownloadVO] {
        
        var voList = [FileDownloadVO]()
        
        dbQueue.inDatabase { (database) in
            if let db = database {
                let result = db.executeQuery(FileDownloadDBConstants.getQuerySQLV3(), withArgumentsIn: nil)
                if let rs = result {
                    while rs.next() {
                       let vo = self.assignEntityFromFMResultSet(rs)
                        voList.append(vo)
                    }
                    rs.close()
                }
            }
        }
        
        return voList
    }
    
    private func assignEntityFromFMResultSet(_ rs:FMResultSet) -> FileDownloadVO {
        let vo = FileDownloadVO()
        vo.ID = rs.int(forColumn: fileID)
        vo.fileName = rs.string(forColumn: fileName)
        vo.urlStr = rs.string(forColumn: urlStr)
        vo.downloadedSize = rs.longLongInt(forColumn: downloadedSize)
        vo.totalSize = rs.longLongInt(forColumn: totalSize)
        vo.localPath = rs.string(forColumn: localPath)
        vo.status = DownloadStatus(rawValue: rs.int(forColumn: status))!
        
        return vo
    }
    
    /**
     * 新增
     */
    func insertWithEntity(_ vo: FileDownloadVO) {
        
        dbQueue.inDatabase { (database) in
            if let db = database {
                do {
                    try db.executeUpdate(FileDownloadDBConstants.getInsertSQL(), values: [vo.fileName!, vo.urlStr!, vo.downloadedSize, vo.totalSize, vo.localPath!, vo.status.rawValue])
                } catch {
                    print(db.hadError())
                }
            }
        }
    }
    
    /**
     *  修改
     */
    func updateWithEntity(_ vo: FileDownloadVO) {
        dbQueue.inDatabase { (database) in
            if let db = database {
                do {
                    try db.executeUpdate(FileDownloadDBConstants.getAlterSQL(), values: [vo.fileName!, vo.urlStr!, vo.downloadedSize, vo.totalSize, vo.localPath!, vo.status.rawValue])
                } catch {
                    print(db.hadError())
                }
            }
        }
    }
    
    func updateWithID(_ vo: FileDownloadVO) {
        dbQueue.inDatabase { (database) in
            if let db = database {
                do {
                    try db.executeUpdate(FileDownloadDBConstants.getAlterSQL(), values: [vo.fileName!, vo.urlStr!, vo.downloadedSize, vo.totalSize, vo.localPath!, vo.status.rawValue, vo.ID])
                } catch {
                    print(db.hadError())
                }
            }
        }
    }
    
    /**
     * 删除
     */
    func deleteWithEntity(_ vo: FileDownloadVO) {
        dbQueue.inDatabase { (database) in
            if let db = database {
                do {
                    try db.executeUpdate(FileDownloadDBConstants.getDeleteSQL(), values: [ vo.ID])
                } catch {
                    print(db.hadError())
                }
            }
        }
    }
}
