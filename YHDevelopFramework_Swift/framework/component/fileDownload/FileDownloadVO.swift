//
//  FileDownloadVO.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/4.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

enum DownloadStatus: Int32 {
    case kDownloadStatusNone = 0       // 初始状态
    case kDownloadStatusRunning = 1    // 下载中
    case kDownloadStatusSuspended = 2  // 下载暂停
    case kDownloadStatusCompleted = 3  // 下载完成
    case kDownloadStatusFailed  = 4    // 下载失败
    case kDownloadStatusWaiting = 5    // 等待下载
}

typealias DownloadStatusChanged = (FileDownloadVO)->Void
typealias DownloadProgressChanged = (FileDownloadVO)->Void

class FileDownloadVO: NSObject {
    /**
     *  下载记录ID
     */
    var ID: Int32 = 0
    /**
     *  下载文件名
     */
    var fileName: String?
    /**
     *  下载地址
     */
    var urlStr: String?
    /**
     *  已下载的大小
     */
    var downloadedSize: Int64 = 0 {
        didSet {
            if self.onProgressChanged != nil {
                print("progress changed")
                self.onProgressChanged!(self)
            }
        }
    }
    /**
     *  文件总大小
     */
    var totalSize: Int64 = 0
    /**
     *  下载进度
     */
    var progress: Float {
        //下载进度可通过文件的已下载大小和总大小计算得来
        return (totalSize > 0) ? Float(downloadedSize) / Float(totalSize) : 0.0
    }
    /**
     *  文件保存绝对路径（含文件名，由调用方保证文件名不会冲突），如果传nil，则采用默认
     */
    var localPath: String?
    /**
     *  文件下载状态
     */
    var status: DownloadStatus = .kDownloadStatusNone {
        didSet {
            if self.onStatusChanged != nil {
                print("status changed")
                self.onStatusChanged!(self)
            }
        }
    }
    /**
     *  下载状态描述
     */
    var statusText: String? {
        switch self.status {
        case .kDownloadStatusRunning:
            return "下载中"
        case .kDownloadStatusSuspended:
            return "暂停下载"
        case .kDownloadStatusCompleted:
            return "下载完成"
        case .kDownloadStatusFailed:
            return "下载失败"
        case .kDownloadStatusWaiting:
            return "等待下载"
        default:
            return ""
        }
    }
    /**
     *  子类化的NSOperation，用于专门做下载
     */
    var operation: FileDownloadOperation?
    
    /**
     *  下载状态变化的回调
     */
    var onStatusChanged: DownloadStatusChanged?
    /**
     *  下载进度变化的回调
     */
    var onProgressChanged: DownloadProgressChanged?
    
    //localPath可以传空，代表默认
    convenience init(fileName: String, url: String, localPath: String?) {
        self.init()
        self.fileName = fileName
        self.urlStr = url
        self.localPath = localPath
    }
}
