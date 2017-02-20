//
//  ArticleCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ArticleCell: TriggerCell {
    
    // MARK: outlets + variables
    
    @IBOutlet var imvImageArticle: UIImageView!
    @IBOutlet var lblArticleTitle: UILabel!
    @IBOutlet var lblArticleDesc: UILabel!
    @IBOutlet var articleView: UIView!
//    @IBOutlet var consHeightImv: NSLayoutConstraint!
    
    var article: Article! = Article()
    
    
    // MARK: lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblArticleDesc.text = ""
        lblArticleTitle.text = ""
//        setUpLayer()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    // MARK: set Content to cell
    
    func setUpLayer() {
        let layer: CALayer = articleView.layer
        articleView.clipsToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowOpacity = 0.4
        //        layer.shadowPath = UIBezierPath(rect: linkView.bounds).CGPath
        layer.shouldRasterize = true
    }
    internal func setContentToArticleCell() {
        lblArticleTitle.text = article.artTitle
        lblArticleDesc.text = article.artDesc
//        lblLink.text = article.artl
        if let photo = article.artPhoto {
//            if (photo.ptImage)!.characters.count = 0 {}
            let ptImage:String = photo.ptImage!
            if ptImage.characters.count > 0 {
//                self.consHeightImv.constant = 197
                let articleImgUrl = CommonFunc.getImgFromAvatar(ptImage)
                CommonFunc.getImageData(articleImgUrl, imageView: imvImageArticle)
            } else {
//                self.consHeightImv.constant = 0
            }
        }
    }
    
}
