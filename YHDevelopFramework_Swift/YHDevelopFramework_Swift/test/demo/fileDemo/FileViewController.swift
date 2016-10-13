//
//  FileViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/13.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class FileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let pathList = [["home":YHFileManager.homePath],["documents":YHFileManager.documentsPath],["library":YHFileManager.libraryPath],["temp":YHFileManager.tempPath],["cache":YHFileManager.cachePath],["preferences":YHFileManager.preferencesPath]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 文件操作测试
//        let logTxt = (YHFileManager.documentsPath as NSString).strings(byAppendingPaths: ["logger.txt"]).first!
//        log.debug(YHFileManager.directorySize(YHFileManager.homePath))
//        log.debug(YHFileManager.fileSize(logTxt))
//        let newDir = (YHFileManager.homePath as NSString).strings(byAppendingPaths: ["yht"]).first!
//        log.debug(YHFileManager.directoryIsExist(newDir))
        log.debug(YHFileManager.fileNameOfDirectory(NSHomeDirectory()))
//        log.debug(YHFileManager.fileOfDirectory(YHFileManager.preferencesPath))
//        YHFileManager.deleteFile(logTxt)
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pathList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
            cell?.detailTextLabel?.numberOfLines = 0
            cell?.selectionStyle = .none
        }
        let dic = pathList[indexPath.row]
        cell?.textLabel?.text = dic.keys.first
        cell?.detailTextLabel?.text = dic.values.first
        return cell!
    }

}
