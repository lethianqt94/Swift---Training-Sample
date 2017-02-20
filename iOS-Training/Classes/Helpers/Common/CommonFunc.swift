//
//  CommonFunc.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire

extension NSURL {
    func queryStringComponents() -> [String: AnyObject] {
        
        var dict = [String: AnyObject]()
        
        // Check for query string
        if let query = self.query {
            
            // Loop through pairings (separated by &)
            for pair in query.componentsSeparatedByString("&") {
                
                // Pull key, val from from pair parts (separated by =) and set dict[key] = value
                let components = pair.componentsSeparatedByString("=")
                dict[components[0]] = components[1]
            }
            
        }
        
        return dict
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController where top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}

class CommonFunc {
    
    class func dateDiff(origDate: NSDate) -> String {
        var ti = origDate.timeIntervalSinceNow
        var diff = 0
        ti = ti * -1;
        if(ti < 1) {
            return "few seconds ago"
        } else if (ti < 60) {
            return "less than a minute ago"
        } else if (ti < 3600) {
            diff = Int(ti / 60);
            if (diff == 1) {
                return "a minute ago"
            } else {
                return String(diff) + " minutes ago"
            }
        } else if (ti < 86400) {
            diff = Int(ti / 60 / 60)
            if (diff == 1) {
                return "an hour ago"
            } else {
                return String(diff) + " hours ago"
            }
        } else {
            diff = Int(ti / 60 / 60 / 24)
            if (diff == 1) {
                return "a day ago"
            } else {
                if (diff < 7) {
                    return String(diff) + " days ago"
                } else if (diff == 7){
                    return "a week ago"
                } else if (diff > 7 && diff < 30){
                    if (Int(diff/7) == 1) {
                        return "more than a week ago"
                    } else {
                        if (diff%7 == 0) {
                            return String(Int(diff/7)) + " weeks ago"
                        } else {
                            return "more than " + String(Int(diff/7)) + " weeks ago"
                        }
                    }
                } else if (diff == 30) {
                    return "one month ago"
                } else if (diff > 30 && diff < 365) {
                    if (Int(diff)/30 == 1) {
                        return "more than one month ago"
                    } else {
                        if (diff%30 == 0) {
                            return String(Int(diff/30)) + " months ago"
                        } else {
                            return "more than " + String(Int(diff/30)) + " months ago"
                        }
                    }
                } else if (diff == 365) {
                    return "one year ago"
                } else {
                    if (Int(diff/365) == 1) {
                        return "more than one year ago"
                    } else {
                        if (diff%365 == 0) {
                            return String(Int(diff/365)) + " years ago"
                        } else {
                            return "more than " + String(Int(diff/365)) + " years ago"
                        }
                    }
                }
            }
        }
    }
    
    class func getImageData(urlImage: String, imageView: UIImageView) {
        imageView.hnk_setImageFromURL(NSURL(string:urlImage)!, placeholder: nil, format: nil, failure: { (error) -> () in
            
            }) { (image) -> () in
                imageView.image = image
        }
        
    }
    
    class func getImgFromAvatar(avt:String)->String {
        return IMAGE_API + avt
        //        return "http://d2yz3n5612lnr6.cloudfront.net/upload/gallery/thumbs/548-10000/\(avt)"
    }
    
    class func getImgFromAlias(alias:String)->String {
        return "http://photo.gamma.youlook.net/data/v1.2.1/images/types/\(alias).jpg"
    }
    
    class func getAPIFeed(userId:String!, linguistic_id:Int!, limit:Int!)->String {
        return NEWFEEDS_API_SERVER + "\(userId)/interest/\(linguistic_id)?limit=\(limit)"
    }
    
    class func getAPIProfileFeed(userId:String!, linguistic_id:Int!, limit:Int!)->String {
        return NEWFEEDS_API_SERVER + "\(userId)/profile/\(linguistic_id)?limit=\(limit)"
    }
    
    class func getAPITrending(linguistic_id:Int!, limit:Int!)->String {
        return TRENDING_API_SERVER + "\(linguistic_id)?limit=\(limit)"
    }
    
