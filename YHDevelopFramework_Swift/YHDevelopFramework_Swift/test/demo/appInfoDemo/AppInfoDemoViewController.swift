//
//  AppInfoDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 17/1/3.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

class AppInfoDemoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        YHAppInfoManager.getAppInfoFromAppStore(appID: "414478124"){
            (dic) in
            log.debug(dic)
            log.debug(dic["version"])
        }
        
    }

    @IBAction func clickButton(_ sender: UIButton) {
        
     YHAppInfoManager.entryAppStore(appID: "414478124")
    }

}
