//
//  ProfileVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/21/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ProfileVC: ParentVC, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileVCDelegate, ProfileTopCellDelegate {
    
    // MARK: - Variable
    
    var screenWidth: CGFloat?
    var user: Users?
    var arrListFeeds = NSMutableArray()
    var arrStatUser = NSMutableArray()
    var urlLoadMore: String?
    
    var pickerAvatar = UIImagePickerController()
    var pickerCover = UIImagePickerController()
    var imgAvatar: UIImage?
    var imgCover: UIImage?
    var dicCollectionProfile: NSMutableDictionary?
    
    let dateFormatter = NSDateFormatter()
    
    var profileFlow: ProfileVCManageFlow?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addItemOnNaviBar(left: ParentVC.ItemType.Back, center: ParentVC.ItemType.SearchBar, right: ParentVC.ItemType.Location)
        
        pickerAvatar.delegate = self
        pickerCover.delegate = self
        
        profileFlow = ProfileVCManageFlow(navi: self.navigationController)
        
        let nibCellTopProfile = UINib.init(nibName: "ProfileTopCell", bundle: nil)
        tableView.registerNib(nibCellTopProfile, forCellReuseIdentifier: "ProfileTopCell")
        
        let nibCellButton = UINib.init(nibName: "ButtonCell", bundle: nil)
        tableView.registerNib(nibCellButton, forCellReuseIdentifier: "ButtonCell")
        
        let nibCellTrigger = UINib(nibName: "TriggerCell", bundle: nil)
        tableView.registerNib(nibCellTrigger, forCellReuseIdentifier: "TriggerCell")
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        
        figureTableCellHeight()
        
        user = AccountManager.sharedInstance.getInfoUser()
        
        let profileAPI = ProfileVCManageAPI()
        if let user = user {
            CommonFunc.showIndicator(title: "", view: self.view)
            profileAPI.delegate = self
            profileAPI.requestFeedUser(userId: user.id!, linguisticId: user.linguistic_id!)
            profileAPI.requestFollowing(accessToken: user.accessToken!)
            profileAPI.requestFriend(accessToken: user.accessToken!)
            profileAPI.requestPhoto(accessToken: user.accessToken!)
            profileAPI.requestTopic(accessToken: user.accessToken!)
            profileAPI.requestLink(accessToken: user.accessToken!)
            profileAPI.requestCollection(accessToken: user.accessToken!)
        }
        
        dicCollectionProfile = NSMutableDictionary()
        
        getStatUser()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Override Methods
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    
    // MARK: - Custom Methods
    
    func getStatUser() {
        if let user = user {
            arrStatUser.addObject(user.topics!)
            arrStatUser.addObject(user.followings!)
            arrStatUser.addObject(user.friends!)
            arrStatUser.addObject(user.collections!)
            arrStatUser.addObject(user.articles!)
            arrStatUser.addObject(user.photos!)
            arrStatUser.addObject(user.links!)
            arrStatUser.addObject(user.videos!)
        }
    }
    
    func figureTableCellHeight(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    // MARK: - ProfileTopCell Delegate Methods
    
    func profileTopCellAddAvatar(event event: Bool) {
        if event {
            CommonFunc.addActionSheet(viewController: self, picker: pickerAvatar)
        }
    }
    
    func profileTopCellAddCover(event event: Bool) {
        if event {
            CommonFunc.addActionSheet(viewController: self, picker: pickerCover)
        }
    }
    
    func profileTopCellToCreditVC(event event: Bool) {
        if event {
            if let profileFlow = profileFlow {
                profileFlow.pushToProfileCreditVC()
            }
        }
    }
    
    // MARK: - ProfileVC Delegate Methods
    
    func profileDelegateUserCollection(collection collection: Collections) {
        for object in collection.items! {
            if object.cover != "" {
                if let cover = object.cover {
                    dicCollectionProfile?.setObject(CommonFunc.getImgFromAvatar(cover), forKey: "Collection")
                    tableView.reloadData()
                    break
                }
            }
        }
    }
    
    func profileDelegateUserLink(link link: ItemLink) {
        for object in link.items! {
            if object.lnkWebImg != "" {
                if let linkWeb = object.lnkWebImg {
                    dicCollectionProfile?.setObject(linkWeb, forKey: "Link")
                    tableView.reloadData()
                    break
                }
            }
        }
    }
    
    func profileDelegateUserVideo(video video: ItemVideo) {
        for object in video.items! {
            if object.vidThumb != "" {
//                dicCollectionProfile?.setObject(Video.getVideoThumnail(<#T##Video#>), forKey: "Topic")
                tableView.reloadData()
                break
            }
        }
    }
    
    func profileDelegateUserTopic(topic topic: UsersTopic) {
        for object in topic.items! {
            if object.cover != "" {
                if let cover = object.cover {
                    dicCollectionProfile?.setObject(CommonFunc.getImgFromAvatar(cover), forKey: "Topic")
                    tableView.reloadData()
                    break
                }
            }
        }
    }
    
    func profileDelegateUserPhoto(photo photo: ListPhoto) {
        for object in photo.listPhoto! {
            if object.ptImage != "" {
                if let image = object.ptImage {
                    dicCollectionProfile?.setObject(CommonFunc.getImgFromAvatar(image), forKey: "Photo")
                    tableView.reloadData()
                    break
                }
            }
        }
    }
    
    func profileDelegateUserFriend(friend friend: Friends) {
        for object in friend.items! {
            if object.avatar != "" {
                if let avatar = object.avatar {
                    dicCollectionProfile?.setObject(CommonFunc.getImgFromAvatar(avatar), forKey: "Friend")
                    tableView.reloadData()
                    break
                }
            }
        }
    }
    
    func profileDelegateUserFeed(feed feed: ListFeed) {
        CommonFunc.hideIndicator(self.view)
        urlLoadMore = feed.nextUrl
        if let arrFeed = feed.listFeed {
            for object in arrFeed {
                arrListFeeds.addObject(object)
            }
            tableView.reloadData()
        }
    }
    
    func profileDelegateUserFeedMore(feed feed: ListFeed) {
        CommonFunc.hideIndicator(self.view)
        urlLoadMore = feed.nextUrl
        if let arrFeed = feed.listFeed {
            for object in arrFeed {
                arrListFeeds.addObject(object)
            }
            tableView.reloadData()
        }
    }
    
    func profileDelegateUserFollowing(userFollowing userFollowing: Following) {
        for object in userFollowing.items! {
            if object.cover != "" {
                if let cover = object.cover {
                    dicCollectionProfile?.setObject(CommonFunc.getImgFromAvatar(cover), forKey: "Following")
                    tableView.reloadData()
                    break
                }
            }
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate Method
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if picker == pickerAvatar {
            let chooseImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            imgAvatar = chooseImage
            tableView.reloadData()
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            let chooseImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            imgCover = chooseImage
            tableView.reloadData()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        while (section <= 1) {
            return 1
        }
        return arrListFeeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTopCell", forIndexPath: indexPath) as! ProfileTopCell
            if let imgAvatar = imgAvatar {
                cell.imgAvatar.image = imgAvatar
            }
            
            if let imgCover = imgCover {
                cell.imgCover.image = imgCover
            }
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! ButtonCell
            if let user = user {
                cell.stringTitleCollection = String(user.followings!)
                if let dicCollectionProfile = dicCollectionProfile {
                    cell.dicCollection = NSMutableDictionary.init(dictionary: dicCollectionProfile)
                    cell.collectionView.reloadData()
                }
                cell.user = user
            }
            cell.arrStat = arrStatUser
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TriggerCell", forIndexPath: indexPath) as! TriggerCell
            var feed:Feed?
            if arrListFeeds.count > 0 {
                feed = arrListFeeds[indexPath.row] as? Feed
//                cell.feedObj = feed
                cell.setContentToTriggerCell(feed!)
                if (indexPath.row == arrListFeeds.count - 1) && (feed != nil) {
                    CommonFunc.showIndicator(title: "", view: self.view)
                    let profileAPI = ProfileVCManageAPI()
                    if let urlLoadMore = urlLoadMore {
                        profileAPI.delegate = self
                        profileAPI.requestMoreFeedUser(urlString: urlLoadMore)
                    }
                }
            }
            if let navigationController = navigationController {
                cell.setupNavi(navigationController)
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 231
        } else if indexPath.section == 1 {
            return 127
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        while (section > 0) {
            let view = UIView()
            view.backgroundColor = UIColor(red: 232, green: 232, blue: 232)
            return view
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        while (section > 0) {
            return 8
        }
        return 0
    }
    
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
