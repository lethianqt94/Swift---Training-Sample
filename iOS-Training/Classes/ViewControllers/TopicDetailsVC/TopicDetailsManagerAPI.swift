//
//  TopicDetailsManagerAPI.swift
//  iOS-Training
//
//  Created by Le Thi An on 2/2/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import MBProgressHUD
import Alamofire

protocol TopicDetailsManagerAPIDelegate:NSObjectProtocol {
    
    func topicDetailsManagerAPIDelegate(sendTopicDataToVC topic:Topic) -> Void
    func topicDetailsManagerAPIDelegate(sendTopicFollowersDataToVC followersList:[Users]) -> Void
    func topicDetailsManagerAPIDelegate(sendTopicArticlesDataToVC articlesList:[Article]) -> Void
    func topicDetailsManagerAPIDelegate(sendTopicPhotosDataToVC photosList:[Photo]) -> Void
    func topicDetailsManagerAPIDelegate(sendTopicVideosDataToVC videosList:[Video]) -> Void
    func topicDetailsManagerAPIDelegate(sendTopicAlbumsDataToVC albumsList:[Album]) -> Void
    func topicDetailsManagerAPIDelegate(sendTopicLinksDataToVC linksList:[Link]) -> Void
    func topicDetailsManagerAPIDelegate(sendTopicContributorsDataToVC contributorsList:[Users]) -> Void
    func topicDetailsManagerAPIDelegate(sendProfileFeedDataToVC feedItems:[Feed], urlLoadMore:String) -> Void
}

class TopicDetailsManagerAPI {
    
    //MARK: Variables
    var indicatorView:MBProgressHUD!
    weak var delegate:TopicDetailsManagerAPIDelegate?
    
    //MARK: Functions
    
    func getTopicDetails(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let topicItem:TopicItem! = Mapper<TopicItem>().map(response.result.value!)
//                    print(response.result.value!)
                    if topicItem.item != nil {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicDataToVC: topicItem.item!)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
    }
    
    func getFollowerList(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "followers")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let followers:UserList! = Mapper<UserList>().map(response.result.value!)
                    if followers.items.count > 0 {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicFollowersDataToVC: followers.items)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }

    }
    
    func getArticlesList(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "articles")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let articles:ArticleList! = Mapper<ArticleList>().map(response.result.value!)
                    if articles.items.count > 0 {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicArticlesDataToVC: articles.items)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        
    }
    
    func getPhotosList(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "photos")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let photos:ListPhoto! = Mapper<ListPhoto>().map(response.result.value!)
                    if photos.listPhoto!.count > 0 {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicPhotosDataToVC: photos.listPhoto!)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        
    }
    
    func getVideosList(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "videos")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let videos:ItemVideo! = Mapper<ItemVideo>().map(response.result.value!)
                    if videos.items!.count > 0 {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicVideosDataToVC: videos.items!)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        
    }
    
    func getAlbumsList(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "albums")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let albums:AlbumList! = Mapper<AlbumList>().map(response.result.value!)
                    if albums.items.count > 0 {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicAlbumsDataToVC: albums.items)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        
    }
    
    func getLinksList(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "links")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let links:ItemLink! = Mapper<ItemLink>().map(response.result.value!)
                    if links.items!.count > 0 {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicLinksDataToVC: links.items!)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        
    }
    
    func getContributorsList(topicId:String) {
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = CommonFunc.getTopicDetailsAPI(topicId, tail: "contributors")
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let contributors:UserList! = Mapper<UserList>().map(response.result.value!)
                    if contributors.items.count > 0 {
                        self.delegate?.topicDetailsManagerAPIDelegate(sendTopicContributorsDataToVC: contributors.items)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        
    }
    
    func getNewFeedsList(nextUrl:String, userId:String!, linguistic_id: Int!, limit:Int!){
        Async.main{
            self.indicatorView?.show(true)
        }
        var url:String = ""
        if nextUrl.characters.count > 0 {
            url = nextUrl
        } else {
            url = CommonFunc.getAPITrending(linguistic_id, limit:limit )
        }
        print("url feed: \(url)")
        Alamofire.request(.GET, url, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            if response.result.isSuccess {
                Async.background{
                    let feedList:ListFeed! = Mapper<ListFeed>().map(response.result.value!)!
                    var listProfileFeed:[Feed]! = []
                    if feedList.listFeed?.count > 0 {
                        for feedObj in feedList.listFeed! {
                            listProfileFeed.append(feedObj)
                        }
                        if feedList.nextUrl?.characters.count > 0{
                            self.delegate?.topicDetailsManagerAPIDelegate(sendProfileFeedDataToVC: listProfileFeed, urlLoadMore:feedList.nextUrl!)
                        } else {
                            self.delegate?.topicDetailsManagerAPIDelegate(sendProfileFeedDataToVC: listProfileFeed, urlLoadMore:"")
                        }
                    } else {
                        listProfileFeed = []
                        if feedList.nextUrl?.characters.count > 0 {
                            self.delegate?.topicDetailsManagerAPIDelegate(sendProfileFeedDataToVC: listProfileFeed, urlLoadMore:"")
                        }
                    }
                }
            } else {
                print(response.result.error!)
            }
            Async.main {
                if self.indicatorView?.alpha == 1 {
                    self.indicatorView?.hide(true)
                }
            }
        }
    }
    
}