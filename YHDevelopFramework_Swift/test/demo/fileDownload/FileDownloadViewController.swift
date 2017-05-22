//
//  FileDownloadViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/4.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

private let cellIdentifier = "DownloadTableViewCell"
class FileDownloadViewController: BaseViewController {

    var downloadListTableView: UITableView?
    var downloadList = [FileDownloadVO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createDownloadList()
        downloadList = FileDownloadManager.sharedInstance.getDownloadList()
        
        createTableView()
    }
    
    func createDownloadList() {
        
        let urls = ["http://farm6.staticflickr.com/5505/9824098016_0e28a047c2_b_d.jpg",
                    "http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg",
                    "http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.4.1.dmg",
                    "http://download.xitongxz.com/Ylmf_Ghost_Win7_SP1_x64_2016_0512.iso"]
        
        for (index, url) in urls.enumerated() {
            let fileName = String.init(format: "%d-%@", arguments: [index, (url as NSString).lastPathComponent])
            let vo = FileDownloadVO(fileName: fileName, url: url, localPath: nil)
            
            //添加下载任务
            FileDownloadManager.sharedInstance.addTaskWithFileDownloadEntity(vo)
        }
    }
    
    func createTableView() {
        self.downloadListTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .plain)
        self.view.addSubview(self.downloadListTableView!)
        self.downloadListTableView?.dataSource = self
        self.downloadListTableView?.delegate = self
        self.downloadListTableView?.tableFooterView = UIView()
        self.downloadListTableView?.register(UINib.init(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
}

extension FileDownloadViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DownloadTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DownloadTableViewCell
        
        let model = downloadList[indexPath.row]
        cell.vo = model
        
        model.onStatusChanged = { (changedModel) in
            cell.vo = changedModel
        }
        
        model.onProgressChanged = { (changedModel) in
            cell.vo = changedModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = downloadList[indexPath.row]
        
        switch model.status {
        case .kDownloadStatusRunning:
            FileDownloadManager.sharedInstance.suspendWithFileDownloadEntity(model)
        case .kDownloadStatusSuspended:
            FileDownloadManager.sharedInstance.resumeWithFileDownloadEntity(model)
        case .kDownloadStatusCompleted:
            print("已下载完成，路径:" + model.localPath!)
        case .kDownloadStatusFailed:
            FileDownloadManager.sharedInstance.resumeWithFileDownloadEntity(model)
        default:
            FileDownloadManager.sharedInstance.startWithFileDownloadEntity(model)
        }
    }
}
