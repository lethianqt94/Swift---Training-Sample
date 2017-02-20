//
//  MoreVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoreVC: ParentVC, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MoreVCDelegate, LogoutDelegate, CoverCellDelegate {

    // MARK: - Variables
    
    let arrTitleMenu = ["About", "Friends", "Message", "Following", "Collection", "Shopping"]
    let arrBackgroundIconMenu = ["ic_about_morevc.png", "ic_friend_morevc.png", "ic_message_morevc.png", "ic_following_morevc.png", "ic_collection_morevc.png", "ic_shopping_morevc.png"]
    
    let arrTitleAccount = ["Terms of Service", "Settings", "Support & Help"]
    let arrIconAccount = ["ic_service_morevc.png", "ic_setting_morevc.png", "ic_help_morevc.png"]
    
    var user = Users()
    var arrItemsTopic = NSMutableArray()
    var arrItemsMenuMore = NSMutableArray()
    var screenWidth: CGFloat?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var moreFlow:MoreVCManagerFlow?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addItemOnNaviBar(left: ParentVC.ItemType.None, center: ParentVC.ItemType.SearchBar, right: ParentVC.ItemType.None)
        moreFlow = MoreVCManagerFlow(navi: self.navigationController)
        
        let nibCellMore = UINib.init(nibName: "MoreCell", bundle: nil)
        tableView.registerNib(nibCellMore, forCellReuseIdentifier: "MoreCell")
        
        let nibCellLogout = UINib.init(nibName: "LogoutCell", bundle: nil)
        tableView.registerNib(nibCellLogout, forCellReuseIdentifier: "LogoutCell")
        
        let nibCellCover = UINib.init(nibName: "CoverCell", bundle: nil)
        tableView.registerNib(nibCellCover, forCellReuseIdentifier: "CoverCell")
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        
        user = AccountManager.sharedInstance.getInfoUser()
        
        let moreVCAPI = MoreVCManagerAPI()
        moreVCAPI.delegate = self
        moreVCAPI.requestTopic(accessToken: user.accessToken!)
        
        for i in 0..<arrTitleMenu.count {
            let itemMenuMore = ItemsMenuMore()
            itemMenuMore.title = arrTitleMenu[i]
            if arrTitleMenu[i] == "Friends" {
                itemMenuMore.isShowOnTableView = true
            } else {
                itemMenuMore.isShowOnTableView = false
            }
            itemMenuMore.imgBackground = arrBackgroundIconMenu[i]
            arrItemsMenuMore.addObject(itemMenuMore)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Override Methods
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLayoutSubviews() {
        if tableView.respondsToSelector("setSeparatorInset:") {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector("setLayoutMargins:") {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - CoverCell Delegate Methods
    
    func coverCellToProfileCredit(event event: Bool) {
        if event {
            moreFlow!.goToProfileCreditVC()
        }
    }
    
    func coverCellToProfile(event event: Bool) {
        if event {
            moreFlow!.pushToProfileVC()
        }
    }
    
    // MARK: - MoreVC Delegate Methods
    
    func moreVCDelegate(sendEventLogoutWithCode code: Int) {
        if code == 200 {
            let signInVC = SignInVC()
            signInVC.userDefault.removeObjectForKey("accesstoken")
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            moreFlow!.pushToSignInVC()
        }
    }
    
    func moreVCDelegate(sendItemsTopicUser itemsTopic: [ItemsTopic]) {
        for object in itemsTopic {
            arrItemsTopic.addObject(object)
            tableView.reloadData()
        }
    }
    
    // MARK: - Logout Delegate Method
    
    func logout(sendAction action: Bool) {
        if action == true {
            CommonFunc.showIndicator(title: "Loading...", view: self.view)
            
            let moreVCAPI = MoreVCManagerAPI()
            moreVCAPI.delegate = self
            moreVCAPI.requestLogout(accessToken: user.accessToken!)
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //number cell credit history and profile
            return 2
        } else if section == 1 {
            //cell menu
            return 6
        } else if section == 2 {
            //number cell topic
            if arrItemsTopic.count != 0 {
                if arrItemsTopic.count < 3 {
                    return arrItemsTopic.count
                }
                return 3
            } else {
                return 0
            }
        } else if section == 3 {
            //cell title account
            return 3
        } else {
            //number cell logout
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //cell credit history
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("CoverCell", forIndexPath: indexPath) as! CoverCell
                let stringImgAvatar = PHOTO_API_SERVER + user.avatar!
                let stringImgCover = PHOTO_API_SERVER + user.cover!
                CommonFunc.getImageData(stringImgAvatar, imageView: cell.imgAvatar)
                CommonFunc.getImageData(stringImgCover, imageView: cell.imgCover)
                cell.lblDisplayName.text = user.displayName!
                if let credit = user.credit {
                    cell.lblNumberCredit.text = String(credit)
                }
                cell.delegate = self
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath) as! MoreCell
                cell.imgBackgroundIcon.image = UIImage(named: "ic_credit_history.png")
                cell.lblTitle.text = "Credit History"
                cell.lblNumber.hidden = true
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        } else if indexPath.section == 1 {
            //cell menu
            let cell = tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath) as! MoreCell
            let itemMenu = arrItemsMenuMore[indexPath.row] as! ItemsMenuMore
            cell.lblTitle.text = itemMenu.title
            cell.imgBackgroundIcon.image = UIImage(named: itemMenu.imgBackground!)
            if let total = user.friends {
                if itemMenu.isShowOnTableView == true {
                    cell.lblNumber.hidden = false
                    cell.lblNumber.text = String(total)
                } else {
                    cell.lblNumber.hidden = true
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if indexPath.section == 2 {
            //title cells topic
            let cell = tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath) as! MoreCell
            if (arrItemsTopic.count != 0) {
                if let item = arrItemsTopic[indexPath.row] as? ItemsTopic {
                    cell.lblTitle.text = item.title
                    cell.lblNumber.hidden = false
                    item.isShowOnTableView = true
                    cell.lblNumber.text = String(item.views!)
                    if item.avatar == "" {
                        cell.imgBackgroundIcon.image = UIImage(named: "img_no_useravatar.png")
                    } else {
                        let stringImg = PHOTO_API_SERVER + item.avatar!
                        cell.imgBackgroundIcon.hnk_setImageFromURL(NSURL(string: stringImg)!)
                    }
                    return cell
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if indexPath.section == 3 {
            //cells account
            let cell = tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath) as! MoreCell
            cell.lblTitle.text = arrTitleAccount[indexPath.row]
            cell.imgBackgroundIcon.image = UIImage(named: arrIconAccount[indexPath.row])
            cell.lblNumber.hidden = true
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            //cell logout
            let cell = tableView.dequeueReusableCellWithIdentifier("LogoutCell", forIndexPath: indexPath) as! LogoutCell
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 83
        }
        return 55
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return CommonFunc.getViewForTableViewSection(title: "MENU", widthView: tableView.frame.size.width)
        } else if section == 2 {
            return CommonFunc.getViewForTableViewSection(title: "MY TOPICS", widthView: tableView.frame.size.width)
        } else if section == 3 {
            return CommonFunc.getViewForTableViewSection(title: "ACCOUNT", widthView: tableView.frame.size.width)
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 || section == 3 {
            return 40
        } else if section == 4 {
            return 8
        }
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 0 && indexPath.row == 1) {
            moreFlow!.pushToCreditHistoryVC()
        } else if indexPath.section == 2 {
            if (arrItemsTopic.count != 0) {
                if let item = arrItemsTopic[indexPath.row] as? ItemsTopic {
                    moreFlow?.pushToTopicDetailVC(topicId: item.zoneId!)
                }
            }
        }
    }
}
