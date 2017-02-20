//
//  ProfileVCManageAPI.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/22/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire

protocol ProfileVCDelegate: NSObjectProtocol {
    func profileDelegateUserFeed(feed feed: ListFeed)
    func profileDelegateUserFeedMore(feed feed: ListFeed)
    func profileDelegateUserFollowing(userFollowing userFollowing: Following)
    func profileDelegateUserFriend(friend friend: Friends)
    func profileDelegateUserPhoto(photo photo: ListPhoto)
    func profileDelegateUserTopic(topic topic: UsersTopic)
    func profileDelegateUserVideo(video video: ItemVideo)
    func profileDelegateUserLink(link link: ItemLink)
    func profileDelegateUserCollection(collection collection: Collections)
}

class ProfileVCManageAPI: NSObject {
    
    // MARK: - Variable
    
    weak var delegate: ProfileVCDelegate?
    
    // MARK: - Custom Methods
    
    func requestFeedUser(userId userId: String, linguisticId: Int) {
        let urlString = CommonFunc.getAPIProfileUser(userId, linguistic_id: linguisticId, limit: LIMIT_PAGE_NUMBER)
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                if let json = response.result.value {
                    if let feed = Mapper<ListFeed>().map(json) {
                        self.delegate?.profileDelegateUserFeed(feed: feed)
                    }
                }
        }
    }
    
    func requestMoreFeedUser(urlString urlString: String) {
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                if let json = response.result.value {
                    if let feed = Mapper<ListFeed>().map(json) {
                        self.delegate?.profileDelegateUserFeedMore(feed: feed)
                    }
                }
        }
    }
    
    func requestFollowing(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_FOLLOWING_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let usersFollowing = Mapper<Following>().map(json) {
                        self.delegate?.profileDelegateUserFollowing(userFollowing: usersFollowing)
                    }
                }
        }
    }
    
    func requestFriend(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_FRIEND_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let friend = Mapper<Friends>().map(json) {
                        self.delegate?.profileDelegateUserFriend(friend: friend)
                    }
                }
        }
    }
    
    func requestPhoto(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_PHOTO_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let photo = Mapper<ListPhoto>().map(json) {
                        self.delegate?.profileDelegateUserPhoto(photo: photo)
                    }
                }
        }
    }
    
    func requestTopic(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_TOPIC_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let topic = Mapper<UsersTopic>().map(json) {
                        self.delegate?.profileDelegateUserTopic(topic: topic)
                    }
                }
        }
    }
    
    func requestVideo(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_VIDEO_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let video = Mapper<ItemVideo>().map(json) {
                        self.delegate?.profileDelegateUserVideo(video: video)
                    }
                }
        }
    }
    
    func requestLink(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_LINK_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let link = Mapper<ItemLink>().map(json) {
                        self.delegate?.profileDelegateUserLink(link: link)
                    }
                }
        }
    }
    
    func requestCollection(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_COLLECTION_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let collection = Mapper<Collections>().map(json) {
                        self.delegate?.profileDelegateUserCollection(collection: collection)
                    }
                }
        }
    }
}
