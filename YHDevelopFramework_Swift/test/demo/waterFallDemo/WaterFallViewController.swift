//
//  WaterFallViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/22.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class WaterFallViewController: BaseViewController, YHWaterFallLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }

    func initializeCollectionView() {
    
        let layout = YHWaterFallLayout()
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        layout.column = 4
        layout.delegate = self
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.sectionInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        if #available(iOS 10.0, *) {
            collectionView?.isPrefetchingEnabled = false
        }
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView!)
    }
    
    func getHeight(index: Int) -> CGFloat {
    
        let remainder = index % 4
        let dic = [0:30, 1:40, 2:70, 3:100]
        return CGFloat.init(dic[remainder]!)
    }
    
    // MARK: - YHWaterFallLayoutDelegate
    func cellHeight(for indexPath: IndexPath) -> CGFloat {
        return getHeight(index: indexPath.row)
    }
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 999
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.cyan
        return cell
    }
    

}
