//
//  Collections.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/26/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class Collections: Mappable {
    
    // MARK: - Variables
    
    var items: [ItemCollection]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
    }
}

class ItemCollection: Mappable {
    
    // MARK: - Variables

    var cover: String?

    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cover <- map["user.cover"]
    }
}
