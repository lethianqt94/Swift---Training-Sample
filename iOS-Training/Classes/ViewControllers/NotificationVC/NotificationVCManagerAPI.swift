//
//  NotificationVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


// MARK: HomeVCManagerAPIDelegate Protocol
protocol NotificationDelegate:NSObjectProtocol {
    func notificationDelegate(getData listFeedObj: [Feed], urlLoadMore:String) -> Void
    func notificationDelegate(getUnreadNotificationNum countUnread:Int) -> Void
}


class NotificationVCManagerAPI: NSObject {
     // MARK: - Variables
    var progress: MBProgressHUD!
    weak var notificationDelegate:NotificationDelegate!
    
    // MARK: - Methods
    
    func getNotificationList(urlLoadMore:String, userId:String!, linguistic_id: Int!, limit:Int!){
        Async.main{
            self.progress?.show(true)
        }
        var url:String! = ""
        if urlLoadMore.characters.count > 0 {
            url = urlLoadMore
        } else {
            url = CommonFunc.getNotificationAPI(userId, linguistic_id: linguistic_id, limit:limit)
        }
        print("url feed: \(url)")
        Alamofire.request(.GET, url, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                Async.background{
                    let feedList:ListFeed! = Mapper<ListFeed>().map(response.result.value!)!
                    var listNotification:[Feed]! = []
                    if feedList.listFeed?.count > 0 {
                        for feedObj in feedList.listFeed! {
                            listNotification.append(feedObj)
                        }
                        if feedList.nextUrl?.characters.count > 0 {
                            self.notificationDelegate.notificationDelegate(getData: listNotification, urlLoadMore: feedList.nextUrl!)
                        } else {
                           self.notificationDelegate.notificationDelegate(getData: listNotification, urlLoadMore: "")
                        }
                    } else {
                        listNotification = []
                        if feedList.nextUrl?.characters.count > 0 {
                            self.notificationDelegate.notificationDelegate(getData: listNotification, urlLoadMore: "")
                        }
                    }
                }
            } else {
                print(response.result.error!)
            }
            Async.main {
                if self.progress?.alpha == 1 {
                    self.progress?.hide(true)
                }
            }
        }
    }
    
    func getUnreadMessNum(userId:String!, linguistic_id: Int!){
        let url:String! = CommonFunc.getUnreadNotificationNum(userId, linguistic_id: linguistic_id)
        print("url feed: \(url)")
        Alamofire.request(.GET, url, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                Async.background{
                    let feedList:ListFeed! = Mapper<ListFeed>().map(response.result.value!)!
                    var countUnread:Int = 0
                    if feedList.countUnread != nil {
                        self.notificationDelegate.notificationDelegate(getUnreadNotificationNum: feedList.countUnread!)
                    } else {
                        countUnread = 0
                        self.notificationDelegate.notificationDelegate(getUnreadNotificationNum: countUnread)
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
    }
    
}