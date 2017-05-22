//
//  YHPictureBrowseCollectionDelegate.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/19.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension YHPictureBrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: YHPictureBrowseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YHPictureBrowseCell
        cell.setImage(imageList[indexPath.row])
        cell.tapAction = {
            self.changeTopView(!self.isShowTopView)
        }
        return cell
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index: Int = Int.init(scrollView.contentOffset.x / kSize.width)
        changeTitlePage(index)
        
        print("========= \(isShowTopView)")
    }
}
