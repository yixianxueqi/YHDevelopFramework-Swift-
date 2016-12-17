//
//  YHPhotoAlbumViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/16.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Photos

let kAlbumSize = CGSize.init(width: 50, height: 50)

class YHPhotoAlbumViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var albumList = [(String,[PHAsset])]()
    var firstAssetList = [(Int,PHAsset)]()
    var getThumbnail: ImageOfIndex?
    var assets = YHAssets()
    let photoPick = YHPhotoPickViewController.init()
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.pushViewController(photoPick, animated: false)
        
        initializeNavRight()
        initializeTableView()
        getSources()
    }
    // MARK: - load resources
    func getSources() -> Void {
        
        albumList = assets.getAlbum()
        tableView.reloadData()
    }
    // MARK: - incident
    func clickRightBarItem() -> Void {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    // MARK: - customView
    func initializeTableView() -> Void {
        
        tableView.register(UINib.init(nibName: "YHPhotoAlbumTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
    func initializeNavRight() -> Void {
    
        let barItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(clickRightBarItem))
        navigationItem.rightBarButtonItem = barItem;
    }
    
}
