//
//  HomeNewVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeNewVC: ParentVC, HomeVCManagerAPIDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: outlets + variables
    
    @IBOutlet var tbvHome: UITableView!
    @IBOutlet var btnNewFeeds: UIButton!
    @IBOutlet var btnTrending: UIButton!
    
    @IBOutlet var noResultMess: UIView!
    
    
    let triggerCell:String = "TriggerCell"
    
    var listFeed:[Feed]! = []
    var nextUrl:String! = ""
    var canLoadMore:Bool! = true
    var isRefresh:Bool! = false
    
    var isTrending:Bool! = false
    
    var listTreding:[Feed]! = []
    var nextTrendingUrl:String! = ""
    
    var progress: MBProgressHUD? = nil
    
    var homeVCManagerAPI:HomeVCManagerAPI!
    
    var currentUser:Users!
    var userId:String!
    var userLinguisticId:Int!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addItemOnNaviBar(left: ParentVC.ItemType.None, center: ParentVC.ItemType.SearchBar, right: ParentVC.ItemType.Location)
        self.tbvHome.registerNib(UINib(nibName: "TriggerCell", bundle: nil), forCellReuseIdentifier: triggerCell)
        homeVCManagerAPI = HomeVCManagerAPI()
        homeVCManagerAPI.homeVCManagerAPIDelegate = self
        
        progress = MBProgressHUD(view: self.view)
        self.view.addSubview(progress!)
        homeVCManagerAPI.progress = self.progress
        
        currentUser = AccountManager.sharedInstance.getInfoUser()
        userId = currentUser.id!
        userLinguisticId = currentUser.linguistic_id!
        
        print ("userId : \(userId), userLinguisticId: \(userLinguisticId)")
        
//        viewSearch.layer.cornerRadius = 4
//        viewSearch.layer.masksToBounds = true
        initView()
        figureTableCellHeight()
        tbvHome.contentInset.top = 10
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tbvHome.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //  MARK: UITableViewDataSource, UITableViewDelegate methods
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if isTrending == true {
            return listTreding.count
        } else {
            return listFeed.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TriggerCell! = tableView.dequeueReusableCellWithIdentifier(triggerCell) as? TriggerCell
        var feed:Feed?
        if isTrending == true {
            if listTreding.count > 0 {
                feed = listTreding![indexPath.row]
//                cell.feedObj = feed
                cell.setContentToTriggerCell(feed!)
                cell.setupNavi(self.navigationController!)
            }
        } else {
            if listFeed.count > 0 {
                feed = listFeed![indexPath.row]
//                cell.feedObj = feed
                cell.setContentToTriggerCell(feed!)
                cell.setupNavi(self.navigationController!)
            }
        }
        print("index path: \(indexPath.row)")
        if isTrending == true {
            if indexPath.row == self.listTreding.count - 1 && canLoadMore == true {
                homeVCManagerAPI.getTrendingListNew(self.nextTrendingUrl, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NUMBER)
                isRefresh = true
            } else {
                print("het roi...")
            }
        } else {
            if indexPath.row == self.listFeed.count - 1 && canLoadMore == true {
                homeVCManagerAPI.getNewFeedsListNew(self.nextUrl, userId: userId, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NUMBER)
                isRefresh = true
            } else {
                print("het roi...")
            }
        }
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tbvHome.deselectRowAtIndexPath(indexPath, animated: true)
//    }
    //    MARK: Navigation
    
    func initView() -> Void {
//        self.navigationController?.navigationBarHidden = true
        homeVCManagerAPI.getNewFeedsList(userId, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NUMBER)
        
    }
    
    //    MARK: HomeVCManagerAPIDelegate methods
    
    func homeVCManagerAPIDelegate(sendFeedDataToHomeVC listFeedObj: [Feed], urlLoadMore: String) {

        if isRefresh == false {
            self.listFeed.removeAll(keepCapacity: false)
        }
        self.listFeed.appendContentsOf(listFeedObj)
        self.nextUrl = urlLoadMore
        
        if self.nextUrl.characters.count > 0 {
            canLoadMore = true
        } else {
            canLoadMore = false
        }
        
        self.isTrending = false
        
        if listFeedObj.count > 0{
            Async.main {
                self.tbvHome.reloadData()
            }
            self.noResultMess.alpha = 0
        } else {
            self.noResultMess.alpha = 1
            self.view.bringSubviewToFront(self.noResultMess)
        }
        isRefresh = false
    }
    
    func homeVCManagerAPIDelegate(sendTredingDataToHomeVC listFeedObj: [Feed], urlLoadMore: String) {
       
        if isRefresh == false {
            self.listTreding.removeAll(keepCapacity: false)
        }
        
        self.listTreding.appendContentsOf(listFeedObj)
        self.nextTrendingUrl = urlLoadMore
        
        if self.nextTrendingUrl.characters.count > 0 {
            canLoadMore = true
        } else {
            canLoadMore = false
        }
        
        self.isTrending = true
        
        if listFeedObj.count > 0{
            Async.main {
                self.tbvHome.reloadData()
            }
            self.noResultMess.alpha = 0
        } else {
            self.noResultMess.alpha = 1
            self.view.bringSubviewToFront(self.noResultMess)
        }
        isRefresh = false
        
    }
    
     //    MARK: Other support functions
    func figureTableCellHeight(){
        tbvHome.rowHeight = UITableViewAutomaticDimension
        tbvHome.estimatedRowHeight = 100
    }
    
    //    MARK: Actions
    
    @IBAction func goToNewFeeds(sender: AnyObject) {
        isRefresh = false
        homeVCManagerAPI.getNewFeedsList(userId, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NUMBER)
        self.btnTrending.setTitleColor(UIColor(red: 114, green: 114, blue: 114), forState: UIControlState.Normal)
        self.btnNewFeeds.setTitleColor(UIColor(red: 255, green: 87, blue: 34), forState: UIControlState.Normal)
    }
    
    @IBAction func goToTrending(sender: AnyObject) {
        isRefresh = false
        homeVCManagerAPI.getTrendingList(userLinguisticId, limit: LIMIT_PAGE_NUMBER)
        self.btnNewFeeds.setTitleColor(UIColor(red: 114, green: 114, blue: 114), forState: UIControlState.Normal)
        self.btnTrending.setTitleColor(UIColor(red: 255, green: 87, blue: 34), forState: UIControlState.Normal)
    }
    
}

