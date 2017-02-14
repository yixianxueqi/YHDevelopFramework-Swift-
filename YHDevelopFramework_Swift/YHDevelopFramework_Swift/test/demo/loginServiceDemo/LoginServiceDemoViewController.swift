//
//  LoginServiceDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 17/2/14.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit

class LoginServiceDemoViewController: BaseViewController {

    let loginService = YHLoginService.service
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginService.saveLoginInfo(loginInfo: ["bbb":"123"], loginResult:nil)
        
//        let result = loginService.getCurrentLoginInfo()
//        log.debug(result)
//        let result = loginService.getHistoryList(0)
//        log.debug(result)
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        loginService.saveLoginInfo(loginInfo: ["aaa": "123"], loginResult: ["loginToken": "loginToken"])
    }
    @IBAction func logout(_ sender: UIButton) {
        loginService.replaceLoginState()
    }
    @IBAction func currentLoginInfo(_ sender: UIButton) {
        
        let result = loginService.getCurrentLoginInfo()
        log.debug(result)
    }
    @IBAction func historyInfo(_ sender: UIButton) {
        
        let result = loginService.getHistoryList(0)
        log.debug(result)
    }
    @IBAction func clear(_ sender: UIButton) {
        
        loginService.clear()
    }
    
}














