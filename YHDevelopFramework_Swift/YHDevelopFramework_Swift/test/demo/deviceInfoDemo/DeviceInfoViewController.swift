//
//  DeviceInfoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/11.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class DeviceInfoViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var list: [NSDictionary] {
    
        return [["appName":YHDeviceInfo.appName!],["bundleIdentifier":YHDeviceInfo.bundleIdentifier!],["appVersion":YHDeviceInfo.appVersion!],["appBuildVersion":YHDeviceInfo.appBuildVersion!],["uuid":YHDeviceInfo.uuid!],["deviceSerialNum":YHDeviceInfo.deviceSerialNum!],["deviceNameDefineByUser":YHDeviceInfo.deviceNameDefineByUser!],["deviceName":YHDeviceInfo.deviceName!],["deviceSystemVersion":YHDeviceInfo.deviceSystemVersion!],["deviceModel":YHDeviceInfo.deviceModel!],["deviceLocalModel":YHDeviceInfo.deviceLocalModel!],["operatorInfo":YHDeviceInfo.operatorInfo!],["batteryState":YHDeviceInfo.batteryState],["batteryLevel":YHDeviceInfo.batteryLevel]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
            cell?.detailTextLabel?.textColor = UIColor.darkText
        }
        let dic = list[indexPath.row] 
        cell?.textLabel?.text = dic.allKeys.first as? String
        cell?.detailTextLabel?.text = dic.allValues.first as? String
        return cell!
    }
}
