//
//  FileDownloadOperation.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/4.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class FileDownloadOperation: Operation {

    private var _executing: Bool = false
    private var _finished: Bool = false
    
    /** 数据库 */
    fileprivate lazy var dao: FileDownloadDao = {
        let dao = FileDownloadDao()
        return dao
    }()
    /** Session会话 */
    fileprivate var session: URLSession?
    /** Task任务 */
    private var task: URLSessionDataTask?
    /** 文件的全路径 */
    fileprivate var fileFullPath: String?
    /** 当前已经下载的文件的长度 */
    fileprivate var currentFileSize: Int64 = 0
    /** 输出流 */
    fileprivate var outputStream: OutputStream?

    fileprivate var model: FileDownloadVO?
    
    /**
     *  创建下载工具对象
     */
    init(withModel model: FileDownloadVO) {
        super.init()
        self.model = model;  //很关键
        //创建下载任务
        creatDownloadSessionTaskWithURLString(model.urlStr!)
    }
    
    //MARK: - Create Session And Task
    func creatDownloadSessionTaskWithURLString(_ urlString: String) {
    
        //赋值全路径
        self.fileFullPath = self.model?.localPath!
        print("fullPath=", self.fileFullPath!)
        
        //获取文件已经下载的长度，断点续传需要此参数
        if let m = model {
            self.currentFileSize = m.downloadedSize;
        }
        
        //判断文件是否已经下载完毕
        if (self.currentFileSize == self.model?.totalSize && self.currentFileSize != 0) {
            print("文件已经下载完毕")
            return;
        }
        //创建会话
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString) as! URL)
        
        //设置请求头
        let range = String(format: "bytes=%zd-", self.currentFileSize)
        request.setValue(range, forHTTPHeaderField: "Range")

        //创建任务
        self.task = session.dataTask(with: request as URLRequest)
        self.session = session;
    }
    
    //MARK: - Operate The Download State
    /**
     *  暂停下载
     */
    func suspendDownload() {
        print("suspendDownload")
        
        if self.task != nil {
            self.willChangeValue(forKey: "isExecuting")
            _executing = false
            self.didChangeValue(forKey: "isExecuting")
            self.model?.status = .kDownloadStatusSuspended
            self.task?.suspend()
        }
        //保存当前下载进度
        self.dao.updateWithID(self.model!)
    }
    /**
     *  继续下载
     */
    func resumeDownload() {
        NSLog("resumeDownload")
        
        if (self.model?.status == .kDownloadStatusCompleted) {
            return;
        }
        self.model?.status = .kDownloadStatusRunning
        
        self.willChangeValue(forKey: "isExecuting")
        self.task?.resume()
        _executing = true;
        self.didChangeValue(forKey: "isExecuting")
    }
    
    // MARK: - Overwrite Methods
    override func start() {
        print("start==========")
        // 如果我们取消了在开始之前，我们就立即返回并生成所需的KVO通知
        if (self.isCancelled) {
            // 我们取消了该 operation，那么就要告诉KVO，该operation还未执行完成（isFinished == NO）
            // 这样，调用的队列（或者线程）会继续执行。
            self.willChangeValue(forKey: "isFinished")
            _finished = false
            self.didChangeValue(forKey: "isFinished")
        } else {
            // 没有取消，那就要告诉KVO，该队列开始执行了（isExecuting）！那么，就会调用main方法，进行同步执行。
            self.willChangeValue(forKey: "isExecuting")
            _executing = true
            self.task?.resume()
            self.model?.status = .kDownloadStatusRunning
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    override func main() {
        print("main=================")
        // 新建一个自动释放池，如果是异步执行操作，那么将无法访问到主线程的自动释放池
        autoreleasepool {
            if (self.isCancelled) {
                return;
            }
        }
    }

    override var isExecuting: Bool {
        return _executing
    }
    
    override var isFinished: Bool {
        return _finished
    }

    override var isConcurrent: Bool {
        return true
    }
    
    override var isAsynchronous: Bool {
        return true
    }

    override func cancel() {
        
        self.willChangeValue(forKey: "isCancelled")
        super.cancel()
        self.task?.cancel()
        self.task = nil
        self.didChangeValue(forKey: "isCancelled")
        self.completeOperation()
    }
    
    fileprivate func completeOperation() {
        self.willChangeValue(forKey: "isFinished")
        self.willChangeValue(forKey: "isExecuting")
        
        _executing = false
        _finished = true
        
        self.didChangeValue(forKey: "isExecuting")
        self.didChangeValue(forKey: "isFinished")
    }
}

extension FileDownloadOperation: URLSessionDataDelegate {
    //MARK: - URLSessionDataDelegate
    
    //收到响应
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        NSLog("didReceiveResponse")
        
        // 创建输出流，并打开流
        if self.fileFullPath != nil {
            
            let outputStream = OutputStream(toFileAtPath: self.fileFullPath!, append: true)
            outputStream?.open()
            self.outputStream = outputStream!
        }
        
        // 如果当前已经下载的文件长度等于0，那么就需要将总长度信息存入数据库
        if (self.currentFileSize == 0) {
            
            // 别忘了设置总长度
            self.model?.totalSize = response.expectedContentLength;
            self.dao.updateWithID(self.model!)
        }
        //允许收到响应
        completionHandler(.allow)
    }
    
    //收到数据
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        // 通过输出流写入数据
        let bytesWritten = data.withUnsafeBytes { (bytes) in
            self.outputStream?.write(bytes, maxLength: data.count)
        }
        print("bytesWritten = \(bytesWritten)")
        
        // 将写入的数据的长度计算加进当前的已经下载的数据长度
        self.currentFileSize += data.count
        
        //更新下载进度
        self.model?.downloadedSize = self.currentFileSize;
        print("didReceiveData",self.currentFileSize,(self.model?.totalSize)!)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error == nil {
            self.model?.status = .kDownloadStatusCompleted
            self.completeOperation()
        }
        else if (self.model?.status == .kDownloadStatusSuspended) {
            self.model?.status = .kDownloadStatusSuspended
        }
        else if ((error as! NSError).code < 0) {
             // 网络异常
            self.model?.status = .kDownloadStatusFailed
        }
        else {
            print(error ?? "下载出错")
        }
        //更新下载状态
        self.dao.updateWithID(self.model!)
        
        // 关闭输出流 并关闭强指针
        self.outputStream?.close()
        self.outputStream = nil
        // 关闭会话
        self.session?.invalidateAndCancel()
    }
}
