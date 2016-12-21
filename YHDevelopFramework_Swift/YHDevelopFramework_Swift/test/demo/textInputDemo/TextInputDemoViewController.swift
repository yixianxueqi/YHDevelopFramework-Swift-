//
//  TextInputDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/21.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class TextInputDemoViewController: BaseViewController {

    @IBOutlet weak var textField: YHTextField!
    @IBOutlet weak var textView: YHTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        textField.regularLength = 10
        textField.regularRule = RegularRule.twoSpitNumber
        
        
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.regularLength = 10
//        textView.regularRule = RegularRule.userName
        textView.placeHolder = "please enter..."
    }


}
