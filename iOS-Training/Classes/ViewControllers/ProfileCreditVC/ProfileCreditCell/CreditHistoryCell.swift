//
//  CreditHistoryCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/27/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class CreditHistoryCell: UITableViewCell {
    
    
    //MARK: Outlets + Variables
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblObject: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    
    var creditHistoryObj:Credit! = Credit()
    
    let dateFormatter = NSDateFormatter()
    var date:NSDate!
    
    //MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: set content to cell
    internal func setContentToCreditHistoryCell() {
        date = dateFormatter.dateFromString(creditHistoryObj.creditCreated!)
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: date!)
        let hour = comp.hour
        let minute = comp.minute
        let day = comp.day
        let month = comp.month
        let year = comp.year
        lblTime.text = convertToString(hour) + ":" + convertToString(minute)
        lblDate.text = convertToString(day) + "/" + convertToString(month) + "/" + String(year)
        lblAction.text = createActionString()
        lblObject.text = setupObject()
        lblCredit.text = String(creditHistoryObj.creditGot!)
        
    }
    
    func convertToString(int:Int!)->String {
        if int < 10 {
            return "0\(int)"
        } else {
            return "\(int)"
        }
    }
    
    func setupObject()->String {
        lblObject.textColor = UIColor(red: 76, green: 175, blue: 80)
        var type:String = ""
        if let actionType = creditHistoryObj.creditAction {
            type = actionType
        }
        switch (type) {
        case ActionType.actionOnline:
            lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
            return "In " + CommonFunc.dateDiff(date)
        case ActionType.actionCreate:
            let tpName = creditHistoryObj.creditObjTopic?.tpTitle
            return tpName!
        case ActionType.actionPost:
            let tpName = creditHistoryObj.creditObjType
            if (tpName == ResourceType.Article || tpName == ResourceType.Album) {
                return "An " + tpName!
            } else {
                return "A " + tpName!
            }
            
        default:
            lblObject.textColor = UIColor(red: 76, green: 175, blue: 80)
            var objType:String = ""
            if let objectType = creditHistoryObj.creditObjType {
                objType = objectType
            }
            switch(objType) {
            case ResourceType.Photo:
                var revName:String = ""
                var revType:String = ""
                if let type = creditHistoryObj.creditObjPhoto?.ptReceiver?.revType {
                    revType = type
                }
                if let photo = creditHistoryObj.creditObjPhoto {
                    if revType == "user" {
                        revName = (photo.ptReceiver?.revUser?.displayName)!
                        return revName + "'s Photo"
                    } else {
                        revName = (photo.ptReceiver?.revTopic?.tpTitle)!
                        return "Photo of " + revName
                    }
                } else {
                    lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
                    return "A photo"
                }
            case ResourceType.Album:
                var revName:String = ""
                var revType:String = ""
                if let type = creditHistoryObj.creditObjAlbum?.albReceiver?.revType {
                    revType = type
                }
                if let album = creditHistoryObj.creditObjAlbum {
                    if revType == "user" {
                        revName = (album.albReceiver?.revUser?.displayName)!
                        return revName + "'s Album"
                    } else {
                        revName = (album.albReceiver?.revTopic?.tpTitle)!
                        return "Album of " + revName
                    }
                } else {
                    lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
                    return "An album"
                }
            case ResourceType.Video:
                var revName:String = ""
                var revType:String = ""
                if let type = creditHistoryObj.creditObjVideo?.vidReceiver?.revType {
                    revType = type
                }
                if let video = creditHistoryObj.creditObjVideo {
                    if revType == "user" {
                        revName = (video.vidReceiver?.revUser?.displayName)!
                        return revName + "'s Video"
                    } else {
                        revName = (video.vidReceiver?.revTopic?.tpTitle)!
                        return "Video of " + revName
                    }
                } else {
                    lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
                    return "A video"
                }
            case ResourceType.Article:
                var revName:String = ""
                var revType:String = ""
                if let type = creditHistoryObj.creditObjArticle?.artReceiver?.revType {
                    revType = type
                }
                if let article = creditHistoryObj.creditObjArticle {
                    if revType == "user" {
                        revName = (article.artReceiver?.revUser?.displayName)!
                        return revName + "'s Article"
                    } else {
                        revName = (article.artReceiver?.revTopic?.tpTitle)!
                        return "Article of " + revName
                    }
                } else {
                    lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
                    return "An article"
                }
            case ResourceType.Link:
                var revName:String = ""
                var revType:String = ""
                if let type = creditHistoryObj.creditObjLink?.lnkReceiver?.revType {
                    revType = type
                }
                if let link = creditHistoryObj.creditObjLink {
                    if revType == "user" {
                        revName = (link.lnkReceiver?.revUser?.displayName)!
                        return revName + "'s Link"
                    } else {
                        revName = (link.lnkReceiver?.revTopic?.tpTitle)!
                        return "Link of " + revName
                    }
                } else {
                    lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
                    return "A link"
                }
            case ResourceType.Topic:
                var revName:String = ""
                
                if let topic = creditHistoryObj.creditObjTopic {
                    revName = (topic.tpOwner?.displayName)!
                    return "Topic of " + revName
                } else {
                    lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
                    return "A Topic"
                }
            case ResourceType.SpendTime:
                lblObject.textColor = UIColor(red: 155, green: 155, blue: 155)
                if let time = creditHistoryObj.creditObjSpendTime {
                    if time.value > 1 {
                        return "\(time.value!) \(time.unit!)s"
                    } else {
                        return "\(time.value!) \(time.unit!)"
                    }
                } else {
                    return "???"
                }
            default:
                print("doi tuong chua duoc nhin thay bao gio... :3")
                return "doi tuong chua duoc nhin thay bao gio... :3"
            }
        }
    }
    
    func createActionString()->String {
        if let action = creditHistoryObj.creditAction {
            switch (action) {
            case ActionType.actionLike:
                return "Liked"
            case ActionType.actionComment:
                return "Commented"
            case ActionType.actionShare:
                return "Shared"
            case ActionType.actionOnline:
                return "Online"
            case ActionType.actionCreate:
                return "Created"
            case ActionType.actionPost:
                return "Posted"
            case ActionType.actionContribute:
                return "Contributed"
            case ActionType.actionSpendTime:
                return "Spend time"
            default:
                print("cai chi day ko biet nua...")
                return "\(action)"
            }
        }
        return "???"
    }
    
}
