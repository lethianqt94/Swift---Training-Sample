//
//  Credit.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/20/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Credit:Mappable {
    
    var creditId:String?
    var creditName:String?
    var creditDesc:String?
    var creditImage:String?
    var creditExpDate:String?
    var creditUpdate:String?
    var creditNumber:String?
    var creditPrice:String?
    var creditTotal:String?
    var creditStatus:String?
    
    //creadit history
    var creditAction:String?
    var creditObjType:String?
    var creditObjVideo:Video?
    var creditObjAlbum:Album?
    var creditObjPhoto:Photo?
    var creditObjLink:Link?
    var creditObjTopic:Topic?
    var creditObjArticle:Article?
    var creditObjSpendTime:SpendTime?
    
    var creditGot:Int?
    var creditCreated:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        creditId <- map["id"]
        creditName <- map["name"]
        creditDesc <- map["description"]
        creditImage <- map["image"]
        creditExpDate <- map["expiration_date"]
        creditUpdate <- map["updated"]
        creditNumber <- map["credit"]
        creditPrice <- map["price"]
        creditTotal <- map["total"]
        creditStatus <- map["status"]
        
        creditAction <- map["action"]
        creditObjType <- map["object.type"]
        creditObjVideo <- map["object.video"]
        creditObjAlbum <- map["object.album"]
        creditObjPhoto <- map["object.photo"]
        creditObjLink <- map["object.link"]
        creditObjTopic <- map["object.topic"]
        creditObjArticle <- map["object.article"]
        creditObjSpendTime <- map["object.spend_time"]
        
        creditGot <- map["credit"]
        creditCreated <- map["created"]
    }
    
    internal func getCreditPhotoUrl()->String {
        let imgUrl = CommonFunc.getImgFromAvatar(creditImage!)
        return imgUrl
    }
    
}

class ListCredit:Mappable {
    var listCredit:[Credit]?
    var pageLimit:Int?
    var pages:Int?
    var total:Int?
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        listCredit <- map["data.items"]
        pageLimit <- map["data.pages.limit"]
        pages <- map["data.pages.pages"]
        total <- map["data.pages.total"]
        
    }
}