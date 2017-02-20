//
//  TriggerCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/18/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

// MARK: structs

struct ResourceType {
    static let Link             = "link"
    static let Video            = "video"
    static let Album            = "album"
    static let Article          = "article"
    static let Topic            = "topic"
    static let Photo            = "photo"
    static let User             = "user"
    static let Comment          = "comment"
    static let SpendTime        = "spend_time"
}

struct ActionType {
    static let actionComment     = "comment"
    static let actionLike        = "like"
    static let actionShare       = "share"
    static let actionContribute  = "contribute"
    static let actionInvite  = "invite"
    static let actionChangeCover  = "change_cover"
    static let actionPublish  = "publish"
    static let actionOnline = "online"
    static let actionCreate = "create"
    static let actionPost = "post"
    static let actionSpendTime = "Spend time"
}

class TriggerCell: UITableViewCell {
    
    // MARK: outlets + variables

    
    @IBOutlet var imvTriggerAvt: UIImageView!
    @IBOutlet var lblTriggerName: UILabel!
    @IBOutlet var lblTriggerInfo: UILabel!
    @IBOutlet var btnTriggerActions: UIButton!
    
    @IBOutlet var icSmallTriangle: UIImageView!
    @IBOutlet var imvOwnerAvt: UIImageView!
    @IBOutlet var lblOwnerName: UILabel!
    @IBOutlet var lblPostInfo: UILabel!
    @IBOutlet var btnOwnerActions: UIButton!
    
    @IBOutlet var triggerView: UIView!
    @IBOutlet var subview: UIView!
    @IBOutlet var titleView: UIView!
    @IBOutlet var contentSubView: UIView!

    @IBOutlet var bottomView: UIView!
    
    
    @IBOutlet var lblLikeShareNumber: UILabel!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnComment: UIButton!
    @IBOutlet var btnShare: UIButton!
    
    @IBOutlet var consTopTitleViewToSuperView: NSLayoutConstraint!
    
    @IBOutlet var consTopTitleViewToBottomTriggerView: NSLayoutConstraint!
    
    var feedObj: Feed?
    weak var revObj: FeedReceiver?
    weak var objOwner: Users?
    var likers:[Users]? = []
    
    var albumCell:AlbumCell?
    var linkCell: LinkCell?
    var videoCell: VideoCell?
    var articleCell: ArticleCell?
    
    let dateFormatter = NSDateFormatter()
    
    let usrId = AccountManager.sharedInstance.getInfoUser().id
    
    var tapGesture: UITapGestureRecognizer!
    var managerFlow: TriggerCellManagerFlow!
    
    var tapGestureForSelf:UITapGestureRecognizer!
    
//    var navi:UINavigationController! = UINavigationController()
    
