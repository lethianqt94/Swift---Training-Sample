//
//  Type.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Type:Mappable {
    
    var typeZoneId:String?
    var typeAlias:String?
    var typeName:String?
    
    var type:String? = "type"
    var typeWeight:Int?
    var typeFollowersNum:Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        typeZoneId <- map["zone_id"]
        typeAlias <- map["alias"]
        typeName <- map["name"]
        type <- map["type"]
        typeWeight <- map["weight"]
        typeFollowersNum <- map["stats.followers"]
    }
    
    func getTypeImageUrl()->String {
        let url = CommonFunc.getImgFromAlias(typeAlias!)
        return url
    }
    
}