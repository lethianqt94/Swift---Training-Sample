//
//  InfoAlbumCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

protocol InfoAlbumCellDelegate: NSObjectProtocol {
    func infoAlbumCellActionLike(event event: Bool)
    func infoAlbumCellActionUnLike(event event: Bool)
}

class InfoAlbumCell: UITableViewCell {
    
    // MARK: - Variables
    
    weak var delegate: InfoAlbumCellDelegate?
    var photoAlbumAPI: PhotoAlbumManageAPI?
    var album: Album?
    
    var like: Int? = 0
    var comment: Int? = 0
    var share: Int? = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblInfoPost: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHashTag: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLikeCommentShare: UILabel!
    
    @IBOutlet weak var btnUnLike: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    
    @IBOutlet weak var consHeightLabelDescription: NSLayoutConstraint!
    @IBOutlet weak var consBottomLabelTagToViewInfo: NSLayoutConstraint!
    
    // MARK: - Override Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        imgAvatar.clipsToBounds = true
        
        photoAlbumAPI = PhotoAlbumManageAPI()
        btnUnLike.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func tapToUnLike(sender: AnyObject) {
        self.delegate?.infoAlbumCellActionUnLike(event: true)
        if let photoAlbumAPI = photoAlbumAPI {
            if let album = album {
                photoAlbumAPI.requestLike(type: "album", albumId: album.albId!)
            }
        }
    }
    
    @IBAction func tapToLike(sender: AnyObject) {
        self.delegate?.infoAlbumCellActionLike(event: true)
        if let photoAlbumAPI = photoAlbumAPI {
            if let album = album {
                photoAlbumAPI.requestLike(type: "album", albumId: album.albId!)
            }
        }
    }
    
    @IBAction func tapToComment(sender: AnyObject) {
        print("Comment")
    }
    
    @IBAction func tapToShare(sender: AnyObject) {
        print("Share")
    }
    
}
