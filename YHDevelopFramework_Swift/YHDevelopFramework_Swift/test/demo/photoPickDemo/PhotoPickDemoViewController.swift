//
//  PhotoPickDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/9.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Photos

class PhotoPickDemoViewController: BaseViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var highImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    //点击选择照片
    @IBAction func clickPhotoPickBtn(_ sender: UIButton) {
        
        let photoPickVC = YHPhotoPickViewController.init()
        if sender.tag == 1001 {
            photoPickVC.selectCount = 1
        } else {
            photoPickVC.selectCount = 3
        }
        navigationController?.pushViewController(photoPickVC, animated: true)
        photoPickVC.completionAction = { (list) in
            let result: YHPhotoResult = list.first!
            log.debug(result.thumbnail)
            log.debug(result.highImage)
            self.thumbnailImageView.image = result.thumbnail
            self.highImageView.image = result.highImage
        }
    }
}
