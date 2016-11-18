//
//  FileDownloadManager.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/4.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

private let DEFAULT_SAVE_DIRECTORY = NSHomeDirectory().appending("/Documents/FileDownload/")

class FileDownloadManager: NSObject {

    //存放下载任务列表
   private var fileDownloadModels: [FileDownloadVO] = []
    
    /**
     *  获取文件下载管理器对象
     */
    static let sharedInstance = FileDownloadManager()
    private override init(){
        super.init()
        //从数据库读取之前已添加的所有任务
        let voListFromDB = self.dao.queryAll()
        if voListFromDB.count > 0 {
            fileDownloadModels.append(contentsOf: voListFromDB)
        }
        //添加应用程序退出的通知
        addNotification()
    }
    
    /**
     *  设置最大线程数
     *
     *  @param threadNum   最大线程数(可同时下载的最大文件数)，取值[1-5]，超出取默认值3
     */
    func setMaxThread(_ threadNum: Int) {
    
        var temNum = threadNum
        if threadNum < 1 || threadNum > 5 {
            temNum = 3
        }
        operationQueue.maxConcurrentOperationCount = temNum
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminateNotification), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    //应用程序退出 保存状态
    @objc private func appWillTerminateNotification() {
        
        print("applicationWillTerminate")

        for vo in fileDownloadModels {
            if vo.status == .kDownloadStatusRunning {
                vo.status = .kDownloadStatusSuspended
                self.dao.updateWithID(vo)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     *  创建存放路径
     */
    private func createSaveDirectory(dirPath: String) {
        //默认路径
        var saveDir = dirPath
        if dirPath.isEmpty {
            saveDir = DEFAULT_SAVE_DIRECTORY
        }
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: saveDir) {
            do {
                try fileManager.createDirectory(atPath: saveDir, withIntermediateDirectories: true, attributes: nil)
            } catch  {
                print(error)
            }
        }
    }
    
    /**
     *  添加一个下载任务，不启动
     *
     *  @param model 文件下载对象的数据信息对象
     */
    func addTaskWithFileDownloadEntity(_ model: FileDownloadVO) {
        
        let vo:FileDownloadVO? = self.dao.queryWithURL(model.urlStr!)
        
        if vo == nil {// 如果数据库里没有有记录,追加数据

            //拼接文件路径
            if model.localPath == nil {
                //创建默认存储路径
                self.createSaveDirectory(dirPath: DEFAULT_SAVE_DIRECTORY)
                model.localPath = DEFAULT_SAVE_DIRECTORY.appending(model.fileName!)
            } else {
                let saveDir = (model.localPath! as NSString).deletingLastPathComponent
                createSaveDirectory(dirPath: saveDir)
            }
            
            //存入数据库
            self.dao.insertWithEntity(model)
            let dbVO = self.dao.queryWithURL(model.urlStr!)
            model.ID = dbVO!.ID //赋值ID
            fileDownloadModels.append(model)
        }
    }
    
    /**
     *  开始下载
     */
    func startWithFileDownloadEntity(_ model: FileDownloadVO) {
        if (model.status != .kDownloadStatusCompleted) {
            model.status = .kDownloadStatusRunning
            
            if (model.operation == nil) {
                model.operation = FileDownloadOperation.init(withModel: model)
                self.operationQueue.addOperation(model.operation!)
            } else {
                model.operation?.resumeDownload()
            }
        }
    }
    
    /**
     *  暂停下载
     */
    func suspendWithFileDownloadEntity(_ model: FileDownloadVO) {
        if (model.status != .kDownloadStatusCompleted) {
            model.operation?.suspendDownload()
        }
    }
    
    /**
     *  继续下载
     */
    func resumeWithFileDownloadEntity(_ model: FileDownloadVO) {
        if (model.status != .kDownloadStatusCompleted) {
            
            if (model.operation == nil) {
                model.operation = FileDownloadOperation.init(withModel: model)
                model.operation?.resumeDownload()
            } else {
                model.operation?.resumeDownload()
            }
        }
    }
    
    /**
     *  停止下载
     */
    func stopWithFileDownloadEntity(_ model: FileDownloadVO) {
        if (model.operation != nil) {
            model.operation?.cancel()
            
            //数据库删除该任务
            self.dao.deleteWithEntity(model)
        }
    }
    
    /**
     *  根据下载任务标识获取文件下载对象的数据信息对象
     *
     *  @param ID 下载记录ID
     *
     *  @return 文件下载对象的数据信息对象
     */
    func getFileDownloadEntity(_ ID: Int) -> FileDownloadVO? {
        //从数据库取对应的任务
        let vo = self.dao.queryWithID(ID:ID)
        
        return vo
    }
    
    /**
     *  根据下载地址获取文件下载对象的数据信息对象
     *
     *  @param urlStr 下载地址
     *
     *  @return 文件下载对象的数据信息对象
     */
    func getFileDownloadEntityByUrl(_ urlStr: String) -> FileDownloadVO {
        //从数据库取对应的任务
        let vo = self.dao.queryWithURL(urlStr)
        
        return vo!
    }
    
    /**
     *  获取所有的下载数据清单
     *
     *  @return 下载列表
     */
    func getDownloadList() -> [FileDownloadVO] {
        
        return fileDownloadModels
    }
    

    //MARK: - Lazy Loading

    /**
     *  下载队列（设置默认最大进程数为3）
     */
    private lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        return operationQueue
    }()

    
    //数据库
    private lazy var dao: FileDownloadDao = {
        let dao = FileDownloadDao()
        return dao
    }()

}
