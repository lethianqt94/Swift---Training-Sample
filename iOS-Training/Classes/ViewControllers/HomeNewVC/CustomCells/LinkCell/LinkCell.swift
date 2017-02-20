//
//  LinkCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class LinkCell: TriggerCell {

    // MARK: outlets + variables
    
    @IBOutlet var lblPostDesc: UILabel!
    @IBOutlet var lblPostCategory: UILabel!
    
    @IBOutlet var imvLinkThumb: UIImageView!
    @IBOutlet var lblLinkTitle: UILabel!
    @IBOutlet var lblLinkDesc: UILabel!
    @IBOutlet var lblLink: UILabel!
    @IBOutlet var linkView: UIView!

    var link: Link!
    
    // MARK: lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLayer()
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: set Content to cell
    
    func setUpLayer() {
        let layer: CALayer = linkView.layer
        linkView.clipsToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowOpacity = 0.4
//        layer.shadowPath = UIBezierPath(rect: linkView.bounds).CGPath
        layer.shouldRasterize = true
    }
    
    internal func setContentToLinkCell() {
        lblPostDesc.text = link.lnkContent
        lblLinkTitle.text = link.lnkWebTitle
        lblLinkDesc.text = link.lnkWebDesc
        lblLink.text = link.lnkWebUrl
        if let thumb = link.lnkWebImg {
            CommonFunc.getImageData(thumb, imageView: imvLinkThumb)
        }
    }
    
}
