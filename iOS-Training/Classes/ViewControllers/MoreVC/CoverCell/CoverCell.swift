//
//  CoverCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/26/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

protocol CoverCellDelegate: NSObjectProtocol {
    func coverCellToProfileCredit(event event: Bool)
    func coverCellToProfile(event event: Bool)
}

class CoverCell: UITableViewCell {
    
    // VAriables
    
    weak var delegate: CoverCellDelegate?
    
    // MARK: - Outlet
    
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgBackgroundAvatar: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblNumberCredit: UILabel!
    
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var btnCredit: UIButton!

    
    // MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgAvatar.layer.cornerRadius = 4
        imgAvatar.clipsToBounds = true
        
        imgBackgroundAvatar.layer.cornerRadius = 4
        imgBackgroundAvatar.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func tapToProfileCreditVC(sender: AnyObject) {
        self.delegate?.coverCellToProfileCredit(event: true)
    }
    
    @IBAction func tapToProfileVC(sender: AnyObject) {
        self.delegate?.coverCellToProfile(event: true)
    }
    
}
