//
//  AdsCycyleViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/25.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class AdsCycyleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var imgList = [UIImage]()
        for i in 1...5 {
            let str = "pic_" + String.init(i)
            let img = UIImage.loadLocalImage(str, type: ".jpg")!
            imgList.append(img)
        }
        
        let pageControl = YHPageControl()
        pageControl.backgroundColor = UIColor.clear
        pageControl.currentPageIndicatorTintColor = UIColor.green
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.pointSize = CGSize.init(width: 10, height: 10)
        pageControl.isCircle = true
        pageControl.hidesForSiglePage = true
//        pageControl.setImageOfPoint(UIImage.init(named: "photopicker_state_selected")!, UIImage.init(named: "photopicker_state_normal")!)

        let adsView = AdsCycleView.init(frame: CGRect.init(x: 0, y: 100, width: UIView.screenWidth, height: 200), imageList: imgList)
        view.addSubview(adsView)
        adsView.backgroundColor = UIColor.gray
        adsView.updateView()
        adsView.customAdsStringList(["时就开始的煎熬了快乐的撒娇的","实打实基督教阿克苏的杰拉德卡加大了肯德基圣诞节阿拉丁进垃圾堆里劳动纪律","是大家都就拉开机读卡机大垃圾袋垃圾了到家了就睡啦到家啦九点多就撒了","","说就打开就大了就打开了的骄傲了解到垃圾坑的垃圾涉及到卡萨看来大家拉斯加大量的煎熬了解到撒娇大李经理"])
        adsView.customPageControl(pageControl, .left)
        adsView.startAutoCycle()
        adsView.clickHandle = {
            log.debug($0)
        }
    }


}
