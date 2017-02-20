//
//  ArticleDetailCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 2/4/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ArticleDetailCell: UITableViewCell {
    
    // MARK: Variables
    
    var stringImg = "ic_button_start_photodetail.png"
    
    // MARK: - Outlet
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblTitleArticle: UILabel!

    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var btnAddCollection: UIButton!
    
    @IBOutlet weak var consHeightImgPhoto: NSLayoutConstraint!
    
    // MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgAvatar.layer.cornerRadius = imgAvatar.layer.frame.size.width / 2
        imgAvatar.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Actions
    
    @IBAction func tapToAddCollection(sender: AnyObject) {
        if stringImg == "ic_button_start_photodetail.png" {
            stringImg = "ic_button_start_color_articledetail.png"
            btnAddCollection.setImage(UIImage(named: stringImg), forState: .Normal)
            print("add to collection")
        } else if stringImg == "ic_button_start_color_articledetail.png" {
            stringImg = "ic_button_start_photodetail.png"
            btnAddCollection.setImage(UIImage(named: stringImg), forState: .Normal)
            print("remove to collection")
        }
    }
    
    
}
