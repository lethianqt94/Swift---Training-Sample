//
//  SpendTime.swift
//  iOS-Training
//
//  Created by Le Thi An on 2/3/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class SpendTime:Mappable {
    
    var unit:String?
    var value:Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        unit <- map["unit"]
        value <- map["value"]
    }
}