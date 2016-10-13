//
//  YHFileManger.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/13.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit


class YHFileManager {
    
    static var homePath: String {
        return NSHomeDirectory()
    }
    static var documentsPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    static var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }
    static var tempPath: String {
        return NSTemporaryDirectory()
    }
    static var cachePath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    static var preferencesPath: String {
        return (libraryPath as NSString).strings(byAppendingPaths: ["Preferences"]).first!
    }
    
    // MARK: - 文件操作
    //判断文件是否存在并返回结果，若不存在则创建
    static func fileIsExist(_ path: String) -> Bool {
    
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
            return false
        }
        return true
    }
    //判断目录是否存在并返回结果，若不存在则创建
    static func directoryIsExist(_ path: String) -> Bool {
    
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        if !(isDirectory.boolValue && isExist) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                log.error(error)
            }
            return false
        }
        return true
    }
    //获取文件大小
    static func fileSize(_ path: String) -> Double {
    
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            return 0
        }
        do {
            let size = try fileManager.attributesOfItem(atPath: path)[.size] as! Double
            return size
        } catch {
            log.error(error)
        }
        return 0
    }
    //获取目录大小
    static func directorySize(_ path: String) -> Double {
        
        guard directoryIsExist(path) else {
            return 0
        }
        var size: Double = 0
        for filePath in (fileOfDirectory(path)?.enumerated())! {
            size += fileSize(filePath.element)
        }
        return size
    }
    //遍历目录下所有文件路径
    static func fileOfDirectory(_ path: String) -> [String]? {
    
        guard directoryIsExist(path) else {
            return nil
        }
        let list = fileNameOfDirectory(path)
        return list?.flatMap({ (name) -> [String] in
            return (path as NSString).strings(byAppendingPaths: [name])
        })
    }
    //遍历目录下所有文件名字
    static func fileNameOfDirectory(_ path: String) -> [String]? {
        
        guard directoryIsExist(path) else {
            return nil
        }
        let fileManager = FileManager.default
        return fileManager.subpaths(atPath: path)
    }
    //删除目录
    static func deleteDirectory(_ path: String) {
    
        guard directoryIsExist(path) else {
            return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            log.error(error)
        }
        
    }
    //删除目录下所有文件
    static func deleteDirectorySubFile(_ path: String) {
    
        guard directoryIsExist(path) else {
            return
        }
        for name in (fileOfDirectory(path)?.enumerated())! {
            deleteFile(name.element)
        }
    }
    //删除文件
    static func deleteFile(_ path: String) {
    
       let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            return
        }
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            log.error(error)
        }
    }
}
