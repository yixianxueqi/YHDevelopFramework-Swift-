//
//  LoadPhotosBiz.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/17.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class LoadPhotosBiz: NSObject {

    var assets = [Any]()
    
    func loadAssets() {
        
        //检查读取相册的权限
        let status:PHAuthorizationStatus = PHAuthorizationStatus.authorized
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    self.performLoadAssets()
                }
            })
        } else if status == .authorized {
            self.performLoadAssets()
        }
    }
    
    private func performLoadAssets() {
        
        if #available(iOS 8.0, *) {
            
            DispatchQueue.global().async {
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResults = PHAsset.fetchAssets(with: options)
                fetchResults.enumerateObjects({ (obj, index, stop) in
                    self.assets.append(obj)
                    print("obj= \(obj)")
                })
            }
        } else {
            // Assets Library iOS < 8
            let assetsLibrary = ALAssetsLibrary()

            // Run in the background as it takes a while to get all assets from the library
            DispatchQueue.global().async {
                var assetGroups = [ALAssetsGroup]()
                var assetURLDictionaries = [Any]()
                
                let assetEnumerator:ALAssetsGroupEnumerationResultsBlock = { (result, index, stop) in
                    if result != nil {
                        let assetType = result!.value(forKey: ALAssetPropertyType) as! NSString
                        
                        if (assetType.isEqual(to: ALAssetTypePhoto) || assetType.isEqual(to: ALAssetTypeVideo)) {
                            assetURLDictionaries.append(result!.value(forKey: ALAssetPropertyURLs)!)
                            let url = result?.defaultRepresentation().url()
                            assetsLibrary.asset(for: url, resultBlock: { (asset) in
                                if asset != nil {
                                    self.assets.append(asset!)
                                }
                            }, failureBlock: { (error) in
                                print("operation was not successfull!")
                            })
                        }
                    }
                }
                
                let assetGroupEnumerator:ALAssetsLibraryGroupsEnumerationResultsBlock = { (group, stop) in
                    if group != nil {
                        group?.enumerateAssets(options: .reverse, using: assetEnumerator)
                        assetGroups.append(group!)
                    }
                }
                
                assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll,
                                            usingBlock: assetGroupEnumerator,
                                            failureBlock: {(error) in
                                                print("There is an error\(error)")
                                            })
            }
        }
    }
    
}
