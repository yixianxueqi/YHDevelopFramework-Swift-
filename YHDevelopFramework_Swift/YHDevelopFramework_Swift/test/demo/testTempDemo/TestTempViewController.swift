//
//  TestTempViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/13.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class TestTempViewController: UIViewController {
    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgView1.image = UIImage.loadLocalImage("111", type: ".png")?.circleImage()
        imgView2.image = UIImage.loadLocalImage("111", type: ".png")?.cornerImage(30)
    }

}
