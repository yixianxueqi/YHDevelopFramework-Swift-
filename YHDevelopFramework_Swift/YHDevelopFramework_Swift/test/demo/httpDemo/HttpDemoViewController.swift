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
let download1 = "http://farm3.staticflickr.com/2831/9823890176_82b4165653_b_d.jpg"
let upload = "https://httpbin.org/post"

class HttpDemoViewController: BaseViewController {
    
    let httpService = HttpService()
    
    override func viewDidLoad() {
         super.viewDidLoad()
    
//        getDemo()
        postDemo()
//        downloadDemo()
//        uploadDemo()
    }
    // MARK: - GET
    func getDemo() {
        
        httpService.networkGetRequest(getHttp, parameter: getDic) {(isSuccess, result) in
            if isSuccess {
                log.info("\(JSON(result))")
                log.info("GET SUCCESS")
            } else {
                log.error("GET ERROR:\(result)")
            }
        }
    }
    
    // MARK: - POST
    func postDemo() {
        httpService.networkPostRequest(postHttp, parameter: postDic, completet: postSuccessHandle)
    }
    //post
    func postSuccessHandle(_ isSuccess: Bool, result: Any)  {
        if isSuccess {
            log.info("POST SUCCESS:\(result)")
        } else {
            log.error("GET ERROR:\(result)")
        }
    }
    
    // MARK: - DOWNLOAD
    func downloadDemo() {
        httpService.networkDownloadRequest(download1, parameter: nil, progressHandle: { progress in
            log.debug("download progress:\(progress)")
            }, completet: downloadResultHandle)
    }
    //complete
    func downloadResultHandle(_ isSuccess: Bool, result: Any) {
        if isSuccess {
            log.debug("Download success:\(result)")
        } else {
            log.debug("Download failure:\(result)")
        }
    }
    // MARK: - UPLOAD
    func uploadDemo() {
        //此处会上传成功，但是返回的是image data,默认用的是responseJson解析的，所以会出现responseSerializationFailed
        //改用response解析正常，考虑一般情况，默认使用responseJson解析
        let imgData = UIImagePNGRepresentation(UIImage.loadLocalImage("111", type: ".png")!)
//        let fileUrl = Bundle.main.url(forResource: "111", withExtension: ".png")
        httpService.networkUploadRequest(upload, obj: imgData, progressHandle: { progress in
            log.debug("upload progress:\(progress)")
            }) { (isSuccess, result) in
                if isSuccess {
                    log.debug("Upload success:\(result)")
                } else {
                    log.debug("Upload failure:\(result)")
                }
        }
    }
}




