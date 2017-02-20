//
//  ArticleCommentCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 2/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ArticleCommentCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    // MARK: - Variables
    
    var articleComment: [Comment]?
    
    let dateFormatter = NSDateFormatter()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tfComment: UITextField!
    
    @IBOutlet weak var consHeightTableView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        initTextFieldComment()
        setPaddingViewForComment()
        
        figureTableCellHeight()
        
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        
        tableView.tableFooterView = UIView()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Custom Methods
    
    func figureTableCellHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
    }
    
    func initTextFieldComment() {
        tfComment.delegate = self
        tfComment.layer.borderColor = UIColor(red: 202, green: 202, blue: 202).CGColor
        tfComment.layer.borderWidth = 1
        tfComment.layer.cornerRadius = 4
        tfComment.clipsToBounds = true
        tfComment.attributedPlaceholder = CommonFunc.getAttributePlaceholder("Your comment....")
    }
    
    func setPaddingViewForComment() {
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: self.tfComment.frame.height))
        tfComment.rightView = paddingViewRight
        tfComment.rightViewMode = UITextFieldViewMode.Always
        
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.tfComment.frame.height))
        tfComment.leftView = paddingViewLeft
        tfComment.leftViewMode = UITextFieldViewMode.Always
    }
    
    // MARK: - UITextFieldDelegate Method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tfComment.resignFirstResponder()
        return true
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let articleComment = articleComment {
            return articleComment.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        if let articleComment = articleComment {
            let comment = articleComment[indexPath.row]

            let date = dateFormatter.dateFromString(comment.cmtDate!)
            let dateCreated = CommonFunc.dateDiff(date!)
            cell.lblTime.text = dateCreated
            cell.lblComment.text = comment.cmtContent
            
            if let owner = comment.cmtOwner {
                cell.lblDisplayName.text = owner.displayName
                if owner.avatar == "" {
                    cell.imgAvatar.image = UIImage(named: "img_no_useravatar.png")
                } else {
                    let stringImgAvatar = CommonFunc.getImgFromAvatar(owner.avatar!)
                    CommonFunc.getImageData(stringImgAvatar, imageView: cell.imgAvatar)
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
