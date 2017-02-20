//
//  ProfileTopCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/21/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

protocol ProfileTopCellDelegate: NSObjectProtocol {
    func profileTopCellAddCover(event event: Bool)
    func profileTopCellAddAvatar(event event: Bool)
    func profileTopCellToCreditVC(event event: Bool)
}

class ProfileTopCell: UITableViewCell {

    // MARK: - Variables
    
    weak var delegate: ProfileTopCellDelegate?
    
    // MARK: - Oulets
    
    @IBOutlet weak var imgBackgroundAvatar: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblDisplayName: UILabel!
    
    // MARK: - Override Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgBackgroundAvatar.layer.cornerRadius = 4
        imgBackgroundAvatar.clipsToBounds = true
        
        imgAvatar.layer.cornerRadius = 4
        imgAvatar.clipsToBounds = true
        
        let user = AccountManager.sharedInstance.getInfoUser() 
        if let avatar = user.avatar {
            let stringAvatar = CommonFunc.getImgFromAvatar(avatar)
            CommonFunc.getImageData(stringAvatar, imageView: imgAvatar)
        }
        
        if let cover = user.cover {
            let stringCover = CommonFunc.getImgFromAvatar(cover)
            CommonFunc.getImageData(stringCover, imageView: imgCover)
        }
        
        if let displayName = user.displayName {
            lblDisplayName.text = displayName
        }
        
        if let credit = user.credit {
            lblCredit.text = String(credit)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Action
    
    @IBAction func tapToProfileCreditVC(sender: AnyObject) {
        self.delegate?.profileTopCellToCreditVC(event: true)
    }
    
    @IBAction func tapToAddCoverPhoto(sender: AnyObject) {
        self.delegate?.profileTopCellAddCover(event: true)
    }

    @IBAction func tapToAddAvatarPhoto(sender: AnyObject) {
        self.delegate?.profileTopCellAddAvatar(event: true)
    }
    
}
