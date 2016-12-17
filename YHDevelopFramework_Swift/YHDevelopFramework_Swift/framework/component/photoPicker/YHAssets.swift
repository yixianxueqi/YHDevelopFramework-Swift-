//
//  YHAssets.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/9.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Photos

public typealias ImageOfIndex = (Int)-> UIImage

public class YHAssets: NSObject {
    
    private var asstesCompletionAction: (([PHAsset]) -> Void)?
    private let imageManager = PHCachingImageManager()
    
    // MARK: - lifeCycle
    deinit {
        imageManager.stopCachingImagesForAllAssets()
        log.debug("YHAsset deinit..")
    }
    
    // MARK: - public
    public func loadImageAssets(_ completionAction:@escaping (([PHAsset]) -> Void)) {
    
        asstesCompletionAction = completionAction
        //check Authorization
        let status:PHAuthorizationStatus = PHAuthorizationStatus.authorized
        if status == .notDetermined {
            //get Authorization
            PHPhotoLibrary.requestAuthorization({(status) in
                if status == PHAuthorizationStatus.authorized {
                    self.getImageAssets()
                }
            })
        } else if status == .authorized {
            self.getImageAssets()
        }
    }
    // get photo album
    func getAlbum() -> [(String,[PHAsset])] {
    
        var resultlist = [(String,[PHAsset])]()
        let result: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        result.enumerateObjects({ (assetCollection, index, stop) in
            let title = assetCollection.localizedTitle
            var assetList = [PHAsset]()
            let collectionResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            collectionResult.enumerateObjects({ (asset, index, stop) in
                assetList.append(asset)
            })
            resultlist.append((title ?? "",assetList))
        })
        return resultlist
    }
    
    /// get image for asset
    ///
    /// - Parameters:
    ///   - asset: PHAsset
    ///   - size: target size
    /// - Returns: UIImage
    static func getImageByAsset(_ asset: PHAsset, targetSize size: CGSize) -> UIImage {
    
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = true
        var image = UIImage()
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler:{(result, info)->Void in
            image = result!
        })
        return image
    }
    /// get thumbnail creater
    ///
    /// - Parameters:
    ///   - assets: PHAsset list
    ///   - size: target size
    /// - Returns: thumbnail creater
    public func getThumbnailImage(_ assets: [PHAsset], targetSize size: CGSize) -> ImageOfIndex {
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        return getImageByConfig(options, assets, size)
    }
    /// get highImage creater
    ///
    /// - Parameters:
    ///   - assets: PHAsset list
    ///   - size: target size
    /// - Returns: highImage creater
    public func getHighImage(_ assets: [PHAsset], targetSize size: CGSize) -> ImageOfIndex {
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        return getImageByConfig(options, assets, size)
    }
    
    // MARK: - private
    private func getImageAssets() {
        
        guard #available(iOS 8.0, *) else {
            return
        }
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: option)
        var list = [PHAsset]()
        fetchResult.enumerateObjects({ (asset, index, stop) in
            list.append(asset)
        })
        asstesCompletionAction?(list)
    }
    
    /// get image creater by config
    ///
    /// - Parameters:
    ///   - option: PHImageRequestOptions
    ///   - assets: PHAsset list
    ///   - size: target size
    /// - Returns: image creater
    private func getImageByConfig(_ option: PHImageRequestOptions, _ assets: [PHAsset], _ size: CGSize) -> ImageOfIndex {
     
        imageManager.startCachingImages(for: assets, targetSize: size, contentMode: .aspectFill, options: option)
        //image creater
        func getImage(_ index: Int) -> UIImage {
            
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            var image = UIImage()
            imageManager.requestImage(for: assets[index], targetSize: size, contentMode: .aspectFill, options: option, resultHandler:{(result, info)->Void in
                image = result!
            })
            return image
        }
        return getImage;
    }
}





