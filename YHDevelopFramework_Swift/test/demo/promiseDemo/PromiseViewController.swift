//
//  PromiseViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/18.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import PromiseKit

enum TestError: Error {

    case FailureError
    case BadError
}

class PromiseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        login().then(execute: { result -> Bool in
            
            guard !result.isEmpty else {
                throw TestError.FailureError
            }
            return true
        })
        .then(execute: { result -> Void in
            if result == true {
                log.debug("login success")
            }
        })
        .catch { error in
            log.error(error)
        }
    }
    
    func login() -> Promise<String> {
        
        let str = "111" //""
        return Promise.init(value: str)
    }
}
