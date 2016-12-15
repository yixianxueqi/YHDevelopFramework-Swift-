//
//  YHPhotoPickThroughDelegate.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/15.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension YHPhotoPickViewController: YHPhotoThroughProtocol {

    func photoCount() -> Int {
    
        return assetsList.count
    }
    func photoStartAtIndex() -> Int {
        
        return throuthStartIndex
    }
    func photoThroughNeedGetImage(_ index: Int) -> UIImage {
    
        return getHighImage!(index)
    }
    func selectImageOfIndex(_ index: Int) -> Void {
        
        return selectImage(index)
    }
    
    func unSelectImageOfIndex(_ index: Int) -> Void {
    
        return unSelectImage(index)
    }
}
