//
//  PhotoCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: NSObjectProtocol {
    func photoCellActionLike(event: Bool)
    func photoCellActionUnLike(event: Bool)
}

class PhotoCell: UITableViewCell {
    
    // MARK: - Variables
    
    weak var delegate: PhotoCellDelegate?
    
    var photoAlbumAPI: PhotoAlbumManageAPI?
    var photoAlbumFlow: PhotoAlbumManageFlow?
    var photo: Photo?
    var heightImgPhoto: CGFloat?
    
    var like: Int? = 0
    var comment: Int? = 0
    var share: Int? = 0
    
    // MARK: - Outlet
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var lblLikeCommentShare: UILabel!
    
    @IBOutlet weak var btnUnlike: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var consHeightImgPhoto: NSLayoutConstraint!
    
    // MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoAlbumAPI = PhotoAlbumManageAPI()
        btnUnlike.hidden = true
        
        imgPhoto.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapToPhotoDetail")
        imgPhoto.addGestureRecognizer(tapGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Navigation
    
    internal func setupNavi(navi:UINavigationController) {
        photoAlbumFlow = PhotoAlbumManageFlow(navi: navi)
    }
    
    // MARK: - Custom Method
    
    func tapToPhotoDetail() {
        if let photoAlbumFlow = photoAlbumFlow {
            photoAlbumFlow.goToPhotoDetailsVC(photo!, heightPhoto: heightImgPhoto!)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func tapToUnlike(sender: AnyObject) {
        self.delegate?.photoCellActionUnLike(true)
        if let photoAlbumAPI = photoAlbumAPI {
            if let photo = photo {
                photoAlbumAPI.requestLike(type: "photo", albumId: photo.ptId!)
            }
        }
    }    
    
    @IBAction func tapToLike(sender: AnyObject) {
        self.delegate?.photoCellActionLike(true)
        if let photoAlbumAPI = photoAlbumAPI {
            if let photo = photo {
                photoAlbumAPI.requestLike(type: "photo", albumId: photo.ptId!)
            }
        }
    }
    
    @IBAction func tapToComment(sender: AnyObject) {
        
    }
    
    @IBAction func tapToShare(sender: AnyObject) {
        
    }
}