    class func getAPILike(objectType:String, objId:String)->String {
        return API_HOST + "/like/" + objectType + "/" + objId
    }
    
    class func getNotificationAPI(userId:String, linguistic_id:Int!, limit:Int!)->String {
        return NEWFEEDS_API_SERVER + "\(userId)/notification/\(linguistic_id)?limit=\(limit)"
    }
    
    class func getUnreadNotificationNum(userId:String, linguistic_id:Int!)->String {
        return NEWFEEDS_API_SERVER + "\(userId)/notification/\(linguistic_id)/count_unread"
    }
    
    class func getTopicDetailsAPI(topicId:String, tail:String)->String {
        return API_HOST + "/topics/" + topicId + "/" + tail
    }
    
    
    class func getAttributeString(date:String)->NSMutableAttributedString {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: "Post this content - \(date)", attributes: [NSFontAttributeName:Regular14])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155, green: 155, blue: 155), range: NSMakeRange(0, info.length))
        return info
    }
    
    class func getMutableAttributedString(topic:String, date:String)->NSMutableAttributedString {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: "Post in ", attributes: [NSFontAttributeName:Regular14])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155, green: 155, blue: 155), range: NSMakeRange(0, info.length))
        
        let topic:NSMutableAttributedString = NSMutableAttributedString(string: topic, attributes: [NSFontAttributeName:Semibold14])
        topic.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 33, green: 33, blue: 33), range: NSMakeRange(0, topic.length))
        info.appendAttributedString(topic)
        
        let date: NSMutableAttributedString = NSMutableAttributedString(string: " - \(date)", attributes: [NSFontAttributeName:Regular14])
        date.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155, green: 155, blue: 155), range: NSMakeRange(0, date.length))
        info.appendAttributedString(date)
        
        return info
    }
    
    // [Tuan] Custom Methods
    
    class func getAPIProfileUser(userId:String!, linguistic_id:Int!, limit:Int!)->String {
        return NEWFEEDS_API_SERVER + "\(userId)/profile/\(linguistic_id)?limit=\(limit)"
    }
    
    class func getAttributeStringOnlyOneLiker(displayName displayName: String) -> NSMutableAttributedString {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: displayName, attributes: [NSFontAttributeName: Regular13])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 44, green: 44, blue: 44),
                                                          range: NSRange(location: 0, length: info.length))
        
        let stringLikeThis: NSMutableAttributedString = NSMutableAttributedString(string: " likes this",
            attributes: [NSFontAttributeName: Regular13])
        stringLikeThis.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 133, green: 133, blue: 133),
            range: NSRange(location: 0, length: stringLikeThis.length))
        
        info.appendAttributedString(stringLikeThis)
        
        return info
    }
    
    class func getAttributeStringInfoLikerPhoto(displayName displayName: String, numberLiker: Int) -> NSMutableAttributedString {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: displayName, attributes: [NSFontAttributeName: Regular13])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 44, green: 44, blue: 44),
                                                          range: NSRange(location: 0, length: info.length))
        
        let stringAnd: NSMutableAttributedString = NSMutableAttributedString(string: " and ", attributes: [NSFontAttributeName: Regular13])
        stringAnd.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 133, green: 133, blue: 133),
                                                          range: NSRange(location: 0, length: stringAnd.length))
        
        info.appendAttributedString(stringAnd)
        
        let numberLiker: NSMutableAttributedString = NSMutableAttributedString(string: String(numberLiker),
                                                                           attributes: [NSFontAttributeName: Regular13])
        
        numberLiker.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 44, green: 44, blue: 44),
                                                                 range: NSRange(location: 0, length: numberLiker.length))
        info.appendAttributedString(numberLiker)
        
        let stringLikeThis: NSMutableAttributedString = NSMutableAttributedString(string: " likes this",
                                                                              attributes: [NSFontAttributeName: Regular13])
        stringLikeThis.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 133, green: 133, blue: 133),
                                                                    range: NSRange(location: 0, length: stringLikeThis.length))
        
        info.appendAttributedString(stringLikeThis)
        
        return info
    }
    
    class func getAttributeStringInfoImage(location location: String, colorTextLocation: UIColor, date: String) -> NSMutableAttributedString {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: "Posted in ", attributes: [NSFontAttributeName: Regular14])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 182, green: 182, blue: 182),
                                                          range: NSRange(location: 0, length: info.length))
        
        let location: NSMutableAttributedString = NSMutableAttributedString(string: location, attributes: [NSFontAttributeName: Regular14])
        location.addAttribute(NSForegroundColorAttributeName, value: colorTextLocation,
                                                              range: NSRange(location: 0, length: location.length))
        info.appendAttributedString(location)
        
        let date: NSMutableAttributedString = NSMutableAttributedString(string: " - \(date)", attributes: [NSFontAttributeName: Regular14])
        date.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 182, green: 182, blue: 182),
                                                          range: NSRange(location: 0, length: date.length))
        info.appendAttributedString(date)
        
        return info
    }
    
    class func showIndicator(title title: String, view: UIView) {
        let hudLoading = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hudLoading.mode = MBProgressHUDMode.Indeterminate
        hudLoading.labelText = title
    }
    
    class func hideIndicator(view: UIView) {
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
    class func addActionSheet(viewController viewController: UIViewController, picker: UIImagePickerController) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let shootPhotoAction = UIAlertAction(title: "Shoot Photo", style: .Default, handler:
            {
                (alert: UIAlertAction) -> Void in
                if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                    picker.allowsEditing = false
                    picker.sourceType = UIImagePickerControllerSourceType.Camera
                    picker.cameraCaptureMode = .Photo
                }else{
                    let alert = UIAlertController(title: "NOTICE",
                                                message: "Sorry, this device has no camera",
                                         preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: UIAlertActionStyle.Default,
                                                handler: nil))
                    viewController.presentViewController(alert, animated: true, completion: nil)
                }
        })
        
        let fromLibraryAction = UIAlertAction(title: "From Library", style: .Default, handler:
            {
                (alert: UIAlertAction) -> Void in
                
                picker.allowsEditing = false
                picker.sourceType = .PhotoLibrary
                picker.modalPresentationStyle = .Popover
                viewController.presentViewController(picker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionMenu.addAction(shootPhotoAction)
        optionMenu.addAction(fromLibraryAction)
        optionMenu.addAction(cancelAction)
        viewController.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    class func getAttributePlaceholder(placeholder: String)->NSMutableAttributedString {
        let string = NSMutableAttributedString(string: placeholder, attributes: [NSFontAttributeName: Regular16])
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 88, green: 88, blue: 88),
            range: NSRange(location: 0, length: string.length))
        return string
    }
    
    class func getAttributeStringSignUp()->NSMutableAttributedString {
        let string = NSMutableAttributedString(string: "Don't have account?", attributes: [NSFontAttributeName: Regular16])
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 182, green: 182, blue: 182),
            range: NSRange(location: 0, length: string.length))
        
        let stringSignUp = NSMutableAttributedString(string: " Sign up now", attributes: [NSFontAttributeName: Semibold16])
        stringSignUp.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255, green: 255, blue: 255),
            range: NSRange(location: 0, length: stringSignUp.length))
        string.appendAttributedString(stringSignUp)
        
        return string
    }
    
    class func getViewForTableViewSection(title title: String!, widthView: CGFloat) -> UIView {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: widthView, height: 20))
        let label = UILabel.init(frame: CGRect(x: 16, y: 10, width: widthView, height: 20))
        label.font = UIFont.systemFontOfSize(14)
        let sectionTitle = title
        label.text = sectionTitle
        label.textColor = UIColor(red: 155, green: 155, blue: 155)
        view.addSubview(label)
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    
    class func downloadObjectWithStringURL(urlFile:String, success:(dataFile:NSData?, error:NSError?)->Void, percent:(value:Float?)->Void)->Void{
        
        Alamofire.request(.GET, urlFile, headers:nil).progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
            
            Async.main{
                percent(value: Float(totalBytesRead)/Float(totalBytesExpectedToRead))
            }
            }.response { (request, response, data, error) -> Void in
                if error != nil{
                    
                    
                    
                }else{
                    
                    Async.main{
                        success(dataFile: data!, error: nil)
                    }
                }
        }
        
    }
}