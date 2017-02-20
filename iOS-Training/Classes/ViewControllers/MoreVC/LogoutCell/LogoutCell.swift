//
//  LogoutCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/20/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

protocol LogoutDelegate: NSObjectProtocol {
    func logout(sendAction action: Bool)
}

class LogoutCell: UITableViewCell {
    
    // MARK: - Variable
    
    weak var delegate: LogoutDelegate?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Action
    
    @IBAction func tapToLogout(sender: AnyObject) {
        self.delegate?.logout(sendAction: true)
    }
    
}
