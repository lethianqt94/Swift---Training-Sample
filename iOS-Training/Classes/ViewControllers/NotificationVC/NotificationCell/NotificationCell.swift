//
//  NotificationCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/22/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // MARK: outlets + variables
    
    @IBOutlet var imvAvatar: UIImageView!
    @IBOutlet var imvType: UIImageView!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblCreated: UILabel!
    @IBOutlet var imvPlay: UIImageView!
    @IBOutlet var imvFeed: UIImageView!
    @IBOutlet var imvWhiteBg: UIImageView!
    
    @IBOutlet var consHeightImvFeed: NSLayoutConstraint!
    @IBOutlet var consWidthImvFeed: NSLayoutConstraint!
    
    
    var feed: Feed?
    var feedObject: FeedObject?
    var objType: String?
    var actionType:String?
    var feedTrigger:Users?
    
    let dateFormatter = NSDateFormatter()
    
    // MARK: lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        
        if let _ = self.imvFeed {
            self.imvFeed.layer.cornerRadius = 2
            self.imvFeed.clipsToBounds = true
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    // MARK: set Content to cell
    
    internal func setContentToCell() {
        setImageFeedSize()
        setCellBackgroundColor()
        feedTrigger = feed!.feedTrigger?.triggerUser
        if let imvAvt = self.imvAvatar {
            imvAvt.clipsToBounds = true
            imvAvt.layer.cornerRadius = imvAvt.frame.width/2
            let imgUrl = CommonFunc.getImgFromAvatar((feedTrigger?.avatar)!)
            CommonFunc.getImageData(imgUrl, imageView: imvAvt)
        }
        
        if self.imvFeed.frame.width != 0 {
            CommonFunc.getImageData(getImageOfRevObject(), imageView: self.imvFeed)
        }
        setImageForActionType()
        setTextForLblCreated()
        setTextForLblDescription()
    }
    
    func setCellBackgroundColor(){
        if feed!.feedIsRead == true {
            self.backgroundColor = UIColor.whiteColor()
        } else {
            self.backgroundColor = UIColor(red: 248, green: 251, blue: 255)
        }
    }
    
    func setImageForActionType() {
        actionType = feed!.feedAction?.actionType
        objType = feed!.feedObject.objectType
        
        if actionType == ActionType.actionLike || actionType == ActionType.actionComment || actionType == ActionType.actionShare || actionType == ActionType.actionInvite {
            switch(actionType!) {
            case ActionType.actionLike:
                self.imvType.image = UIImage(named: "noti_img_like")
            case ActionType.actionComment:
                self.imvType.image = UIImage(named: "noti_img_cmt")
            case ActionType.actionShare:
                self.imvType.image = UIImage(named: "noti_img_share")
            case ActionType.actionInvite:
                self.imvType.image = UIImage(named: "noti_img_invite")
            default:
                print("not here???")
            }
        } else {
            switch (objType!) {
            case ResourceType.Album, ResourceType.Photo:
                self.imvType.image = UIImage(named: "noti_img_photo")
            case ResourceType.Video:
                self.imvType.image = UIImage(named: "img_btn_video")
            case ResourceType.Article:
                self.imvType.image = UIImage(named: "noti_img_article")
            case ResourceType.Link:
                self.imvType.image = UIImage(named: "noti_img_link")
            default:
                print("not here???")
                self.imvType.image = UIImage(named: "noti_img_publish")
            }
        }
    }
    
    func setImageFeedSize() {
        
        objType = feed!.feedObject.objectType
        switch(objType!) {
        case ResourceType.Album:
            consHeightImvFeed.constant = 50
            consWidthImvFeed.constant = 50
            imvPlay.alpha = 0
            imvWhiteBg.alpha = 1
        case ResourceType.Photo:
            consHeightImvFeed.constant = 50
            consWidthImvFeed.constant = 50
            imvPlay.alpha = 0
            imvWhiteBg.alpha = 0
        case ResourceType.Video:
            consHeightImvFeed.constant = 46
            consWidthImvFeed.constant = 67
            imvPlay.alpha = 1
            imvWhiteBg.alpha = 0
        case ResourceType.Article:
            consHeightImvFeed.constant = 60
            consWidthImvFeed.constant = 50
            imvPlay.alpha = 0
            imvWhiteBg.alpha = 0
        case ResourceType.Topic:
            consHeightImvFeed.constant = 50
            consWidthImvFeed.constant = 50
            imvPlay.alpha = 0
            imvWhiteBg.alpha = 0
        default:
            print("nothing here")
            consHeightImvFeed.constant = 50
            consWidthImvFeed.constant = 0
            imvPlay.alpha = 0
            imvWhiteBg.alpha = 0
        }
        
    }
    
    func setTextForLblCreated() {
        let date = dateFormatter.dateFromString((feed!.feedCreate)!)
        let time = CommonFunc.dateDiff(date!)
        lblCreated.text = time
    }
    
    func getActionOfFeed() -> String {
        actionType = feed!.feedAction?.actionType
        objType = feed!.feedObject.objectType
        switch (actionType!) {
        case ActionType.actionLike:
            return "liked on"
        case    ActionType.actionComment:
            return "commented on"
        case ActionType.actionShare:
            return "shared"
        case ActionType.actionInvite:
            return "invited"
        case ActionType.actionPublish:
            return "published"
        case ActionType.actionChangeCover:
            return "change his/her cover photo"
        case ActionType.actionContribute:
            if objType == ResourceType.Article || objType == ResourceType.Album {
                return "contributed an " + objType!
            } else {
                return "contributed a " + objType!
            }
        default:
            print("default:...")
            if objType == ResourceType.Article || objType == ResourceType.Album {
                return "posted an " + objType! + " in"
            } else {
                return "posted a " + objType! + " in"
            }
            
        }
    }
    
    func getRevName()->String {
        actionType = feed!.feedAction?.actionType
        let feedObject = feed!.feedObject
        objType = feedObject.objectType
        
        
        if actionType == ActionType.actionLike || actionType == ActionType.actionComment || actionType == ActionType.actionShare {
            switch (objType!) {
            case ResourceType.Article:
                return (feedObject!.objectArticle?.artOwner?.displayName)!
            case ResourceType.Album:
                return (feedObject!.objectAlbum?.albOwner?.displayName)!
            case ResourceType.Link:
                return (feedObject!.objectLink?.lnkOwner?.displayName)!
            case ResourceType.Video:
                return (feedObject!.objectVideo?.vidOwner?.displayName)!
            case ResourceType.Photo:
                return (feedObject!.objectPhoto?.ptOwner?.displayName)!
            default:
                return "you"
            }
        } else if(actionType == ActionType.actionChangeCover) {
            return ""
        } else {
            switch (objType!) {
            case ResourceType.Article:
                return (feedObject!.objectArticle?.artTitle)! + ":"
            case ResourceType.Album:
                return (feedObject!.objectAlbum?.albTitle)! + ":"
            case ResourceType.Link:
                return (feedObject!.objectLink?.lnkWebTitle)! + ":"
            case ResourceType.Video:
                return (feedObject!.objectVideo?.vidTitle)! + ":"
            case ResourceType.Photo:
                return (feedObject!.objectPhoto?.ptTile)! + ":"
            default:
                return "getRevName \(objType!)"
            }
        }
        
    }
    
    func getRevObj()->String {
        actionType = feed!.feedAction?.actionType
        let feedObject = feed!.feedObject
        objType = feedObject.objectType
        
        if actionType == ActionType.actionLike || actionType == ActionType.actionComment || actionType == ActionType.actionShare {
            switch (objType!) {
            case ResourceType.Article:
                return "'s article"
            case ResourceType.Album:
                return "'s album"
            case ResourceType.Link:
                return "'s link"
            case ResourceType.Video:
                return "'s video"
            case ResourceType.Photo:
                return "'s photo"
            default:
                return ""
            }
        } else {
            switch (objType!) {
            case ResourceType.Article:
                return (feedObject!.objectArticle?.artDesc)!
            case ResourceType.Album:
                return (feedObject!.objectAlbum?.albDesc)!
            case ResourceType.Link:
                return (feedObject!.objectLink?.lnkWebDesc)!
            case ResourceType.Video:
                return (feedObject!.objectVideo?.vidDesc)!
            case ResourceType.Photo:
                return (feedObject!.objectPhoto?.ptDesc)!
            default:
                return "getRevObj \(objType!)"
            }
        }

    }
    
    func getImageOfRevObject()->String {
        let obj = feed!.feedObject
        objType = obj.objectType
        
        switch(objType!) {
        case ResourceType.Article:
            let article = obj!.objectArticle
//            var firstPt:Photo = Photo()
            if let firstPt = article?.artPhoto {
                return (firstPt.getPhotoUrl())
            } else {
                return ""
            }
//            if article?.artPhotos?.count > 0 {
//                firstPt = (article!.artPhotos![0])
//            } else {
//                firstPt = (article?.artPhoto)!
//            }
            
        case ResourceType.Album:
            let album = obj!.objectAlbum
            let firstPt:Photo = (album!.albPhotos![0])
            return (firstPt.getPhotoUrl())
        case ResourceType.Link:
            let lnk = obj!.objectLink
            return (lnk?.lnkWebImg)!
        case ResourceType.Video:
            let video = obj!.objectVideo
            return (video?.getVideoThumnail())!
        case ResourceType.Photo:
            let photo = obj!.objectPhoto
            return (photo?.getPhotoUrl())!
        default:
            return "getRevObj \(objType!)"
        }
    }
    
    func setTextForLblDescription() {
        let name = feed!.feedTrigger?.triggerUser.displayName
        let action = getActionOfFeed()
        let revName = getRevName()
        let revObj =  getRevObj()
        
        lblDesc.attributedText = getNotificationDescription(name!, action: action, revName: revName, revObj: revObj)
    }
    
    func getNotificationDescription(name:String, action:String, revName:String, revObj:String)->NSMutableAttributedString {
        
        let desc: NSMutableAttributedString = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName:Semibold14])
        
        desc.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 76, green: 175, blue: 80), range: NSMakeRange(0, desc.length))
        
        
        
        let action:NSMutableAttributedString = NSMutableAttributedString(string: " " + action + " ", attributes: [NSFontAttributeName:Regular14])
        
        action.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 88, green: 88, blue: 88), range: NSMakeRange(0, action.length))
        
        desc.appendAttributedString(action)
        
        
        
        let revName: NSMutableAttributedString = NSMutableAttributedString(string: " " + revName, attributes: [NSFontAttributeName:Semibold14])
        
        revName.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 88, green: 88, blue: 88), range: NSMakeRange(0, revName.length))
        
        desc.appendAttributedString(revName)
        
        
        
        let revObj: NSMutableAttributedString = NSMutableAttributedString(string: revObj, attributes: [NSFontAttributeName:Regular14])
        
        revObj.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 88, green: 88, blue: 88), range: NSMakeRange(0, revObj.length))
        
        desc.appendAttributedString(revObj)
        
        
        
        return desc
        
    }
    
}
