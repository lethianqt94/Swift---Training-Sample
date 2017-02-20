//
//  UsersTopic.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/17/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class UsersTopic: Mappable {
    
    // MARK: - Variables
    
    var code: Int?
    var items: [ItemsTopic]?
    
    var total: Int?
    var limit: Int?
    var pages: Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        code <- map["meta.code"]
        items <- map["data.items"]
        total <- map["data.pages.total"]
        limit <- map["data.pages.limit"]
        pages <- map["data.pages.pages"]
    }
}
