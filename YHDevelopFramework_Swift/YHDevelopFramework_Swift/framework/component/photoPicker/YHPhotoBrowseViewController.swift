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
    func selectImageOfIndex(_ index: Int) -> Bool
    func unSelectImageOfIndex(_ index: Int) -> Void
    func containImageOfIndex(_ index: Int) -> Bool
    func getSelectPhotoCount() -> Int
    func completePick() -> Void
}

let kBottomBarHeight: CGFloat = 49.0

class YHPhotoBrowseViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    weak var delegate: YHPhotoThroughProtocol!
    var isShowToolView = true
    var isFirstEntry = false
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize.init(width: kSize.width, height: kSize.height - kNavigationHeight - kBottomBarHeight)
        return flowLayout
    }()
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCollectionView()
        isFirstEntry = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstEntry {
            let width = UIScreen.main.bounds.size.width * CGFloat.init(delegate.photoStartAtIndex())
            let offsetPoint = CGPoint.init(x: width, y: 0)
            collectionView.setContentOffset(offsetPoint, animated: false)
            isFirstEntry = false
        }
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
    @IBAction func clickBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    //click select button
    @IBAction func clickSelect(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        let offsetIndex = collectionView.contentOffset.x / kSize.width
        let index = lroundf(Float.init(offsetIndex))
        if sender.isSelected {
            let isSuc = delegate.selectImageOfIndex(index)
            if !isSuc { sender.isSelected = false }
        } else {
            delegate.unSelectImageOfIndex(index)
        }
        updateBottomView()
    }
    // click complete pick photo
    @IBAction func clickOkButton(_ sender: UIButton) {
        
        navigationController?.dismiss(animated: true, completion: nil)
        delegate.completePick()
    }
    // MARK: - customView
    private func initializeCollectionView() {
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        isShowToolView = true
        topView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        changeTitlePage(delegate.photoStartAtIndex())
        updateBottomView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(UINib.init(nibName: "YHPhotoHighImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        collectionView.reloadData()
    }
    //hide toolView
    func hideToolView() -> Void {
        
        isShowToolView = false
        UIView.animate(withDuration: 0.25, animations: {
            self.topView.alpha = 0.0
            self.bottomView.alpha = 0.0
        }, completion: { (flag) in
            self.topView.isHidden = true
            self.bottomView.isHidden = true
        })
    }
    //show tooView
    func showToolView() -> Void {
        
        isShowToolView = true
        UIView.animate(withDuration: 0.25, animations: {
            self.topView.alpha = 1.0
            self.bottomView.alpha = 1.0
        }, completion: { (flag) in
            self.topView.isHidden = false
            self.bottomView.isHidden = false
        })
    }
    //update title label
    func changeTitlePage(_ index: Int) -> Void {

        titleLabel.text = String.init("\(index + 1) / \(delegate.photoCount())")
    }
    //update select Button
    func updateSelectButton(_ select: Bool) -> Void {
        
        selectButton.isSelected = select
    }
    //update Bottom View
    func updateBottomView() -> Void {
        
        let count = delegate.getSelectPhotoCount()
        countLabel.text = String.init(count)
        if count > 0 {
            okButton.isUserInteractionEnabled = true
            okButton.backgroundColor = kGreenColor
        } else {
            okButton.isUserInteractionEnabled = false
            okButton.backgroundColor = UIColor.darkGray
        }
    }
}
