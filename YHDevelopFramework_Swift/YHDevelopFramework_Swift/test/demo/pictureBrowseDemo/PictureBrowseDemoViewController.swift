//
//  PictureBrowseDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/19.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class PictureBrowseDemoViewController: UIViewController {

    var imageList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for index in 1...5 {
        
            let image = UIImage.loadLocalImage("pic_\(index)", type: "jpg")
            imageList.append(image!)
        }
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }

    @IBAction func clickPresent(_ sender: UIButton) {
        
        let browse = YHPictureBrowseViewController.init()
        browse.setImageList(imageList, startIndex: 2)
        present(browse, animated: true, completion: nil)
    }
    

}
