//
//  CommentCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 2/1/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        imgAvatar.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
