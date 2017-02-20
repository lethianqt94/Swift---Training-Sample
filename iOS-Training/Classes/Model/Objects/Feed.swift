//
//  Trigger.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Feed:Mappable{
    
    var feedId:String! = ""
    var feedLat:Double?
    var feedLong:Double?
    var feedCreate:String! = ""
    var feedIsRead:Bool? = false
    
    var feedTrigger:FeedTrigger? = FeedTrigger()
    var feedAction:FeedAction? = FeedAction()
    var feedObject:FeedObject! = FeedObject()
    var feedReceiver:FeedReceiver? = FeedReceiver()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        feedId <- map["id"]
        feedLat <- map["latitude"]
        feedLong <- map["longitude"]
        feedCreate <- map["created"]
        feedIsRead <- map["is_read"]
        
        feedTrigger <- map["trigger"]
        feedAction <- map["action"]
        feedObject <- map["object"]
        feedReceiver <- map["receiver"]
    }
    
}

class FeedTrigger:Mappable {
    var triggerType:String! = "user"
    var triggerUser:Users! = Users()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        triggerType <- map["type"]
        triggerUser <- map["user"]
    }
}

class FeedAction:Mappable {
    var actionType:String?
    var actionCmt:Comment?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        actionType <- map["type"]
        actionCmt <- map["comment"]
    }
    
}

class FeedObject:Mappable {
    var objectType:String!
    var objectArticle:Article? = Article()
    var objectLink:Link? = Link()
    var objectAlbum:Album? = Album()
    var objectPhoto:Photo? = Photo()
    var objectVideo:Video? = Video()
    var objectTopic:Topic? = Topic()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        objectType <- map["type"]
        objectArticle <- map["article"]
        objectAlbum <- map["album"]
        objectLink <- map["link"]
        objectPhoto <- map["photo"]
        objectVideo <- map["video"]
        objectTopic <- map["topic"]
    }
    
}

class FeedReceiver:Mappable {
    var revType:String!
    var revTopic: Topic?
    var revUser: Users?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        revType <- map["type"]
        revTopic <- map["topic"]
        revUser <- map["user"]
    }
    
}

class ListFeed:Mappable {
    var listFeed:[Feed]?
    var lastCreated:String?
    var lastCreatedNumber:Double? = 0
    var nextUrl:String?
    
    var countUnread:Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        listFeed <- map["data.feeds"]
        lastCreatedNumber <- map["data.last_created"]
        if lastCreatedNumber > 0 {
            lastCreated = lastCreatedNumber!.description
        }
        nextUrl <- map["data.next"]
        countUnread <- map["data.unread"]
    }
}