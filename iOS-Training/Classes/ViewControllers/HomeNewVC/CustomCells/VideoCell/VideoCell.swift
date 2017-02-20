//
//  VideoCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class VideoCell: TriggerCell {

    // MARK: outlets + variables
    
    @IBOutlet var imvVideoThumb: UIImageView!
    @IBOutlet var lblVideoTitle: UILabel!
    @IBOutlet var lblVideoCategory: UILabel!
    @IBOutlet var lblVideoDesc: UILabel!

    @IBOutlet weak var btnPlay: UIButton!
    var video: Video!
    
    // MARK: lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: set Layout Constraints for Subview
    
    internal func setContentToVideoView() {
        
        if let _ = video.vidThumb {
            let thumbUrl = video.getVideoThumnail()
            
            print("video url: \(thumbUrl)")
            
            CommonFunc.getImageData(thumbUrl, imageView: imvVideoThumb)
        }
        lblVideoTitle.text = video.vidTitle
        lblVideoDesc.text = video.vidDesc
    }
}
