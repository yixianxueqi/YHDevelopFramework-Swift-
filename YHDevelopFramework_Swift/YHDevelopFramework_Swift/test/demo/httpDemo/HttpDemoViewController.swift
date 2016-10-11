//
//  HttpDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/8.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

let getHttp = "http://bea.wufazhuce.com/OneForWeb/one/getHp_N"
let getDic = ["strDate":"2015-05-25","strRow":"1"]
let postHttp = "https://httpbin.org/post"
let postDic = ["foo": [1,2,3],"bar":["baz": "qux"]] as [String : Any]

class HttpDemoViewController: BaseViewController {
    
    let httpService = HttpService()
    
    override func viewDidLoad() {
         super.viewDidLoad()

        httpService.networkGetRequest(getHttp, parameter: getDic) {(isSuccess, obj) in
            
            if isSuccess {
                self.log.info("http result:\(obj)")
            } else {
                self.log.error("http error:\(obj)")
            }
        }
        httpService.networkPostRequest(postHttp, parameter: postDic) { (isSuccess, obj) in
            
            if isSuccess {
                self.log.info("http result:\(obj)")
            } else {
                self.log.error("http error:\(obj)")
            }
        }
    }
    
}
