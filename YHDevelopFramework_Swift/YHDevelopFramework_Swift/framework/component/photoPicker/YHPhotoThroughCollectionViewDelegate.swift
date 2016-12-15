//
//  YHPhotoThroughCell.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/14.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension YHPhotoThroughViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return delegate.photoCount()
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: YHPhotoHighImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YHPhotoHighImageCell
        let image = delegate.photoThroughNeedGetImage(indexPath.row)
        cell.setImage(image)
        return cell
    }
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index: Int = Int.init(scrollView.contentOffset.x / kSize.width)
        changeTitlePage(index)
    }
}
