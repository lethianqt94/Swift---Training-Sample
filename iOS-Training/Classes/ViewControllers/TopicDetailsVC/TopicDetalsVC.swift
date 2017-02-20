//
//  TopicDetalsVC.swift
//  iOS-Training
//
//  Created by Le Thi An on 2/2/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD

let kImageKey = "image"
let kNameKey = "name"
let kTotalKey = "total"

class TopicDetalsVC: ParentVC, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TopicDetailsManagerAPIDelegate {
    
    // MARK: outlets + variables
    
    @IBOutlet var headerView: UIView!

    @IBOutlet weak var imvTopicAvatar: UIImageView!
    @IBOutlet weak var imvTopicUserAvatar: UIImageView!
    @IBOutlet weak var imvTopicCoverPhoto: UIImageView!
    
    @IBOutlet weak var lblFollowersNum: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblTopicName: UILabel!
    @IBOutlet weak var lblTopicCategories: UILabel!
    @IBOutlet weak var collectionViewResources: UICollectionView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var viewActionButtons: UIView!
    
    var topicId:String! = ""
    var topic:Topic!
    
    let triggerCellNib:String = "TriggerCell"
    let resourceCellNib:String = "TopicResourceCell"
    let headerViewIdentify:String = "HeaderView"
    
    var progress: MBProgressHUD? = nil
    
    var resourceArray:[[String:String]] = []
    
    var listFeed:[Feed] = []
    var isRefresh:Bool = false
    var canLoadMore:Bool = false
    var nextUrl:String = ""
    
    var userId:String!
    var userLinguisticId:Int!
    
    var apiManager:TopicDetailsManagerAPI?
    
    //MARK: init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "TopicDetalsVC", bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addItemOnNaviBar(left: ParentVC.ItemType.Back, center: ParentVC.ItemType.SearchBar, right: ParentVC.ItemType.Location)
        print("topic ID: \(topicId)")
        
        let currentUser:Users = AccountManager.sharedInstance.getInfoUser()
        userId = currentUser.id!
        userLinguisticId = currentUser.linguistic_id!
        
        tableView.registerNib(UINib(nibName: "TriggerCell", bundle: nil), forCellReuseIdentifier: triggerCellNib)
        collectionViewResources.registerNib(UINib(nibName: "TopicResourceCell", bundle: nil), forCellWithReuseIdentifier: resourceCellNib)
        
        progress = MBProgressHUD(view: self.view)
        self.view.addSubview(progress!)
        
        apiManager = TopicDetailsManagerAPI()
        apiManager?.indicatorView = progress
        apiManager?.delegate = self
        
        setupViewHeaderContent()
        setDataResourceTopic()
        
        apiManager?.getTopicDetails(topicId)
        apiManager?.getNewFeedsList(nextUrl, userId: userId, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NUMBER)
        callListResource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Setup Viewheader Content
    
    func setupViewHeaderContent() {
        imvTopicAvatar.layer.borderColor = UIColor.whiteColor().CGColor
        imvTopicAvatar.layer.borderWidth = 1
        imvTopicAvatar.layer.cornerRadius = 4
        imvTopicAvatar.clipsToBounds = true
        
        imvTopicUserAvatar.layer.borderColor = UIColor.whiteColor().CGColor
        imvTopicUserAvatar.layer.borderWidth = 1
        imvTopicUserAvatar.layer.cornerRadius = imvTopicUserAvatar.frame.width/2
        imvTopicUserAvatar.clipsToBounds = true
        
        let shadowLayer: CALayer = shadowView.layer
        shadowView.clipsToBounds = false
        shadowLayer.shadowColor = UIColor(red: 214, green: 214, blue: 214).CGColor
        shadowLayer.shadowOffset = CGSizeZero
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 3
        shadowLayer.shouldRasterize = true
        
        let actionButtonLayer: CALayer = viewActionButtons.layer
        actionButtonLayer.cornerRadius = 3
        viewActionButtons.clipsToBounds = true
        actionButtonLayer.borderColor = UIColor(red: 213, green: 213, blue: 213).CGColor
        actionButtonLayer.borderWidth = 1
    }
    
