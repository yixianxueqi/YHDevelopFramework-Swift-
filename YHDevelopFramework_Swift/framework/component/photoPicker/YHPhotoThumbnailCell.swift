//
//  YHPhotoThumbnailCell.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/14.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

typealias PhotoCellClickIncident = (Bool?)->Void

class YHPhotoThumbnailCell: UICollectionViewCell {

    var clickButtonAction: PhotoCellClickIncident?
    var clickImageViewAction: PhotoCellClickIncident?
    
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.lightGray
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickImageView(_:)))
        imageView.addGestureRecognizer(tap)
    }
    //set imageView's image
    func setImage(_ image: UIImage) -> Void {
        imageView.image = image
    }
    // set selectButton status
    func setIsSelect(_ select: Bool) -> Void {
        selectButton.isSelected = select
    }
    //tap selectButton
    @IBAction func clickSelectButton(_ sender: UIButton) {
        
        clickButtonAction?(!sender.isSelected)
    }
    //tap imageView
    func clickImageView(_ tap: UITapGestureRecognizer) {
        
        clickImageViewAction?(nil)
    }
    
}
