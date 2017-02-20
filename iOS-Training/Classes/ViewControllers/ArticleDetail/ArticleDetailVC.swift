//
//  ArticleDetailVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 2/4/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ArticleDetailVC: ParentVC, ArticleDetailProtocol, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    var articleDetailAPI: ArticleDetailManageAPI?
    
    var dateFormatter = NSDateFormatter()
    var screenWidth: CGFloat?
    var screenHeight: CGFloat?
    
    var isLikes: Bool? = false
    
    var arrListComment: [Comment]?
    
    var articleId: String?
    var articleDetails: Article?
    
    // MARK: Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var consBottomTableViewToSelfView: NSLayoutConstraint!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addItemOnNaviBar(left: ParentVC.ItemType.Back, center: ParentVC.ItemType.SearchBar, right: ParentVC.ItemType.None)
        
        CommonFunc.showIndicator(title: "", view: self.view)
        
        tableView.registerNib(UINib(nibName: "ArticleDetailCell", bundle: nil), forCellReuseIdentifier: "ArticleDetailCell")
        tableView.registerNib(UINib(nibName: "ArticleContentCell", bundle: nil), forCellReuseIdentifier: "ArticleContentCell")
        tableView.registerNib(UINib(nibName: "ArticleCommentCell", bundle: nil), forCellReuseIdentifier: "ArticleCommentCell")
        tableView.separatorColor = UIColor.clearColor()
        tableView.hidden = true
        
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        
        articleDetailAPI = ArticleDetailManageAPI()
        if let articleId = articleId {
            articleDetailAPI?.delegate = self
            articleDetailAPI?.requestArticle(articleId: articleId)
            articleDetailAPI?.requestComment(type: "article", objectId: articleId)
        }
        
        figureTableCellHeight()
        
        let rect = UIScreen.mainScreen().bounds
        screenWidth = rect.size.width
        screenHeight = rect.size.height
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Methods
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        if consBottomTableViewToSelfView.constant < userInfo.height {
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut , animations: {
                self.consBottomTableViewToSelfView.constant = userInfo.height - 48
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        if consBottomTableViewToSelfView.constant >= userInfo.height - 48 {
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut , animations: {
                self.consBottomTableViewToSelfView.constant = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func setContentViewToArticleDetailCell(cell cell: ArticleDetailCell, indexPath: NSIndexPath, photo: Photo) {
        if let image = photo.ptImage {
            let imgString = CommonFunc.getImgFromAvatar(image)
            let imageAspectRatio = photo.ptMaxHeight! / photo.ptMaxWidth!
            
            if let screenWidth = screenWidth {
                cell.consHeightImgPhoto.constant = screenWidth * imageAspectRatio
                cell.imgPhoto.layoutIfNeeded()
                CommonFunc.getImageData(imgString, imageView: cell.imgPhoto)
            }
        }
        
    }
    
    func figureTableCellHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
    }
    
    // MARK: - ArticleDetailDelegate Methods
    
    func articleDetailComment(comment comment: [Comment]) {
        arrListComment = comment
        tableView.reloadData()
    }
    
    func articleDetail(article article: Article) {
        articleDetails = article
        tableView.reloadData()
        tableView.hidden = false
        CommonFunc.hideIndicator(self.view)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArticleDetailCell", forIndexPath: indexPath) as! ArticleDetailCell
            if let articleDetails = articleDetails {
                let owner: Users = articleDetails.artOwner!
                cell.lblDisplayName.text = owner.displayName
                let stringImg = CommonFunc.getImgFromAvatar(owner.avatar!)
                CommonFunc.getImageData(stringImg, imageView: cell.imgAvatar)
                
                let date = dateFormatter.dateFromString(articleDetails.artCreated!)
                let dateCreated = CommonFunc.dateDiff(date!)
                
                let stringInfoAlbum = CommonFunc.getAttributeStringInfoImage(location: articleDetails.artLocation!,
                                                                    colorTextLocation: UIColor(red: 33, green: 33, blue: 33),
                                                                                 date: dateCreated)
                cell.lblInfo.attributedText = stringInfoAlbum
                cell.lblTitleArticle.text = articleDetails.artTitle
                
                if let photoArt = articleDetails.artPhoto {
                    setContentViewToArticleDetailCell(cell: cell, indexPath: indexPath, photo: photoArt)
                }
                
                if articleDetails.artPhoto == nil {
                    cell.consHeightImgPhoto.constant = 0
                }
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArticleContentCell", forIndexPath: indexPath) as! ArticleContentCell
            if let articleDetails = articleDetails {
                cell.lblContent.text = articleDetails.artContent?.html2String
                
                cell.article = articleDetails
                
                for liker in articleDetails.artLikers! {
                    
                    if articleDetails.artLikers?.count != 0 {
                        if articleDetails.artLikers?.count == 1 {
                            let userLiker = liker.displayName
                            cell.lblLiker.attributedText = CommonFunc.getAttributeStringOnlyOneLiker(displayName: userLiker!)
                        } else {
                            if let liker = articleDetails.artLikers?.first {
                                let userInLiker = liker.displayName
                                let numberLiker = (articleDetails.artLikers?.count)! - 1
                                cell.lblLiker.attributedText = CommonFunc.getAttributeStringInfoLikerPhoto(displayName: userInLiker!,
                                                                                                           numberLiker: numberLiker)
                            }
                        }
                    } else {
                        cell.lblLiker.attributedText = CommonFunc.getAttributeStringInfoLikerPhoto(displayName: "", numberLiker: 0)
                    }
                    
                    if liker.id == AccountManager.sharedInstance.getInfoUser().id {
                        cell.btnLike.setImage(UIImage(named: "ic_button_unlike.png"), forState: .Normal)
                        cell.isLike = true
                        break
                    } else {
                        cell.btnLike.setImage(UIImage(named: "ic_button_like.png"), forState: .Normal)
                        cell.isLike = false
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCommentCell", forIndexPath: indexPath) as! ArticleCommentCell
            if let arrListComment = arrListComment {
                cell.articleComment = arrListComment
                cell.tableView.reloadData()
                cell.consHeightTableView.constant = 234
            }
            
            if arrListComment?.count == 0 {
                cell.consHeightTableView.constant = 0
            }
            
            return cell
        }
    }
    
}
