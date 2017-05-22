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
        pageControlDemo()
    }

    func pageControlDemo() {
        let pageControl = YHPageControl()
        view.addSubview(pageControl)
        pageControl.backgroundColor = UIColor.orange
        pageControl.numberOfPages = 5
        pageControl.currentPage = 1
        pageControl.pointSize = CGSize.init(width: 30, height: 30)
        pageControl.isCircle = true
        pageControl.frame = CGRect.init(x: 0, y: 160, width: UIView.screenWidth, height: 50)
        pageControl.hidesForSiglePage = true
        pageControl.clickFunc = {
            log.debug($0)
        }
        pageControl.setImageOfPoint(UIImage.init(named: "photopicker_state_selected")!, UIImage.init(named: "photopicker_state_normal")!)
    }

}