    func setupViewHeaderInfo() {
        lblTopicName.text = topic.tpTitle
        if topic.tpAvatar != nil && topic.tpAvatar != "" {
            let tpAvatarUrl = topic.getTopicAvatar()
            imvTopicAvatar.hnk_setImageFromURL(NSURL(string: tpAvatarUrl)!)
        } else {
            imvTopicAvatar.image = UIImage(named: "img_no_useravatar.png")
        }
        
        if topic.tpCoverImage != nil && topic.tpCoverImage != "" {
            let tpCoverPhotoUrl = topic.getTopicCoverPhoto()
            imvTopicCoverPhoto.hnk_setImageFromURL(NSURL(string: tpCoverPhotoUrl)!)
        } else {
            imvTopicCoverPhoto.image = UIImage(named: "img_no_coverphoto.png")
        }
        
        if topic.tpOwner?.avatar != nil && topic.tpOwner?.avatar != "" {
            let tpOwnerAvatarUrl = topic.tpOwner?.getUserAvatar()
            imvTopicUserAvatar.hnk_setImageFromURL(NSURL(string: tpOwnerAvatarUrl!)!)
        } else {
            imvTopicUserAvatar.image = UIImage(named: "img_no_useravatar.png")
        }
        
        lblFollowersNum.attributedText = createAttributeText(topic.tpFollowersNum!)
        
        lblTopicCategories.text = getZones(topic.tpTypes!)
    }
    
    func setDataResourceTopic(){
        
        resourceArray = []
        resourceArray.append([kImageKey:"", kNameKey:"Followers", kTotalKey:"0"])
        resourceArray.append([kImageKey:"",kNameKey:"Articles",kTotalKey:"0"])
        resourceArray.append([kImageKey:"",kNameKey:"Photos",kTotalKey:"0"])
        resourceArray.append([kImageKey:"",kNameKey:"Videos",kTotalKey:"0"])
        resourceArray.append([kImageKey:"",kNameKey:"Albums",kTotalKey:"0"])
        resourceArray.append([kImageKey:"",kNameKey:"Links",kTotalKey:"0"])
        resourceArray.append([kImageKey:"",kNameKey:"Contributors",kTotalKey:"0"])
    }
    
