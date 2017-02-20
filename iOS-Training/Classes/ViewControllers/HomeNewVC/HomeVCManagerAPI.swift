//
//  HomeVCManagerAPI.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD

// MARK: HomeVCManagerAPIDelegate Protocol

protocol HomeVCManagerAPIDelegate:NSObjectProtocol {
    func homeVCManagerAPIDelegate(sendFeedDataToHomeVC listFeedObj: [Feed], urlLoadMore:String) -> Void
    func homeVCManagerAPIDelegate(sendTredingDataToHomeVC listFeedObj: [Feed], urlLoadMore:String) -> Void
}

class HomeVCManagerAPI:NSObject {
    
    // MARK: - Variables
    weak var homeVCManagerAPIDelegate:HomeVCManagerAPIDelegate!
    var progress: MBProgressHUD!
    
    // MARK: - Methods
    
    func getNewFeedsList(userId:String!, linguistic_id: Int!, limit:Int!){
        Async.main{
            self.progress?.show(true)
        }
        let url:String! = CommonFunc.getAPIFeed(userId, linguistic_id: linguistic_id, limit:limit )
        print("url feed: \(url)")
        Alamofire.request(.GET, url, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                Async.background{
                    let feedList:ListFeed! = Mapper<ListFeed>().map(response.result.value!)!
                    var listHomeFeed:[Feed]! = []
                    if feedList.listFeed?.count > 0 {
                        for feedObj in feedList.listFeed! {
                            listHomeFeed.append(feedObj)
                        }
                        if feedList.nextUrl?.characters.count > 0{

                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendFeedDataToHomeVC: listHomeFeed, urlLoadMore: feedList.nextUrl!)
                        } else {

                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendFeedDataToHomeVC: listHomeFeed, urlLoadMore: "")
                        }
                    } else {
                        listHomeFeed = []
                        if feedList.nextUrl?.characters.count > 0 {

                        self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendFeedDataToHomeVC: listHomeFeed, urlLoadMore: "")
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
    
    func getNewFeedsListNew (urlLoadMore:String, userId:String!, linguistic_id: Int!, limit:Int!) {
        Async.main{
            self.progress?.show(true)
        }
        Alamofire.request(.GET, urlLoadMore, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                Async.background{
                    let feedList:ListFeed! = Mapper<ListFeed>().map(response.result.value!)!
                    var listHomeFeed:[Feed]! = []
                    if feedList.listFeed?.count > 0 {
                        for feedObj in feedList.listFeed! {
                            listHomeFeed.append(feedObj)
                        }
                        if feedList.nextUrl?.characters.count > 0{
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendFeedDataToHomeVC: listHomeFeed, urlLoadMore: feedList.nextUrl!)
                        } else {

                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendFeedDataToHomeVC: listHomeFeed, urlLoadMore: "")
                        }
                    } else {
                        listHomeFeed = []
                        if feedList.nextUrl?.characters.count > 0 {
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendFeedDataToHomeVC: listHomeFeed, urlLoadMore: "")
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
    
    func getTrendingList(linguistic_id: Int!, limit:Int!) {
        Async.main{
            self.progress?.show(true)
        }
        let url:String! = CommonFunc.getAPITrending(linguistic_id, limit:limit )
        print("url trending: \(url)")
        Alamofire.request(.GET, url, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                Async.background{
                    let feedList:ListFeed! = Mapper<ListFeed>().map(response.result.value!)!
                    var listTredingFeed:[Feed]! = []
//                    if feedList.listFeed!.count > 0 {
                    if let _ = feedList.listFeed {
                        for feedObj in feedList.listFeed! {
                            listTredingFeed.append(feedObj)
                        }
                        if feedList.nextUrl!.characters.count > 0 {
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendTredingDataToHomeVC: listTredingFeed, urlLoadMore: feedList.nextUrl!)
                        } else {
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendTredingDataToHomeVC: listTredingFeed, urlLoadMore: "")
                        }
                        
                    } else {
                        listTredingFeed = []
                        if feedList.nextUrl!.characters.count > 0 {
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendTredingDataToHomeVC: listTredingFeed, urlLoadMore: feedList.nextUrl!)
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
    
    func getTrendingListNew(urlLoadTrendingLoadMore:String,linguistic_id: Int!, limit:Int!) {
        Async.main{
            self.progress?.show(true)
        }
        Alamofire.request(.GET, urlLoadTrendingLoadMore, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                Async.background{
                    let feedList:ListFeed! = Mapper<ListFeed>().map(response.result.value!)!
                    var listTredingFeed:[Feed]! = []
                    if feedList.listFeed!.count > 0 {
                        for feedObj in feedList.listFeed! {
                            listTredingFeed.append(feedObj)
                        }
                        if feedList.nextUrl!.characters.count > 0 {
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendTredingDataToHomeVC: listTredingFeed, urlLoadMore: feedList.nextUrl!)
                        } else {
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendTredingDataToHomeVC: listTredingFeed, urlLoadMore: "")
                        }
                    } else {
                        listTredingFeed = []
                        if feedList.nextUrl!.characters.count > 0 {
                            self.homeVCManagerAPIDelegate.homeVCManagerAPIDelegate(sendTredingDataToHomeVC: listTredingFeed, urlLoadMore: "")
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
    
}