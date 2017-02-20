//
//  CommonColorFromHex.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /**
     Returns the float value of a string
     */
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    /**
     Subscript to allow for quick String substrings ["Hello"][0...1] = "He"
     */
    subscript (r: Range<Int>) -> String {
        get {
            let start = self.startIndex.advancedBy(r.startIndex)
            let end = self.startIndex.advancedBy(r.endIndex - 1)
            return self.substringWithRange(start..<end)
        }
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    // Creates a UIColor from a Hex string.
    convenience init(var hex: String) {
        var alpha: Float = 100
        let hexLength = hex.characters.count
        if !(hexLength == 7 || hexLength == 9) {
            // A hex must be either 7 or 9 characters (#GGRRBBAA)
            print("improper call to 'colorFromHex', hex length must be 7 or 9 chars (#GGRRBBAA)")
            self.init(white: 0, alpha: 1)
            return
        }
        
        if hexLength == 9 {
            // Note: this uses String subscripts as given below
            alpha = hex[7...8].floatValue
            hex = hex[0...6]
        }
        
        // Establishing the rgb color
        var rgb: UInt32 = 0
        let s: NSScanner = NSScanner(string: hex)
        // Setting the scan location to ignore the leading `#`
        s.scanLocation = 1
        // Scanning the int into the rgb colors
        s.scanHexInt(&rgb)
        
        // Creating the UIColor from hex int
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha / 100)
        )
    }
}

//MARK: Fonts

let Semibold13 = UIFont.systemFontOfSize(13, weight: UIFontWeightSemibold)

let Semibold12 = UIFont.systemFontOfSize(12, weight: UIFontWeightSemibold)

let Semibold16 = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)

let Semibold15 = UIFont.systemFontOfSize(15, weight: UIFontWeightSemibold)

let Semibold20 = UIFont.systemFontOfSize(20, weight: UIFontWeightSemibold)

let Semibold24 = UIFont.systemFontOfSize(24, weight: UIFontWeightSemibold)

let Regular145 = UIFont.systemFontOfSize(14.5, weight: UIFontWeightRegular)

let Regular12 = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)

let Regular13 = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)

let Regular14 = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)

let Regular15 = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
let Regular16 = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
let Regular24 = UIFont.systemFontOfSize(24, weight: UIFontWeightRegular)

let Thin22 = UIFont.systemFontOfSize(22, weight: UIFontWeightThin)

let Semibold145 = UIFont.systemFontOfSize(14.5, weight: UIFontWeightSemibold)

let Semibold14 = UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold)