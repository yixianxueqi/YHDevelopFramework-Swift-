//
//  ViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/5.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class ViewController: UIViewController,YHLoggerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Develop_Swift"
        let documentDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        let logPath = documentDirPath.appending("/logger")
        log.verbose("test: \(logPath)")
        log.debug("file: \(logPath)")
        var num = 0
        let list = ["a","b","c","d"]
        for _ in 0...list.count {
            log.verbose("\(num):\(list[num])")
            num += 1
        }
    }
}

