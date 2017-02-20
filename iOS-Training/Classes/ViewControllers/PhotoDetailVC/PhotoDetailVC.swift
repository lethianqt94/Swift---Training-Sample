//
//  PhotoDetailVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class PhotoDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PhotoDetailDelegate {
    
    // MARK: - Variables
    
    var photo: Photo?
    var photoDetailAPI: PhotoDetailManageAPI?
    var arrListComment: [Comment]?
    
    let dateFormatter = NSDateFormatter()
    var heightImgPhoto: CGFloat?
    
    var screenHeight: CGFloat?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnUnlike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblInfoPhoto: UILabel!
    @IBOutlet weak var lblLikeCommentShare: UILabel!
    @IBOutlet weak var lblInfoLiker: UILabel!
    
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var imgTriangle: UIImageView!
    
    @IBOutlet weak var tfComment: UITextField!
    
    @IBOutlet weak var consHeightCommentView: NSLayoutConstraint!
    @IBOutlet weak var consHeightImagePhoto: NSLayoutConstraint!
    @IBOutlet weak var consBottomImgPhotoToSelfView: NSLayoutConstraint!
    @IBOutlet weak var consTopImgPhotoToSelfView: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.contentInset.bottom = 55
        
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        
        imgTriangle.hidden = true
        
        viewComment.hidden = true
        viewComment.layer.cornerRadius = 4
        viewComment.clipsToBounds = true
        
        photoDetailAPI = PhotoDetailManageAPI()
        
        btnUnlike.hidden = true
        
        lblDisplayName.hidden = true
        lblInfoPhoto.hidden = true
        lblLikeCommentShare.hidden = true
        
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        
        getHeightScreen()
        loadImage()
        loadTextForLabel()
        setPaddingViewForComment()
        initTextFieldComment()
        fixHeightTableViewCell()
        setContentForImagePhoto()
        
        if let photo = photo {
            if photo.ptLikers?.count != 0 {
                if photo.ptLikers?.count == 1 {
                    for liker in photo.ptLikers! {
                        let userLiker = liker.displayName
                        lblInfoLiker.attributedText = CommonFunc.getAttributeStringOnlyOneLiker(displayName: userLiker!)
                    }
                } else {
                    for liker in photo.ptLikers! {
                        let userInLiker = liker.displayName
                        let numberLiker = (photo.ptLikers?.count)! - 1
                        lblInfoLiker.attributedText = CommonFunc.getAttributeStringInfoLikerPhoto(displayName: userInLiker!,
                                                                                                  numberLiker: numberLiker)
                        break
                    }
                }
            } else {
                lblInfoLiker.attributedText = CommonFunc.getAttributeStringInfoLikerPhoto(displayName: "", numberLiker: 0)
            }
        }
        
        photoDetailAPI = PhotoDetailManageAPI()
        if let photo = photo {
            photoDetailAPI?.delegate = self
            photoDetailAPI?.requestComment(type: "photo", objectId: photo.ptId!)
        }
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
    
    // MARK: - Override Method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: PhotoDetailDelegate Method
    
    func photoDetailComment(comment comment: [Comment]) {
        arrListComment = comment
        tableView.reloadData()
    }
    
    // MARK: - Custom Methods
    
    func getHeightScreen() {
        let rect = UIScreen.mainScreen().bounds
        screenHeight = rect.size.height
    }
    
    func setContentForImagePhoto() {
        if let heightImgPhoto = heightImgPhoto {
            consHeightImagePhoto.constant = heightImgPhoto
            if let screenHeight = screenHeight {
                consBottomImgPhotoToSelfView.constant = (screenHeight / 2) - (heightImgPhoto / 2)
                consTopImgPhotoToSelfView.constant = (screenHeight / 2) - (heightImgPhoto / 2)
            }
        }
    }
    
    func fixHeightTableViewCell() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
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
    
    func loadImage() {
        if let photo = photo {
            let imgString = CommonFunc.getImgFromAvatar(photo.ptImage!)
            CommonFunc.getImageData(imgString, imageView: imgPhoto)
            lblDisplayName.hidden = false
            lblInfoPhoto.hidden = false
            lblLikeCommentShare.hidden = false
        }
    }
    
    func loadTextForLabel() {
        if let photo = photo {
            lblDisplayName.text = photo.ptOwner?.displayName!
            let date = dateFormatter.dateFromString(photo.ptCreated!)
            let dateCreated = CommonFunc.dateDiff(date!)
            let stringInfo = CommonFunc.getAttributeStringInfoImage(location: photo.ptLocation!,
                                                           colorTextLocation: UIColor(red: 255, green: 255, blue: 255),
                                                                        date: dateCreated)
            lblInfoPhoto.attributedText = stringInfo
            
            if photo.ptIsLike! {
                btnLike.hidden = true
                btnUnlike.hidden = false
            }
            
            lblLikeCommentShare.text = "\(photo.ptLike!) Likes   \(photo.ptCmt!) Comments   \(photo.ptShare!) Shares"
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        if let screenHeight = screenHeight {
            if consHeightCommentView.constant > (screenHeight - userInfo.height) {
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut , animations: {
                    self.consHeightCommentView.constant = (screenHeight - userInfo.height) - 30
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        viewComment.hidden = true
        imgTriangle.hidden = true
        print("keyboard hide!!!")
    }
    
    // MARK: - Actions
    
    @IBAction func tapToClose(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        UIApplication.sharedApplication().statusBarHidden = false
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func tapToLike(sender: AnyObject) {
        if let photo = photo {
            photoDetailAPI?.requestLike(type: "photo", albumId: photo.ptId!)
            photo.ptLike! += 1
            lblLikeCommentShare.text = "\(photo.ptLike!) Likes   \(photo.ptCmt!) Comments   \(photo.ptShare!) Shares"
            
            btnLike.hidden = true
            btnUnlike.hidden = false
        }
    }
    
    @IBAction func tapToUnlike(sender: AnyObject) {
        if let photo = photo {
            photoDetailAPI?.requestLike(type: "photo", albumId: photo.ptId!)
            photo.ptLike! -= 1
            lblLikeCommentShare.text = "\(photo.ptLike!) Likes   \(photo.ptCmt!) Comments   \(photo.ptShare!) Shares"
            
            btnLike.hidden = false
            btnUnlike.hidden = true
        }
    }
    
    @IBAction func tapToComment(sender: AnyObject) {
        imgTriangle.hidden = false
        viewComment.hidden = false
        tfComment.becomeFirstResponder()
    }

    @IBAction func tapToSendComment(sender: AnyObject) {
        print("send comment")
    }
    
    @IBAction func tapToShare(sender: AnyObject) {
        
    }
    
    @IBAction func tapToDoneComment(sender: AnyObject) {
        viewComment.hidden = true
        imgTriangle.hidden = true
        tfComment.resignFirstResponder()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arrListComment = arrListComment {
            return arrListComment.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        if let arrListComment = arrListComment {
            let comment = arrListComment[indexPath.row]
            cell.lblComment.text = comment.cmtContent
            
            let date = dateFormatter.dateFromString(comment.cmtDate!)
            let dateCreated = CommonFunc.dateDiff(date!)
            cell.lblTime.text = dateCreated
            
            if let owner = comment.cmtOwner {
                cell.lblDisplayName.text = owner.displayName
                let stringImgAvatar = CommonFunc.getImgFromAvatar(owner.avatar!)
                CommonFunc.getImageData(stringImgAvatar, imageView: cell.imgAvatar)
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
