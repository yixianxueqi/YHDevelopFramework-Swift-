//
//  YHPhotoAlbumTableViewCell.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/16.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class YHPhotoAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accessoryType = .disclosureIndicator
    }
    // set cell Info
    func setItemInfo(_ item:(UIImage, String, Int)) -> Void {
        
        albumImageView.image = item.0
        albumTitleLabel.text = item.1
        countLabel.text = String.init(item.2)
    }
}
