//
//  YHPictureBrowseViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/19.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class YHPictureBrowseViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    var imageList = [UIImage]()
    var startIndex = 0
    var isShowTopView = true
    var isFirstEntry = false
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        let size = UIScreen.main.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = size
        return flowLayout
    }()
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isFirstEntry = true
        initializeView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstEntry {
            let width = UIScreen.main.bounds.size.width * CGFloat.init(startIndex)
            collectionView.setContentOffset(CGPoint.init(x: width, y: 0), animated: false)
            isFirstEntry = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    // MARK: - incident
    func setImageList(_ imageList: [UIImage], startIndex index: Int) -> Void {
    
        self.imageList = imageList
        self.startIndex = index
    }
    @IBAction func clickBack(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    // MARK: - customView
    func initializeView() -> Void {

        topView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        isShowTopView = true
        changeTitlePage(startIndex)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(UINib.init(nibName: "YHPictureBrowseCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        collectionView.reloadData()
    }
    func changeTopView(_ isShow: Bool) -> Void {
    
        let size = UIScreen.main.bounds.size
        if isShow {
            isShowTopView = true
            UIView.animate(withDuration: 0.25, animations: { 
                self.topView.alpha = 1.0
            }, completion: { (flag) in
                self.topView.isHidden = false
            })
        } else {
            isShowTopView = false
            UIView.animate(withDuration: 0.25, animations: { 
                self.topView.alpha = 0.0
            }, completion: { (flag) in
                self.topView.isHidden = true
            })
        }
        view.setNeedsLayout()
    }
    //update title label
    func changeTitlePage(_ index: Int) -> Void {
        
        titleLabel.text = String.init("\(index + 1) / \(imageList.count)")
    }
}
