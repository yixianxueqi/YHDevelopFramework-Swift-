//
//  YHPhotoPickCollectionDelegate.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/13.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension YHPhotoPickViewController: UICollectionViewDelegate,UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        guard assetsList != nil else {
            return 0
        }
        return assetsList!.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: YHPhotoThumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YHPhotoThumbnailCell;
        let isSelect = selectList.contains(indexPath.row)
        cell.setIsSelect(isSelect)
        cell.setImage(getThumbnail!(indexPath.row))
        
        cell.clickImageViewAction = { (isSelect) in
            self.throughImage(indexPath.row)
        }
        cell.clickButtonAction = { (isSelect) in
            if isSelect! {
                self.selectImage(indexPath.row)
            } else {
                self.unSelectImage(indexPath.row)
            }
        }
        return cell
    }
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        throughImage(indexPath.row)
    }
}
