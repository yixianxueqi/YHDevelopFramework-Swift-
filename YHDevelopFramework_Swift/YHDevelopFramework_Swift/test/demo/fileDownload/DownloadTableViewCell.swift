//
//  DownloadTableViewCell.swift
//  YHDevelopFramework_Swift
//
//  Created by keqi on 2016/11/4.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var vo: FileDownloadVO! {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        titleLabel.text = vo.fileName
        progressView.progress = vo.progress
        progressLabel.text = String(format: "%.2f%%", vo.progress*100)
        statusLabel.text = vo.statusText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