    // MARK: lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let ownerAvt = self.imvOwnerAvt {
            ownerAvt.layer.cornerRadius = ownerAvt.frame.size.width / 2
            ownerAvt.clipsToBounds = true
        }
        
        if let triggerAvt = self.imvTriggerAvt{
            triggerAvt.layer.cornerRadius = 2
            triggerAvt.clipsToBounds = true
        }
        if let likeBtn = self.btnLike{
            likeBtn.selected = false
        }
        
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        tapGesture = UITapGestureRecognizer(target: self, action: "goToDetail:")
        
        tapGestureForSelf = UITapGestureRecognizer(target: self, action: "goToDetail:")
        self.contentView.addGestureRecognizer(tapGestureForSelf)
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Navigation
    internal func setupNavi(navi:UINavigationController) {
        managerFlow = TriggerCellManagerFlow(navi: navi)
    }
    
    // MARK: set Layout Constraints for Subview
    
    private func setLayoutConstraints(view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        subview.addSubview(view)
        
        subview.addConstraint(NSLayoutConstraint(item: view,
            attribute   : NSLayoutAttribute.Top,
            relatedBy   : NSLayoutRelation.Equal,
            toItem      : subview,
            attribute   : NSLayoutAttribute.Top,
            multiplier  : 1,
            constant    : 0))
        
        subview.addConstraint(NSLayoutConstraint(item: view,
            attribute   : NSLayoutAttribute.Left,
            relatedBy   : NSLayoutRelation.Equal,
            toItem      : subview,
            attribute   : NSLayoutAttribute.Left,
            multiplier  : 1,
            constant    : 0))
        
        subview.addConstraint(NSLayoutConstraint(item: view,
            attribute   : NSLayoutAttribute.Right,
            relatedBy   : NSLayoutRelation.Equal,
            toItem      : subview,
            attribute   : NSLayoutAttribute.Right,
            multiplier  : 1,
            constant    : 0))
        
        subview.addConstraint(NSLayoutConstraint(item: subview,
            attribute   : NSLayoutAttribute.Bottom,
            relatedBy   : NSLayoutRelation.Equal,
            toItem      : view,
            attribute   : NSLayoutAttribute.Bottom,
            multiplier  : 1,
            constant    : 0))
    }
    
    // MARK: set Content to cell
    
    internal func setContentToTriggerCell(feed:Feed) {
        feedObj = feed
        configTriggerView(feedObj!)
        setContentToTitleView((feedObj?.feedObject.objectType)!)
        setContentToSubViewCell((feedObj?.feedObject.objectType)!)
        setTextForLabelLike((feedObj?.feedObject.objectType)!)
    }
    
    private func configTriggerView(feed:Feed) {
        if feed.feedAction != nil {
            let feedActionType = (feed.feedAction?.actionType)!
            if feedActionType == ActionType.actionLike || feedActionType == ActionType.actionComment || feedActionType == ActionType.actionShare {
            
                icSmallTriangle.hidden = false
            
                consTopTitleViewToSuperView.priority = 500
                consTopTitleViewToBottomTriggerView.priority = 999
                triggerView.alpha = 1
                btnOwnerActions.hidden = true
                
                let triggerAvtUrl = feedObj?.feedTrigger?.triggerUser.getUserAvatar()
                CommonFunc.getImageData(triggerAvtUrl!, imageView: imvTriggerAvt)
                lblTriggerName.text = feedObj?.feedTrigger?.triggerUser.displayName
                
                let date = dateFormatter.dateFromString((feedObj?.feedCreate)!)
                let dateCreated = CommonFunc.dateDiff(date!)
                let info: NSMutableAttributedString = NSMutableAttributedString(string: feedActionType + " this content - \(dateCreated)", attributes: [NSFontAttributeName:Regular14])
                info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155, green: 155, blue: 155), range: NSMakeRange(0, info.length))
                
                lblTriggerInfo.attributedText = info
            } else {
                consTopTitleViewToSuperView.priority = 999
                consTopTitleViewToBottomTriggerView.priority = 500
                triggerView.alpha = 0
                icSmallTriangle.hidden = true
                btnOwnerActions.hidden = false
            }
            
        } else {
            consTopTitleViewToSuperView.priority = 999
            consTopTitleViewToBottomTriggerView.priority = 500
            triggerView.alpha = 0
            icSmallTriangle.hidden = true
            btnOwnerActions.hidden = false
        }
    }
    
    func setContentToTitleView(resourceType:String) {
        switch(resourceType) {
            
        case ResourceType.Video:
            
            let vid = feedObj?.feedObject.objectVideo
            objOwner = vid?.vidOwner
            let urlAvtUser = objOwner!.getUserAvatar()
            CommonFunc.getImageData(urlAvtUser, imageView: imvOwnerAvt)
            
            lblOwnerName.text = objOwner!.displayName
            
            let date = dateFormatter.dateFromString((vid?.vidCreated)!)
            let dateCreated = CommonFunc.dateDiff(date!)
            
            var vidInfo:NSMutableAttributedString
            
            revObj = vid?.vidReceiver
            if revObj?.revType == "user" {
                vidInfo = CommonFunc.getAttributeString(dateCreated)
                lblPostInfo.attributedText = vidInfo
            } else {
                vidInfo = CommonFunc.getMutableAttributedString((revObj?.revTopic!.tpTitle)!, date: dateCreated)
                lblPostInfo.attributedText = vidInfo
            }
            
        case ResourceType.Album:
            
            let album = feedObj?.feedObject.objectAlbum
            objOwner = album?.albOwner
            let urlAvtUser = objOwner!.getUserAvatar()
            CommonFunc.getImageData(urlAvtUser, imageView: imvOwnerAvt)
            
            lblOwnerName.text = objOwner!.displayName
            
            let date = dateFormatter.dateFromString((album?.albCreated)!)
            let dateCreated = CommonFunc.dateDiff(date!)
            
            var vidInfo:NSMutableAttributedString
            
            revObj = album?.albReceiver
            if revObj?.revType == "user" {
                vidInfo = CommonFunc.getAttributeString(dateCreated)
                lblPostInfo.attributedText = vidInfo
            } else {
                vidInfo = CommonFunc.getMutableAttributedString((revObj?.revTopic!.tpTitle)!, date: dateCreated)
                lblPostInfo.attributedText = vidInfo
            }
        
        case ResourceType.Photo:
            
            
            let photo = feedObj?.feedObject.objectPhoto
            objOwner = photo?.ptOwner
            let urlAvtUser = objOwner!.getUserAvatar()
            CommonFunc.getImageData(urlAvtUser, imageView: imvOwnerAvt)
            
            lblOwnerName.text = objOwner!.displayName
            
            let date = dateFormatter.dateFromString((photo?.ptCreated)!)
            let dateCreated = CommonFunc.dateDiff(date!)
            
            var ptInfo:NSMutableAttributedString
            
            revObj = photo?.ptReceiver
            if revObj?.revType == "user" {
                ptInfo = CommonFunc.getAttributeString(dateCreated)
                lblPostInfo.attributedText = ptInfo
            } else {
                ptInfo = CommonFunc.getMutableAttributedString((revObj?.revTopic!.tpTitle)!, date: dateCreated)
                lblPostInfo.attributedText = ptInfo
            }
            
        case ResourceType.Link:
            
            let link = feedObj?.feedObject.objectLink
            
            objOwner = link?.lnkOwner
            
            let urlAvtUser = objOwner!.getUserAvatar()
            CommonFunc.getImageData(urlAvtUser, imageView: imvOwnerAvt)
            
            lblOwnerName.text = objOwner!.displayName
            
            let date = dateFormatter.dateFromString((link?.lnkCreated)!)
            let dateCreated = CommonFunc.dateDiff(date!)
            
            var lnkInfo:NSMutableAttributedString
            
            revObj = link?.lnkReceiver
            if revObj?.revType == "user" {
                lnkInfo = CommonFunc.getAttributeString(dateCreated)
                lblPostInfo.attributedText = lnkInfo
            } else {
                lnkInfo = CommonFunc.getMutableAttributedString((revObj!.revTopic?.tpTitle)!, date: dateCreated)
                lblPostInfo.attributedText = lnkInfo
            }

            
        case ResourceType.Article:
            
            let article = feedObj?.feedObject.objectArticle
            objOwner = article?.artOwner
            
            let urlAvtUser = objOwner!.getUserAvatar()
            CommonFunc.getImageData(urlAvtUser, imageView: imvOwnerAvt)
            
            lblOwnerName.text = objOwner!.displayName
            
            let date = dateFormatter.dateFromString((article?.artCreated)!)
            let dateCreated = CommonFunc.dateDiff(date!)
            
            var albInfo:NSMutableAttributedString

            
            revObj = article?.artReceiver
            if revObj?.revType == "user" {
                albInfo = CommonFunc.getAttributeString(dateCreated)
                lblPostInfo.attributedText = albInfo
            } else {
                albInfo = CommonFunc.getMutableAttributedString((revObj?.revTopic!.tpTitle)!, date: dateCreated)
                lblPostInfo.attributedText = albInfo
            }
            
        default:
            print("title ???")
            break
        }
    }
    
    func setContentToSubViewCell(resourceType:String){
        
        
        for view in subview.subviews {
            view.removeFromSuperview()
        }
        btnLike.selected = setLikeButtonStatus((feedObj?.feedObject)!)
        switch(resourceType) {
        case ResourceType.Video:
            if videoCell == nil{
                videoCell =  NSBundle.mainBundle().loadNibNamed("VideoCell", owner: self, options: nil).first as? VideoCell
            }
            videoCell?.video = feedObj?.feedObject.objectVideo
            videoCell?.setContentToVideoView()
            videoCell?.imvVideoThumb.addGestureRecognizer(tapGesture)
            videoCell?.btnPlay.addTarget(self, action: "goToDetail:", forControlEvents: UIControlEvents.TouchUpInside)
            setLayoutConstraints(videoCell!.contentView)
        case ResourceType.Album, ResourceType.Photo:
            if albumCell == nil{
                albumCell =  NSBundle.mainBundle().loadNibNamed("AlbumCell", owner: self, options: nil).first as? AlbumCell
            }
            var ptList:[Photo] = []
            if resourceType == ResourceType.Photo {
                ptList.append((feedObj?.feedObject.objectPhoto)!)
                albumCell?.listPhoto = ptList
                albumCell?.total = 1
            } else {
                albumCell?.album = feedObj?.feedObject.objectAlbum
                albumCell?.listPhoto = feedObj?.feedObject.objectAlbum?.albPhotos
                albumCell?.total = feedObj?.feedObject.objectAlbum?.albTotalPhotos
            }            
            albumCell?.setContentToAlbumCell()
            albumCell?.imagesView.addGestureRecognizer(tapGesture)
            setLayoutConstraints(albumCell!.contentView)
        case ResourceType.Link:
            if linkCell == nil{
                linkCell =  NSBundle.mainBundle().loadNibNamed("LinkCell", owner: self, options: nil).first as? LinkCell
            }
            linkCell?.link = feedObj?.feedObject.objectLink
            linkCell?.setContentToLinkCell()
            setLayoutConstraints(linkCell!.contentView)
        case ResourceType.Article:
            if articleCell == nil{
                articleCell =  NSBundle.mainBundle().loadNibNamed("ArticleCell", owner: self, options: nil).first as? ArticleCell
            }
            articleCell?.article = feedObj?.feedObject.objectArticle
            articleCell?.setContentToArticleCell()
            articleCell?.articleView.addGestureRecognizer(tapGesture)
            setLayoutConstraints(articleCell!.contentView)
        default:
            print("???")
            break
        }
    }
    
    func setTextForLabelLike(resourceType:String) {
        
        let resourceObj:FeedObject! = feedObj?.feedObject
        
        var like:Int! = 0
        var cmt:Int! = 0
        var share:Int! = 0
        
        switch(resourceType) {
        case ResourceType.Video:
            let vidObj = resourceObj.objectVideo
            like = (vidObj?.vidLike)!
            cmt = (vidObj?.vidComment)!
            share = (vidObj?.vidShare)!
            setTextForLabel(like, cmt: cmt, share: share)
        case ResourceType.Album:
            let albObj = resourceObj.objectAlbum
            like = (albObj?.albLike)!
            cmt = (albObj?.albComment)!
            share = (albObj?.albShare)!
            setTextForLabel(like, cmt: cmt, share: share)
        case ResourceType.Photo:
            let photoObj = resourceObj.objectPhoto
            like = (photoObj?.ptLike)!
            cmt = (photoObj?.ptCmt)!
            share = (photoObj?.ptShare)!
            setTextForLabel(like, cmt: cmt, share: share)
        case ResourceType.Link:
            let lnkObj = resourceObj.objectLink
            like = (lnkObj?.lnkLike)!
            cmt = (lnkObj?.lnkComment)!
            share = (lnkObj?.lnkShare)!
            setTextForLabel(like, cmt: cmt, share: share)
        case ResourceType.Article:
            let artObj = resourceObj.objectArticle
            like = (artObj?.artLike)!
            cmt = (artObj?.artComment)!
            share = (artObj?.artShare)!
            setTextForLabel(like, cmt: cmt, share: share)
        default:
            print("???")
            break
        }
    }
    
    func setTextForLabel(like:Int, cmt:Int, share:Int) {
        let stringLike = like > 1 ? "Likes" : "Like"
        let stringCmt = cmt > 1 ? "Comments" : "Comment"
        let stringShare = cmt > 1 ? "Shares" : "Share"
        lblLikeShareNumber.text = "\(like) \(stringLike) \(cmt) \(stringCmt) \(share) \(stringShare)"
    }
    
    func setLikeButtonStatus(feedObj:FeedObject) -> Bool {
        
        switch(feedObj.objectType) {
        case ResourceType.Video:
            likers = feedObj.objectVideo?.vidLikers
            if likers?.count > 0 {
                for liker:Users in likers! {
                    if liker.id == usrId {
                        return true
                    }
                }
            }
        case ResourceType.Album:
            likers = feedObj.objectAlbum?.albLikers
            if likers?.count > 0 {
                for liker:Users in likers! {
                    if liker.id == usrId {
                        return true
                    }
                }
            }
        case ResourceType.Photo:
            likers = feedObj.objectPhoto?.ptLikers
            if likers?.count > 0 {
                for liker:Users in likers! {
                    if liker.id == usrId {
                        return true
                    }
                }
            }
        case ResourceType.Link:
            likers = feedObj.objectLink?.lnkLikers
            if likers?.count > 0 {
                for liker:Users in likers! {
                    if liker.id == usrId {
                        return true
                    }
                }
            }
        case ResourceType.Article:
            likers = feedObj.objectArticle?.artLikers
            if likers?.count > 0 {
                for liker:Users in likers! {
                    if liker.id == usrId {
                        return true
                    }
                }
            }
        default:
            return false
        }
        return false
    }
    
    // MARK: Actions
    
    func goToDetail(sender:AnyObject) {
        print("thay roi.... :)")
        var type:String! = ""
        if let resourceType:String = feedObj?.feedObject.objectType {
            type = resourceType
        } else {
            print("resource type:ko thay chi ca...")
        }
        print("resource type: \(type)")
        switch (type) {
        case ResourceType.Photo:
            if let photo:Photo = (feedObj?.feedObject.objectPhoto)! {
                managerFlow.goToPhotoDetailsVC(photo)
            }
            
        case ResourceType.Album:
            if let album:Album = (feedObj?.feedObject.objectAlbum)! {
                managerFlow.goToAlbumDetailsVC(album)
            }
        case ResourceType.Article:
            if let article:Article = (feedObj?.feedObject.objectArticle)! {
                managerFlow.goToArticleDetailsVC(article.artId!)
            }
        case ResourceType.Video:
            if let video:Video = (feedObj?.feedObject.objectVideo)! {
                managerFlow.goToVideoDetailsVC(video.vidId!)
            }
        default:
            print("chua co chi o day ca!!!")
        }
    }
    
    @IBAction func doLikeObject(sender: UIButton) {
        let resourceObj:FeedObject! = feedObj?.feedObject
        let resourceType:String! = feedObj?.feedObject.objectType
        btnLike.selected = true
        
        var like:Int! = 0
        var cmt:Int! = 0
        var share:Int! = 0
        
        switch(resourceType) {
            
        case ResourceType.Video:
            let vidObj = resourceObj.objectVideo
            TriggerCellManagerAPI.doLikeObject(ResourceType.Video, objId: (vidObj?.vidId)!)
            like = (vidObj?.vidLike)! + 1
            cmt = (vidObj?.vidComment)!
            share = (vidObj?.vidShare)!
            setTextForLabel(like, cmt: cmt, share: share)
            
        case ResourceType.Album:
            let albObj = resourceObj.objectAlbum
            TriggerCellManagerAPI.doLikeObject(ResourceType.Album, objId: (albObj?.albId)!)
            like = (albObj?.albLike)! + 1
            cmt = (albObj?.albComment)!
            share = (albObj?.albShare)!
            setTextForLabel(like, cmt: cmt, share: share)
            
        case ResourceType.Photo:
            let photoObj = resourceObj.objectPhoto
            TriggerCellManagerAPI.doLikeObject(ResourceType.Photo, objId: (photoObj?.ptId)!)
            like = (photoObj?.ptLike)! + 1
            cmt = (photoObj?.ptCmt)!
            share = (photoObj?.ptShare)!
            setTextForLabel(like, cmt: cmt, share: share)
            
        case ResourceType.Link:
            let lnkObj = resourceObj.objectLink
            TriggerCellManagerAPI.doLikeObject(ResourceType.Link, objId: (lnkObj?.lnkId)!)
            like = (lnkObj?.lnkLike)! + 1
            cmt = (lnkObj?.lnkComment)!
            share = (lnkObj?.lnkShare)!
            setTextForLabel(like, cmt: cmt, share: share)
            
        case ResourceType.Article:
            let artObj = resourceObj.objectArticle
            TriggerCellManagerAPI.doLikeObject(ResourceType.Article, objId: (artObj?.artId)!)
            like = (artObj?.artLike)! + 1
            cmt = (artObj?.artComment)!
            share = (artObj?.artShare)!
            setTextForLabel(like, cmt: cmt, share: share)
        default:
            print("???")
            break
        }

    }
}
