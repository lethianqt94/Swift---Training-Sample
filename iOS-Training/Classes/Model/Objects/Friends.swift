//
//  Friends.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/26/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class Friends: Mappable {
    
    // MARK: - Variables
    
    var items: [Users]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
    }
}
