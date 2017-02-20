//
//  PhotoAlbumVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class PhotoAlbumVC: ParentVC, UITableViewDataSource, UITableViewDelegate, PhotoAlbumDelegate, InfoAlbumCellDelegate, PhotoCellDelegate {
    
    // MARK: - Variables
    
    var album: Album?
    var arrPhoto: NSMutableArray?
    var user: Users?
    var photoAlbumAPI: PhotoAlbumManageAPI?
    
    var dateFormatter = NSDateFormatter()
    var screenWidth: CGFloat?
    
    var actionUnlikePhoto: Bool? = false
    var actionLikePhoto: Bool? = false
    
    var actionLikeAlbum: Bool? = false
    var actionUnlikeAlbum: Bool? = false
    
    var photo: Photo?
    var pagePhoto: Int? = 1
    var totalPage: Int?
    var totalPhoto: Int?
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addItemOnNaviBar(left: ParentVC.ItemType.Close, center: ParentVC.ItemType.Title, right: ParentVC.ItemType.None)
        
        tableView.hidden = true
        CommonFunc.showIndicator(title: "", view: self.view)
        photoAlbumAPI = PhotoAlbumManageAPI()
        if let photoAlbumAPI = photoAlbumAPI {
            photoAlbumAPI.delegate = self
            if let album = album {
                photoAlbumAPI.requestAlbumWithAlbumId(albumId: album.albId!,page: 1)
                setTitleForVC("Album of \(album.albTitle!)", fontText: Semibold14)
                
                for object in album.albLikers! {
                    let liker: Users = object
                    if liker.id == AccountManager.sharedInstance.getInfoUser().id {
                        album.albIsLike = true
                        break
                    } else {
                        album.albIsLike = false
                    }
                }
                
            }
        }
        
        let rect = UIScreen.mainScreen().bounds
        screenWidth = rect.size.width
        
        let nibInfoAlbumCell = UINib.init(nibName: "InfoAlbumCell", bundle: nil)
        tableView.registerNib(nibInfoAlbumCell, forCellReuseIdentifier: "InfoAlbumCell")
        
        let nibPhotoCell = UINib.init(nibName: "PhotoCell", bundle: nil)
        tableView.registerNib(nibPhotoCell, forCellReuseIdentifier: "PhotoCell")
        
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        
        figureTableCellHeight()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Override Methods
    
    override func btnCloseTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - PhotoCellDelegate Methods
    
    func photoCellActionLike(event: Bool) {
        if event {
            actionLikePhoto = true
            tableView.reloadData()
        }
    }
    
    func photoCellActionUnLike(event: Bool) {
        if event {
            actionUnlikePhoto = true
            tableView.reloadData()
        }
    }
    
    // MARK: - InfoAlbumCellDelegate Methods
    
    func infoAlbumCellActionUnLike(event event: Bool) {
        if event {
            actionUnlikeAlbum = true
            tableView.reloadData()
        }
    }
    
    func infoAlbumCellActionLike(event event: Bool) {
        if event {
            actionLikeAlbum = true
            tableView.reloadData()
        }
    }
    
    // MARK: - PhotoAlbumDelegate Methods
    
    func photoAlbum(listPhoto listPhoto: ListPhoto) {
        if let total = listPhoto.total {
            totalPhoto = total
        }
        if let listAlbum = listPhoto.listPhoto {
            if arrPhoto == nil {
                arrPhoto = NSMutableArray()
                for object in listAlbum {
                    user = Users()
                    user = object.ptOwner
                    
                    for liker in object.ptLikers! {
                        if (liker.id == AccountManager.sharedInstance.getInfoUser().id) {
                            object.ptIsLike = true
                            break
                        } else {
                            object.ptIsLike = false
                        }
                    }
                    
                    if let arrPhoto = arrPhoto {
                        arrPhoto.addObject(object)
                        tableView.reloadData()
                    }
                }
                CommonFunc.hideIndicator(self.view)
                tableView.hidden = false
            } else {
                for object in listAlbum {
                    
                    for liker in object.ptLikers! {
                        if (liker.id == AccountManager.sharedInstance.getInfoUser().id) {
                            object.ptIsLike = true
                            break
                        } else {
                            object.ptIsLike = false
                        }
                    }
                    
                    if let arrPhoto = arrPhoto {
                        arrPhoto.addObject(object)
                        tableView.reloadData()
                    }
                }
                CommonFunc.hideIndicator(self.view)
            }
        }
        
        calculateNumberPagePhoto()
    }
    
    // MARK: - Custom Methods
    
    func calculateNumberPagePhoto() {
        if let totalPhoto = totalPhoto {
            totalPage = Int(totalPhoto / LIMIT_PAGE_NUMBER) + 1
        }
    }
    
    func loadMorePhoto(page page: Int) {
        if let album = album {
            photoAlbumAPI?.requestAlbumWithAlbumId(albumId: album.albId!, page: page)
        }
    }
    
    func setContentViewToPhotoCell(cell cell: PhotoCell, indexPath: NSIndexPath) {
        if let arrPhoto = arrPhoto {
            if let photo = arrPhoto[indexPath.row] as? Photo {
                let imgString = CommonFunc.getImgFromAvatar(photo.ptImage!)
                let imageAspectRatio = photo.ptMaxHeight! / photo.ptMaxWidth!
                
                if let screenWidth = screenWidth {
                    cell.consHeightImgPhoto.constant = screenWidth * imageAspectRatio
                    cell.heightImgPhoto = screenWidth * imageAspectRatio
                    cell.imgPhoto.layoutIfNeeded()
                    CommonFunc.getImageData(imgString, imageView: cell.imgPhoto)
                }
            }
        }
    }
    
    func figureTableCellHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let arrPhoto = arrPhoto {
                return arrPhoto.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoAlbumCell", forIndexPath: indexPath) as! InfoAlbumCell
            if let user = user {
                cell.lblDisplayName.text = user.displayName
                
                if album!.albDesc == "" {
                    cell.consHeightLabelDescription.constant = 0
                    cell.consBottomLabelTagToViewInfo.constant = 0
                }
                
                cell.lblDescription.text = album!.albDesc
                
                let date = dateFormatter.dateFromString(album!.albCreated!)
                let dateCreated = CommonFunc.dateDiff(date!)

                let stringInfoAlbum = CommonFunc.getAttributeStringInfoImage(location: album!.albLocation!,
                                                                    colorTextLocation: UIColor(red: 33, green: 33, blue: 33),
                                                                                 date: dateCreated)
                cell.lblInfoPost.attributedText = stringInfoAlbum
                
                if album!.albLocation == "" {
                    cell.lblLocation.text = "Not add location"
                } else {
                    cell.lblLocation.text = album!.albLocation
                }
                
                let imgString = CommonFunc.getImgFromAvatar(user.avatar!)
                CommonFunc.getImageData(imgString, imageView: cell.imgAvatar)
                if let album = album {
                    cell.album = album
                    
                    if actionLikeAlbum! {
                        album.albLike! += 1
                        album.albIsLike = true
                        actionLikeAlbum = false
                    }
                    
                    if actionUnlikeAlbum! {
                        album.albLike! -= 1
                        album.albIsLike = false
                        actionUnlikeAlbum = false
                    }
                    
                    if album.albIsLike! {
                        cell.btnLike.hidden = true
                        cell.btnUnLike.hidden = false
                    } else {
                        cell.btnLike.hidden = false
                        cell.btnUnLike.hidden = true
                    }
                    
                    cell.lblLikeCommentShare.text = "\(album.albLike!) Likes   \(album.albComment!) Comments   \(album.albShare!)   Shares"
                }
            }
            
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
            if let arrPhoto = arrPhoto {
                
                photo = arrPhoto[indexPath.row] as? Photo
                
                setContentViewToPhotoCell(cell: cell, indexPath: indexPath)
                
                cell.photo = photo
                
                
                if actionUnlikePhoto! {
                    photo?.ptLike! -= 1
                    photo?.ptIsLike = false
                    actionUnlikePhoto = false
                }
                
                if actionLikePhoto! {
                    photo?.ptLike! += 1
                    photo?.ptIsLike = true
                    actionLikePhoto = false
                }
                
                if photo?.ptIsLike == true {
                    cell.btnLike.hidden = true
                    cell.btnUnlike.hidden = false
                } else {
                    cell.btnLike.hidden = false
                    cell.btnUnlike.hidden = true
                }
                
                if let photo = photo {
                    cell.lblLikeCommentShare.text = "\(photo.ptLike!) Likes   \(photo.ptCmt!) Comments   \(photo.ptShare!)   Shares"
                }
            }
            
            cell.delegate = self
            cell.setupNavi(self.navigationController!)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if let arrPhoto = arrPhoto {
                if indexPath.row == (arrPhoto.count - 1) {
                    if pagePhoto < totalPage {
                        pagePhoto! += 1
                        CommonFunc.showIndicator(title: "", view: self.view)
                        loadMorePhoto(page: pagePhoto!)
                    }
                }
            }
            
            return cell
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
