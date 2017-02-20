//
//  InfoCollectionCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/21/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class InfoCollectionCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var lblTitleCollection: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var imgCollection: UIImageView!
    @IBOutlet weak var imgMaskCollection: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgCollection.layer.cornerRadius = 4
        imgCollection.clipsToBounds = true
        
        imgMaskCollection.layer.cornerRadius = 4
        imgMaskCollection.clipsToBounds = true
    }

}
