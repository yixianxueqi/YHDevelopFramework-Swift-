//
//  ViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/5.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class ViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let className = "className"
    let navTitle = "title"
    var demoList: NSArray? {
        if let resources = Bundle.main.path(forResource: "demo", ofType: "plist") {
            return NSArray(contentsOfFile:resources)
        }
        return nil
    }
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.reloadData()
        
        networkChangeListener()
    }
    // MARK: - define
    //监听网络变化
    func networkChangeListener() {
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: YHNotificationListener), object: nil, queue: nil) { status in
            log.info("** network change:\(status.userInfo!["status"]!) **")
            let sta = status.userInfo!["status"]! as! YHNetworkStatus
            switch sta {
            case YHNetworkStatus.unknown :
                log.info(sta.rawValue)
            case YHNetworkStatus.notReachable :
                log.info(sta.rawValue)
            case YHNetworkStatus.ethernetOrWiFi :
                log.info(sta.rawValue)
            case YHNetworkStatus.wwan :
                log.info(sta.rawValue)
            }
        }
    }
    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (demoList?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let dic = demoList?[indexPath.row] as! NSDictionary
        cell?.textLabel?.text = dic[className] as? String
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = demoList?[indexPath.row] as! NSDictionary
        let clsName = dic[className] as! String
        let title = dic[navTitle] as! String
        guard let classType = swiftClassFromString(clsName) as? UIViewController.Type else {
            log.error("反射创建类失败")
            return
        }
        let viewController = classType.init()
        viewController.navigationItem.title = title
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}

