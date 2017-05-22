//
//  YHPhotoPickManagerViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/17.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

typealias PhotoPickCompletion = ([YHPhotoResult]) -> Void

class YHPhotoPickManagerViewController: UINavigationController {

    var completionAction: PhotoPickCompletion?
    var selectCount: Int = 0
    
    convenience init() {
        
        let album = YHPhotoAlbumViewController.init()
        self.init(rootViewController: album)
        
    }
    // MARK: - life Cycle
    private override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
    }
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