    func createAttributeText(followers:Int)->NSMutableAttributedString {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: String(followers), attributes: [NSFontAttributeName:Semibold13])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255, green: 87, blue: 34), range: NSMakeRange(0, info.length))
        var str:String! = ""
        if followers > 1 {
            str = "Followers"
        } else {
            str = "Follower"
        }
        let followers:NSMutableAttributedString = NSMutableAttributedString(string: " \(str)", attributes: [NSFontAttributeName:Regular13])
        followers.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 33, green: 33, blue: 33), range: NSMakeRange(0, followers.length))
        info.appendAttributedString(followers)

        return info
    }
    
    func getZones(items:[Type])->String {
        var categories:String = ""
        for item in items {
            categories.appendContentsOf("#\(item.typeName!) ")
        }
        return categories
    }
    
    func callListResource() {
        let serialQueue = dispatch_queue_create("serialLoadResources", DISPATCH_QUEUE_SERIAL)
        dispatch_async(serialQueue) { () -> Void in
            self.apiManager?.getFollowerList(self.topicId)
        }
        dispatch_async(serialQueue) { () -> Void in
            self.apiManager?.getArticlesList(self.topicId)
        }
        dispatch_async(serialQueue) { () -> Void in
            self.apiManager?.getPhotosList(self.topicId)
        }
        dispatch_async(serialQueue) { () -> Void in
            self.apiManager?.getVideosList(self.topicId)
        }
        dispatch_async(serialQueue) { () -> Void in
            self.apiManager?.getAlbumsList(self.topicId)
        }
        dispatch_async(serialQueue) { () -> Void in
            self.apiManager?.getLinksList(self.topicId)
        }
        dispatch_async(serialQueue) { () -> Void in
            self.apiManager?.getContributorsList(self.topicId)
        }
    }
    
    func updateResourceListWithItem(item: [String:String]){
        for (var i = 0; i < resourceArray.count; i++) {
            var tmp = resourceArray[i]
            if tmp[kNameKey] == item[kNameKey] {
                resourceArray[i][kTotalKey] = item[kTotalKey]
                resourceArray[i][kImageKey] = item[kImageKey]
                
                return
            }
        }
    }
    
    //MARK: TopicDetailsManagerAPIDelegate
    
    func topicDetailsManagerAPIDelegate(sendTopicDataToVC topic: Topic) {
        self.topic = topic
        Async.main {
            self.setupViewHeaderInfo()
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendTopicFollowersDataToVC followersList: [Users]) {
        if followersList.count > 0 {
            var item:[String:String]
            let num:String = String(followersList.count)
            let imgUrl:String = followersList[0].getUserAvatar()
            item = [kImageKey:imgUrl, kNameKey:"Followers", kTotalKey:num]
            updateResourceListWithItem(item)
            Async.main {
                self.collectionViewResources.reloadData()
            }
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendTopicArticlesDataToVC articlesList: [Article]) {
        if articlesList.count > 0 {
            var item:[String:String]
            let num:String = String(articlesList.count)
            let imgUrl:String = (articlesList[0].artPhoto?.getPhotoUrl())!
            item = [kImageKey:imgUrl, kNameKey:"Articles", kTotalKey:num]
            updateResourceListWithItem(item)
            Async.main {
                self.collectionViewResources.reloadData()
            }
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendTopicAlbumsDataToVC albumsList: [Album]) {
        if albumsList.count > 0 {
            var item:[String:String]
            let num:String = String(albumsList.count)
            var imgUrl:String = ""
            if albumsList[0].albPhotos?.count > 0 {
                imgUrl = albumsList[0].albPhotos![0].getPhotoUrl()
            }
            item = [kImageKey:imgUrl, kNameKey:"Albums", kTotalKey:num]
            updateResourceListWithItem(item)
            Async.main {
                self.collectionViewResources.reloadData()
            }
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendTopicLinksDataToVC linksList: [Link]) {
        if linksList.count > 0 {
            var item:[String:String]
            let num:String = String(linksList.count)
            let imgUrl:String = (linksList[0].lnkWebImg)!
            item = [kImageKey:imgUrl, kNameKey:"Links", kTotalKey:num]
            updateResourceListWithItem(item)
            Async.main {
                self.collectionViewResources.reloadData()
            }
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendTopicPhotosDataToVC photosList: [Photo]) {
        if photosList.count > 0 {
            var item:[String:String]
            let num:String = String(photosList.count)
            let imgUrl:String = (photosList[0].getPhotoUrl())
            item = [kImageKey:imgUrl, kNameKey:"Photos", kTotalKey:num]
            updateResourceListWithItem(item)
            Async.main {
                self.collectionViewResources.reloadData()
            }
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendTopicVideosDataToVC videosList: [Video]) {
        if videosList.count > 0 {
            var item:[String:String]
            let num:String = String(videosList.count)
            let imgUrl:String = (videosList[0].getVideoThumnail())
            item = [kImageKey:imgUrl, kNameKey:"Videos", kTotalKey:num]
            updateResourceListWithItem(item)
            Async.main {
                self.collectionViewResources.reloadData()
            }
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendTopicContributorsDataToVC contributorsList: [Users]) {
        if contributorsList.count > 0 {
            var item:[String:String]
            let num:String = String(contributorsList.count)
            let imgUrl:String = (contributorsList[0].getUserAvatar())
            item = [kImageKey:imgUrl, kNameKey:"Contributors", kTotalKey:num]
            updateResourceListWithItem(item)
            Async.main {
                self.collectionViewResources.reloadData()
            }
        }
    }
    
    func topicDetailsManagerAPIDelegate(sendProfileFeedDataToVC feedItems:[Feed], urlLoadMore:String) {
        if isRefresh == false {
            self.listFeed.removeAll(keepCapacity: false)
        }
        self.listFeed.appendContentsOf(feedItems)
        self.nextUrl = urlLoadMore
        
        if self.nextUrl.characters.count > 0 {
            canLoadMore = true
        } else {
            canLoadMore = false
        }
        
        var indexPaths:[NSIndexPath] = []
        
        for i in 1...self.listFeed.count {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            indexPaths.append(indexPath)
        }
        
        if feedItems.count > 0{
            Async.main {
//                self.tableView.beginUpdates()
//                self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
//                self.tableView.endUpdates()
                self.tableView.reloadData()
            }
        }
        isRefresh = false
    }
    
    //MARK: UITableViewDataSource + UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFeed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TriggerCell! = tableView.dequeueReusableCellWithIdentifier(triggerCellNib) as? TriggerCell
        var feed:Feed?
        if listFeed.count > 0 {
            feed = listFeed[indexPath.row]
//            cell.feedObj = feed
            cell.setContentToTriggerCell(feed!)
            cell.setupNavi(self.navigationController!)
        }
        if indexPath.row == self.listFeed.count - 1 && canLoadMore == true {
            apiManager?.getNewFeedsList(self.nextUrl, userId: userId, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NUMBER)
            isRefresh = true
        } else {
            print("het roi...")
        }
        return cell
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 498
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: UICollectionViewDataSource + UICollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourceArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionViewResources.dequeueReusableCellWithReuseIdentifier(resourceCellNib, forIndexPath: indexPath) as! TopicResourceCell
        cell.setContentWithDic(resourceArray[indexPath.row])
        return cell
    }
    
}
