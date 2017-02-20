//
//  Users.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class Users: Mappable {
    
    // MARK: - Variables
    
    var message: String?
    var code: Int?
    var id: String?
    var displayName: String?
    var userName: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var avatar: String?
    var cover: String?
    var location: String?
    var latitude: Double?
    var longitude: Double?
    var birthday: String?
    var profession: String?
    var born: String?
    var biography: String?
    var religion: String?
    var linguistic_id: Int?
    var credit: Int?
    var isAdmin: Bool?
    var followings: Int?
    var topics: Int?
    var articles: Int?
    var photos: Int?
    var videos: Int?
    var links: Int?
    var friends: Int?
    var collections: Int?
    var isMobile: Int?
    var ip: String?
    var subscribeMail: Bool?
    var pushNotifications: Bool?
    var accessToken: String?
    
    var usrAlbums:Int?
    var usrSubEmailNum: Int?
    var usrNotification:Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        message <- map["meta.message"]
        code <- map["meta.code"]
        id <- map["data.user.id"]
        displayName <- map["data.user.displayname"]
        userName <- map["data.user.username"]
        firstName <- map["data.user.firstname"]
        lastName <- map["data.user.lastname"]
        email <- map["data.user.email"]
        avatar <- map["data.user.avatar"]
        cover <- map["data.user.cover"]
        location <- map["data.user.location"]
        latitude <- map["data.user.latitude"]
        longitude <- map["data.user.longitude"]
        birthday <- map["data.user.birthday"]
        profession <- map["data.user.profession"]
        born <- map["data.user.born"]
        biography <- map["data.user.biography"]
        religion <- map["data.user.religion"]
        linguistic_id <- map["data.user.linguistic_id"]
        credit <- map["data.user.credit"]
        isAdmin <- map["data.user.is_admin"]
        followings <- map["data.user.stats.followings"]
        topics <- map["data.user.stats.topics"]
        articles <- map["data.user.stats.articles"]
        photos <- map["data.user.stats.photos"]
        videos <- map["data.user.stats.videos"]
        links <- map["data.user.stats.links"]
        friends <- map["data.user.stats.friends"]
        collections <- map["data.user.stats.collections"]
        isMobile <- map["data.user.is_mobile"]
        ip <- map["data.user.ip"]
        subscribeMail <- map["data.user.subscribe_mail"]
        pushNotifications <- map["data.user.push_notifications"]
        accessToken <- map["data.access_token"]
        
        //get from Feed
        id <- map["id"]
        
        userName <- map["username"]
        
        firstName <- map["firstname"]
        
        lastName <- map["lastname"]
        
        displayName <- map["displayname"]
        
        email <- map["email"]
        
        location <- map["location"]
        
        latitude <- map["latitude"]
        
        longitude <- map["longitude"]
        
        avatar <- map["avatar"]
        
        cover <- map["cover.image"]
        
        birthday <- map["birthday"]
        
        linguistic_id <- map["linguistic_id"]
        
        credit <- map["credit"]
        
        email <- map["subscribe_mail"]
        
        isAdmin <- map["is_admin"]
        
        followings <- map["stats.followings"]
        
        topics <- map["stats.topics"]
        
        articles <- map["stats.articles"]
        
        photos <- map["stats.photos"]
        
        videos <- map["stats.videos"]
        
        links <- map["stats.links"]
        
        usrAlbums <- map["stats.albums"]
        
        usrSubEmailNum <- map["subscribe_mail"]
        
        usrNotification <- map["push_notifications"]
        
    }
    
    internal func getUserAvatar()->String {
        let usrAvatarUrl = CommonFunc.getImgFromAvatar(avatar!)
        return usrAvatarUrl
    }
}

class UserList: Mappable {
    
    var items:[Users] = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
    }
}
