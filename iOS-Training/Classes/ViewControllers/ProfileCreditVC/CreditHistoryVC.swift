//
//  CreditHistoryVC.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/29/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD

class CreditHistoryVC: ParentVC, ProfileCreditManagerAPIDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: outlets + variables
    
    @IBOutlet weak var imvOwnerAvatar: UIImageView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblCreaditNumber: UILabel!
    
    @IBOutlet weak var lblCreditNum: UILabel!
    
    @IBOutlet weak var tbvCreditHistory: UITableView!    
    @IBOutlet weak var lblFAQ: UILabel!
    
    var user:Users! = Users()
    
    var listCredit:ListCredit! = ListCredit()
    
    var creditHistoryItems:[Credit]! = []

    let creditHistoryCell:String = "CreditHistoryCell"
    
    let apiManager:ProfileCreditManagerAPI! = ProfileCreditManagerAPI()
    
    var progress: MBProgressHUD? = nil
    
    var isLast:Bool = false
    var page:Int = 1
    var isRefresh:Bool = false

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        user = AccountManager.sharedInstance.getInfoUser()
        
        progress = MBProgressHUD(view: self.view)
        self.view.addSubview(progress!)
        
        if let imvAvt = self.imvOwnerAvatar{
            imvAvt.layer.cornerRadius = 4
            imvAvt.layer.borderWidth = 1
            imvAvt.layer.borderColor = UIColor.whiteColor().CGColor
            imvAvt.clipsToBounds = true
        }
        let avtUrl:String! = user.getUserAvatar()
        print("user avt : \(user.avatar)")
        print("avt url: \(avtUrl)")
        
        CommonFunc.getImageData(avtUrl, imageView: self.imvOwnerAvatar)
        
        lblOwnerName.text = user.displayName
        setTextForLblCreditNum(user.credit)
        
        lblCreaditNumber.text = String(user.credit!)
        
        self.tbvCreditHistory.registerNib(UINib(nibName: "CreditHistoryCell", bundle: nil), forCellReuseIdentifier: creditHistoryCell)
        apiManager.profileCreditManagerAPIDelegate = self
        apiManager.progress = progress
        apiManager.getCreditHistoryItems(page)
        
        figureTableCellHeight()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set vc's content
    
    func setTextForLblCreditNum(credit: Int!){
        let info: NSMutableAttributedString = NSMutableAttributedString(string: "Current credits:  ", attributes: [NSFontAttributeName:Regular14])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 33, green: 33, blue: 33), range: NSMakeRange(0, info.length))
        
        let credit:NSMutableAttributedString = NSMutableAttributedString(string: String(credit), attributes: [NSFontAttributeName:Semibold16])
        credit.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 76, green: 175, blue: 80), range: NSMakeRange(0, credit.length))
        info.appendAttributedString(credit)
        
        lblCreditNum.attributedText = info
    }
    
    func figureTableCellHeight() {
        
        tbvCreditHistory.rowHeight = UITableViewAutomaticDimension
        tbvCreditHistory.estimatedRowHeight = 100
    }
    
    //MARK: UITableView Delegate + DataSource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return creditHistoryItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CreditHistoryCell! = tableView.dequeueReusableCellWithIdentifier(creditHistoryCell) as? CreditHistoryCell
        cell.creditHistoryObj = creditHistoryItems[indexPath.row]
        cell.setContentToCreditHistoryCell()
        
        if indexPath.row == self.creditHistoryItems.count - 1 && isLast == false {
            apiManager.getCreditHistoryItems(page++)
            isRefresh = true
        }        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: ProfileCreditManagerAPIDelegate
    
    func profileCreditManagerAPIDelegate(sendListCreditData listCredit: ListCredit, isLastPage:Bool) {
        
        self.isLast = isLastPage
        
        if isRefresh == false {
            self.creditHistoryItems.removeAll(keepCapacity: false)
        }
        
        self.creditHistoryItems.appendContentsOf(listCredit.listCredit!)
        
        if listCredit.listCredit?.count > 0 {
            Async.main {
                self.tbvCreditHistory.reloadData()
            }
        }
        
        isRefresh = false
        
    }
}
