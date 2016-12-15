//
//  YHPhotoPickViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/13.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Photos

let kSpace: CGFloat = 4.0
let kRowNum = 4
let kNavigationHeight: CGFloat = 64.0
let kSize = UIScreen.main.bounds.size
let kGreenColor = UIColor.init(colorLiteralRed: 127.0/255.0, green: 242.0/255.0, blue: 40.0/255.0, alpha: 1.0)

public class YHPhotoPickViewController: UIViewController {
    
    public var selectCount: Int = 0
    public var completionAction: (([YHPhotoResult]) -> Void)?
    
    internal var assetsList = [PHAsset]()
    internal var getThumbnail: ImageOfIndex?
    internal var getHighImage: ImageOfIndex?
    internal var selectList = [Int]()
    internal var throuthStartIndex = 0
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var selectCountLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    
    private var asset = YHAssets()
    private let flowLayout: UICollectionViewFlowLayout = {
        
        let flowLayout = UICollectionViewFlowLayout.init()
        let screenWidth = kSize.width
        flowLayout.minimumLineSpacing = kSpace
        flowLayout.minimumInteritemSpacing = kSpace
        flowLayout.sectionInset = UIEdgeInsets.init(top: kSpace, left: kSpace, bottom: kSpace, right: kSpace)
        let itemWidth = (screenWidth - CGFloat.init(kRowNum + 1) * kSpace)/CGFloat.init(kRowNum)
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        return flowLayout
    }()
    
    // MARK: - lifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initilalizeCollectionView()
        getAssets()
    }
    public override var prefersStatusBarHidden: Bool {
        return false
    }
    // MARK: - incident
    @IBAction private func clickOKButton(_ sender: UIButton) {
        
        var resultList = [YHPhotoResult]()
        for value in selectList {
            let thumbnail = getThumbnail!(value)
            let highImage = getHighImage!(value)
            let result = YHPhotoResult.init(thumbnail, highImage)
            resultList.append(result)
        }
        completionAction?(resultList)
        navigationController?.popViewController(animated: true)
    }
    //through highImage
    internal func throughImage(_ index: Int) {
        
        throuthStartIndex = index
        let throughVC = YHPhotoBrowseViewController.init()
        throughVC.delegate = self
        navigationController?.pushViewController(throughVC, animated: true)
    }
    //select image handle
    internal func selectImage(_ index: Int) {
        var oldIndex: Int?
        if selectCount == 1 {
            //sigle
            oldIndex = selectList.first
            selectList.removeAll()
            selectList.append(index)
        } else {
            //mutiple
            if selectList.count < selectCount {
                selectList.append(index)
            } else {
                //warning over limit
                warningOverLimit()
            }
        }
        changeBottomView(selectList.count);
        if let old = oldIndex {
            reloadCollectionView([index,old])
        } else {
            reloadCollectionView([index])
        }
    }
    //unSelect image handle
    internal func unSelectImage(_ index: Int) {
        
        if selectList.contains(index) {
            selectList.remove(at: selectList.index(of: index)!)        
        }
        changeBottomView(selectList.count);
        reloadCollectionView([index])
    }
    
    // MARK: - load resources
    private func getAssets() {
        
        DispatchQueue.global().async {
            YHAssets().loadImageAssets { (list) in
                self.assetsList = list
                self.getThumbnail = self.asset.getThumbnailImage(list, targetSize: self.flowLayout.itemSize)
                self.getHighImage = self.asset.getHighImage(list, targetSize: UIScreen.main.bounds.size)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    // MARK: - custom view
    private func initilalizeCollectionView() {
        
        tabBarController?.tabBar.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(UINib.init(nibName: "YHPhotoThumbnailCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    //change view by select image count
    private func changeBottomView(_ count: Int) {
        
        if count > 0 {
            okButton.backgroundColor = kGreenColor
        } else {
            okButton.backgroundColor = UIColor.darkGray
        }
        selectCountLabel.text = String.init(count)
    }
    //refresh collectionView
    private func reloadCollectionView(_ indexList: [Int]) {
        
        var indexPathList = [IndexPath]()
        for value in indexList {
            indexPathList.append(IndexPath.init(row: value, section: 0))
        }
        collectionView.reloadItems(at: indexPathList)
    }
    //alert
    private func warningOverLimit() {
    
        let msg = String.init("最多可选择" + String.init(selectCount) + "张")
        let alert = UIAlertController.init(title: "提示", message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
