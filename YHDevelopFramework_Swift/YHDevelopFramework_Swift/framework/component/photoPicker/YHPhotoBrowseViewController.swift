//
//  YHPhotoBrowseViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/14.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

protocol YHPhotoThroughProtocol: NSObjectProtocol {
    
    func photoCount() -> Int
    func photoStartAtIndex() -> Int
    func photoThroughNeedGetImage(_ index: Int) -> UIImage
    func selectImageOfIndex(_ index: Int) -> Void
    func unSelectImageOfIndex(_ index: Int) -> Void
}

class YHPhotoBrowseViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: YHPhotoThroughProtocol!
    
    private var isShowToolView = true
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize.init(width: kSize.width, height: kSize.height - kNavigationHeight)
        return flowLayout
    }()
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initilalizeCollectionView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let width = UIScreen.main.bounds.size.width * CGFloat.init(delegate.photoStartAtIndex())
        let offsetPoint = CGPoint.init(x: width, y: 0)
        collectionView.setContentOffset(offsetPoint, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.navigationBar.isHidden = false
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: - incident
    //click back button

    //click select button
    @IBAction func clickBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clickSelect(_ sender: UIButton) {
    }
    
    // MARK: - customView
    private func initilalizeCollectionView() {
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        topView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        //        changeTitlePage(delegate.photoStartAtIndex())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(UINib.init(nibName: "YHPhotoHighImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        //view.addSubview(collectionView)
        collectionView.reloadData()
    }
    //hide toolView
    private func hideToolView() -> Void {
        
        UIView.animate(withDuration: 0.25, animations:{
            self.topView.center = CGPoint.init(x: kSize.width * 0.5, y: -kNavigationHeight * 0.5)
        })
    }
    //show tooView
    private func showToolView() -> Void {
        
        UIView.animate(withDuration: 0.25, animations:{
            self.topView.center = CGPoint.init(x: kSize.width * 0.5, y: kNavigationHeight * 0.5)
        })
    }
    //update title label
    func changeTitlePage(_ index: Int) -> Void {

        titleLabel.text = String.init("\(index + 1) / \(delegate.photoCount())")
    }
}
