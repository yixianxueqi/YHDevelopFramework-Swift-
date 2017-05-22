//
//  YHPhotoAlbumTableDelegate.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/16.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension YHPhotoAlbumViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: YHPhotoAlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! YHPhotoAlbumTableViewCell
        cell.selectionStyle = .none
        let item = albumList[indexPath.row]
        var image = UIImage()
        if let asset = item.1.first {
            image = YHAssets.getImageByAsset(asset, targetSize: kAlbumSize)
        }
        cell.setItemInfo((image,item.0,item.1.count))
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        photoPick.assetsList = albumList[indexPath.row].1
        navigationController?.pushViewController(photoPick, animated: true)
    }
}
