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

        httpService.networkGetRequest(getHttp, parameter: getDic) {(isSuccess, result) in
            
            if isSuccess {
                self.log.info("\(JSON(result))")
                self.log.info("GET SUCCESS")
            } else {
                self.log.error("GET ERROR:\(result)")
            }
        }
        httpService.networkPostRequest(postHttp, parameter: postDic, completet: postSuccessHandle)
    }
    func postSuccessHandle(_ isSuccess: Bool, result: Any)  {
        if isSuccess {
            self.log.info("POST SUCCESS")
        } else {
            self.log.error("GET ERROR:\(result)")
        }
    }
    
}
