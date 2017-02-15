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
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        guard let name = nameTextField.text, let pwd = passwordTextField.text else {
            log.debug("not allow empty")
            return
        }
        loginService.saveLoginInfo(loginInfo: ["name": name, "pwd": pwd], loginResult: nil)
    }
    @IBAction func logout(_ sender: UIButton) {
        loginService.replaceLoginState()
    }
    @IBAction func currentLoginInfo(_ sender: UIButton) {
        
        let result = loginService.getCurrentLoginInfo()
        guard let res = result else {
            log.debug("null of current LoginInfo")
            return
        }
        log.debug(res)
    }
    @IBAction func historyInfo(_ sender: UIButton) {
        
        let result = loginService.getHistoryList(0)
        log.debug(result)
    }
    @IBAction func clear(_ sender: UIButton) {
        
        loginService.clear()
    }
    
}














