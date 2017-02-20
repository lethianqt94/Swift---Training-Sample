//
//  ArticleContentCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 2/4/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ArticleContentCell: UITableViewCell {
    
    // MARK: - Variables
    
    var articleDetailAPI: ArticleDetailManageAPI?
    var article: Article?
    var isLike: Bool? = false
    
    // MARK: - Outlet
    
    @IBOutlet weak var lblLiker: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    // MARK: - Override Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        articleDetailAPI = ArticleDetailManageAPI()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Actions
    
    @IBAction func tapToLike(sender: AnyObject) {
        if let articleDetailAPI = articleDetailAPI {
            if isLike == true {
                // Event Unlike
                btnLike.setImage(UIImage(named: "ic_button_like.png"), forState: .Normal)
                let liker = article?.artLikers![1]
                let numberLiker = (article?.artLikers?.count)! - 2
                lblLiker.attributedText = CommonFunc.getAttributeStringInfoLikerPhoto(displayName: (liker?.displayName!)!,
                                                                                      numberLiker: numberLiker)
                isLike = false
            } else {
                //Event Like
                btnLike.setImage(UIImage(named: "ic_button_unlike.png"), forState: .Normal)
                let liker = AccountManager.sharedInstance.getInfoUser()
                let numberLiker = article?.artLikers?.count
                lblLiker.attributedText = CommonFunc.getAttributeStringInfoLikerPhoto(displayName: liker.displayName!, numberLiker: numberLiker!)
                isLike = true
            }
            if let article = article {
                articleDetailAPI.requestLike(type: "article", articleId: article.artId!)
            }
        }
    }
    
    @IBAction func tapToComment(sender: AnyObject) {
        
    }
    
    @IBAction func tapToShare(sender: AnyObject) {
        
    }
    
    
}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data,
                                       options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                            NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding],
                            documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
}
