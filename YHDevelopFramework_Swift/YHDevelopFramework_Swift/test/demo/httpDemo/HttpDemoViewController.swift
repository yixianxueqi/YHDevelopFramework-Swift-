//
//  HttpDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/8.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class HttpDemoViewController: BaseViewController {
    
    let httpService = HttpService()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        httpService.getRequestFunc { (isSuccess, obj) in
         
            if isSuccess {
                self.log.info("http result:\(obj)")
            } else {
                self.log.error("http error:\(obj)")
            }
        }
        httpService.postRequest { (isSuccess, obj) in
            
            if isSuccess {
                self.log.info("http result:\(obj)")
            } else {
                self.log.error("http error:\(obj)")
            }        }
    }
    
}
