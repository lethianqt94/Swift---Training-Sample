//
//  MoreCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/16/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var imgBackgroundIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var consWidthLabelNumber: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBackgroundIcon.layer.cornerRadius = 2
        imgBackgroundIcon.clipsToBounds = true
        
        lblNumber.layer.cornerRadius = 10
        lblNumber.clipsToBounds = true
        
        lblNumber.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
