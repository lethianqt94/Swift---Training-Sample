//
//  AlbumCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class AlbumCell: TriggerCell {
    
    // MARK: outlets + variables
    
    @IBOutlet var lblAlbumDesc: UILabel!
    @IBOutlet var lblAlbumCategory: UILabel!
    @IBOutlet var lblLocation: UIButton!
    @IBOutlet var imagesView: PhotoView!
    
    var album:Album?
    var listPhoto:[Photo]! = []
    var total:Int! = 1
    
    // MARK: lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: set Content to cell
    
    internal func setContentToAlbumCell() {
        if album != nil {
            lblAlbumDesc.text = album!.albDesc
            let location = album!.albLocation
            if location != ""{
                lblLocation.selected = true
                lblLocation.setImage(UIImage(named: "ic_location_unselected"), forState: .Selected)
                lblLocation.setTitle("  " + location!, forState: .Selected)
            }
        }
        for view in imagesView.subviews {
            view.removeFromSuperview()
        }
        if listPhoto!.count > 0 {
            imagesView.setupViewPhotoWithListPhotoObject(listPhoto!, total: total)
            imagesView.setNeedsDisplay()
        }
        
    }

    
}
