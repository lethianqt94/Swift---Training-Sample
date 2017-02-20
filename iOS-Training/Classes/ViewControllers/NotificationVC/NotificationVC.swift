//
//  NotificationVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD

class NotificationVC: ParentVC, UITableViewDelegate, UITableViewDataSource, NotificationDelegate {
    
    @IBOutlet var viewLoadMore: UIView!
    @IBOutlet var imvLoadMore: UIImageView!
    @IBOutlet var tbvNotification: UITableView!
    @IBOutlet var lblActivitiesUnread: UILabel!
    
    let notiCellIdentity = "NotificationCell"
    
    var unreadActi:Int = 0
    
    var listFeed:[Feed]! = []
    var nextUrl:String! = ""
    var canLoadMore:Bool! = true
    var isRefresh:Bool! = false
    
    var progress: MBProgressHUD? = nil
    
    var currentUser:Users!
    var userId:String!
    var userLinguisticId:Int!
    
    var notificationManagerAPI = NotificationVCManagerAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBarHidden = true
        
        addItemOnNaviBar(left: ParentVC.ItemType.None, center: ParentVC.ItemType.Title, right: ParentVC.ItemType.None)
        setTitleForVC("Notifications", fontText: Semibold20)
        
        self.tbvNotification.registerNib(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: notiCellIdentity)
        figureTableCellHeight()
        
        currentUser = AccountManager.sharedInstance.getInfoUser()
        userId = currentUser.id!
        userLinguisticId = currentUser.linguistic_id!
        
        print ("userId : \(userId), userLinguisticId: \(userLinguisticId)")
        
        progress = MBProgressHUD(view: self.view)
        self.view.addSubview(progress!)
        notificationManagerAPI.progress = self.progress
        
        notificationManagerAPI.notificationDelegate = self
        
        notificationManagerAPI.getNotificationList(nextUrl, userId: userId, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NOTIFICATION)
        notificationManagerAPI.getUnreadMessNum(userId, linguistic_id: userLinguisticId)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: UITableViewDataSource, UITableViewDelegate methods
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return listFeed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NotificationCell! = tableView.dequeueReusableCellWithIdentifier(notiCellIdentity) as? NotificationCell
        var noti:Feed?
        if listFeed.count > 0 {
            noti = listFeed![indexPath.row]
            cell.feed = noti
            cell.setContentToCell()
        } else {
            print("ko thay gi ca")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tbvNotification.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewLoadMore
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    //    MARK: Other support functions
    func figureTableCellHeight(){
        tbvNotification.rowHeight = UITableViewAutomaticDimension
        tbvNotification.estimatedRowHeight = 100
    }
    
    func getUnreadCount(countUnread:Int)->NSMutableAttributedString {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: "ACTIVITIES ", attributes: [NSFontAttributeName:Semibold13])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255, green: 87, blue: 34), range: NSMakeRange(0, info.length))
                
        let number: NSMutableAttributedString = NSMutableAttributedString(string: "(\(String(countUnread)))", attributes: [NSFontAttributeName:Regular13])
        number.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 114, green: 114, blue: 114), range: NSMakeRange(0, number.length))
        info.appendAttributedString(number)
        
        return info
    }
    
    
    //    MARK: NotificationDelegate methods
    func notificationDelegate(getData listFeedObj: [Feed], urlLoadMore: String) {
        if isRefresh == false {
            self.listFeed.removeAll(keepCapacity: false)
        }
        self.listFeed.appendContentsOf(listFeedObj)
        print("list feed count: \(listFeed.count)")
        self.nextUrl = urlLoadMore
        
        if self.nextUrl.characters.count > 0 {
            canLoadMore = true
        } else {
            canLoadMore = false
        }
        
        if listFeedObj.count > 0{
            Async.main {
                self.tbvNotification.reloadData()
                if self.viewLoadMore.alpha == 0 {
                    self.viewLoadMore.alpha = 1
                }
            }
        } else {
            
        }
        isRefresh = false
        
    }
    
    func notificationDelegate(getUnreadNotificationNum countUnread: Int) {
        Async.main{
            self.lblActivitiesUnread.attributedText = self.getUnreadCount(countUnread)
        }       
    }
    
    // MARK: - Actions
    @IBAction func doLoadMore(sender: AnyObject) {
        if canLoadMore == true {
            isRefresh = true
            print("LOAD MORE: \(nextUrl)")
            notificationManagerAPI.getNotificationList(nextUrl, userId: userId, linguistic_id: userLinguisticId, limit: LIMIT_PAGE_NOTIFICATION)
        } else {
            print("het roi...")
        }
        
    }
    
}
