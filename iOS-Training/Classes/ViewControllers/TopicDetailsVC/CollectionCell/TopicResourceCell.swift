//
//  TopicResourceCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 2/2/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class TopicResourceCell: UICollectionViewCell {
    
    //MARK: Variables
    
    @IBOutlet weak var imvResourceCover:UIImageView!
    @IBOutlet weak var lblStatName:UILabel!
    @IBOutlet weak var lblStatNumber:UILabel!
    @IBOutlet weak var imvMask: UIImageView!
    
    var dicResource:[String:String]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 2.5
        self.clipsToBounds = true
        
        imvResourceCover.layer.cornerRadius = 2.5
        imvResourceCover.clipsToBounds = true
    }
    
    //MARK: - Public Func
    internal func setContentWithDic(dic: [String:String]){
        dicResource = dic
        if let image = dicResource[kImageKey], name = dicResource[kNameKey], total = dicResource[kTotalKey] {
            lblStatNumber.text = total
            lblStatName.text = name
            if image.characters.count > 0 {
                imvResourceCover.hnk_setImageFromURL(NSURL(string: image)!)
            } else {
                imvResourceCover.image = UIImage(named: "img_no_coverphoto.png")
            }
            if Int(total) == 0 {
                imvMask.hidden = true
            } else {
                imvMask.hidden = false
            }
        }
        
        
    }
    
}
