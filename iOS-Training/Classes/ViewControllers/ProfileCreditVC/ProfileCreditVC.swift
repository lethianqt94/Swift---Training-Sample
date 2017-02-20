//
//  ProfileCreditVC.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/20/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileCreditVC: ParentVC, UITableViewDelegate, UITableViewDataSource, ProfileCreditManagerAPIDelegate, ProfileCreditCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource, PickerViewCustomDelegate{
    
    //MARK: outlets + variables
    
    @IBOutlet weak var imvOwnerAvatar: UIImageView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblCreaditNumber: UILabel!
    @IBOutlet weak var btnPrintOption: UIButton!
    @IBOutlet weak var lblCreditNum: UILabel!
    
    @IBOutlet weak var tbvCreditProfile: UITableView!
    
    
    var user:Users! = Users()
    
    var listCredit:ListCredit! = ListCredit()
    
    var creditItems:[Credit]! = []
    
    let profileCreditCell:String = "ProfileCreditCell"
    
    let apiManager:ProfileCreditManagerAPI! = ProfileCreditManagerAPI()
    
    var currentCell:ProfileCreditCell? = ProfileCreditCell()
    //    var pickerView:UIPickerView!
    var pickerViewArray:[Int]! = [1, 2, 3, 4, 5]
    
    var isCompleted:Bool = false
    
    var currentTbvIndexPathRow:Int! = 0
    
    var progress: MBProgressHUD? = nil
    
    var pickerViewComponent:PickerViewCustom!
    
    var isLast:Bool = false
    var page:Int = 1
    var isRefresh:Bool = false
    
    //MARK: lifecycle
    
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
        
        self.tbvCreditProfile.registerNib(UINib(nibName: "ProfileCreditCell", bundle: nil), forCellReuseIdentifier: profileCreditCell)
        apiManager.profileCreditManagerAPIDelegate = self
        apiManager.progress = progress
        apiManager.getCreditItems(page)
        
        figureTableCellHeight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Async.main {
            self.tbvCreditProfile.reloadData()
        }
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
        
        tbvCreditProfile.rowHeight = UITableViewAutomaticDimension
        tbvCreditProfile.estimatedRowHeight = 160
    }
    
    //MARK: PickerViewCustom Delegate
    func hidePickerView(pickerViewCustomDelegate: PickerViewCustomDelegate) {
        if pickerViewComponent != nil && pickerViewComponent.alpha == 1 {
            pickerViewComponent.alpha = 0
        }
    }
    
    func tapToDone(pickerViewCustomDelegate: PickerViewCustomDelegate) {
        let selectedRow = pickerViewComponent.pickerView.selectedRowInComponent(0)
        let selectedTitle = pickerViewArray[selectedRow]
        
        if let cell = currentCell {
            cell.lblQuantity.text = String(selectedTitle)
            print("cell.lblQuantity.text : \(cell.lblQuantity.text)")
            let crdItem = cell.creditItem
            
            let total = Int(crdItem.creditNumber!)!*(selectedTitle)
            crdItem.creditTotal = String(total)
            cell.lblTotal.text = String(total)
            print("total : \(cell.lblTotal.text)")
            
            if user.credit! < Int(crdItem.creditNumber!)! || user.credit! < Int(crdItem.creditNumber!)!*(selectedTitle) {
                cell.btnStatus.selected = false
            } else {
                cell.btnStatus.selected = true
            }
//            tbvCreditProfile.beginUpdates()
            tbvCreditProfile.reloadData()
//            tbvCreditProfile.endUpdates()
        }
        if pickerViewComponent != nil && pickerViewComponent.hidden == false {
            pickerViewComponent.hidden = true
        }
        
    }
    
    //MARK: ProfileCreditCell Delegate
    
    func chooseQuantity(cell: ProfileCreditCell) {
        currentCell = cell
        currentTbvIndexPathRow = tbvCreditProfile.indexPathForCell(cell)!.row
        if pickerViewComponent == nil {
            pickerViewComponent = PickerViewCustom()
            pickerViewComponent.delegate = self
            pickerViewComponent.pickerView.delegate = self
            pickerViewComponent.pickerView.dataSource = self
            pickerViewComponent.translatesAutoresizingMaskIntoConstraints = false
            let consCenterXPickerView = NSLayoutConstraint(item: pickerViewComponent,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0)
            let consBottomPickerViewToSuperView = NSLayoutConstraint(item: pickerViewComponent,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0)
            
            let consWidthPickerView = NSLayoutConstraint(item: pickerViewComponent,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: DEVICE_SCREEN_WIDTH)
            
            self.view.addSubview(pickerViewComponent)
            self.view.addConstraints([consCenterXPickerView, consBottomPickerViewToSuperView, consWidthPickerView])
        } else if (pickerViewComponent != nil && pickerViewComponent.hidden == true ) {
            pickerViewComponent.hidden = false
//            pickerViewComponent.pickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func getThisItem(item: Credit) {
        print("item credit: \(item.creditNumber)")
    }
    
    // MARK: - Override Method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if pickerViewComponent != nil && pickerViewComponent.hidden == false {
            pickerViewComponent.hidden = true
        }
    }
    
    //MARK: Set content to cell
    
    func setContentToCreditCell(cell:ProfileCreditCell, indexPath:NSIndexPath) {
        
        let creditItem = cell.creditItem
        let imvCreditUrl:String! = CommonFunc.getImgFromAvatar(creditItem.creditImage!)
        CommonFunc.getImageData(imvCreditUrl, imageView: cell.imvCredit)
        var imageAspectRatio:CGFloat = 1
        var newImage:UIImage = UIImage()
        
        if isCompleted == false {
            CommonFunc.downloadObjectWithStringURL(imvCreditUrl, success: { (dataFile, error) -> Void in
                if let image:UIImage = UIImage(data: dataFile!)  {
                    imageAspectRatio = image.size.height / image.size.width
                    newImage = image
                }
                cell.consHeightImvCredit.constant = cell.imvCredit.frame.size.width * imageAspectRatio
                self.isCompleted = true
                Async.main {
                    cell.imvCredit.layoutIfNeeded()
                    cell.imvCredit.image = newImage
                    self.tbvCreditProfile.reloadData()
                }
                }) { (value) -> Void in
            }
        }
        let credit = creditItem.creditNumber!
        let price = creditItem.creditPrice!
        
        if pickerViewComponent == nil {
            creditItem.creditTotal = credit
        }
        cell.lblTotal.text = creditItem.creditTotal
        cell.setTextForLblCreditPrice(credit, price: price)

    }
    
    //MARK: - PickerView Delegate + DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerViewArray[row])
    }
    
    //MARK: UITableView Delegate + DataSource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return creditItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ProfileCreditCell! = tableView.dequeueReusableCellWithIdentifier(profileCreditCell) as? ProfileCreditCell
        cell.delegate = self
        cell.creditItem = creditItems[indexPath.row]
        //        cell.setContentToCreditCell()
        setContentToCreditCell(cell, indexPath:indexPath)
        
        if indexPath.row == self.creditItems.count - 1 && isLast == false {
            apiManager.getCreditItems(page++)
            isRefresh = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: ProfileCreditManagerAPI Delegate
    
    func profileCreditManagerAPIDelegate(sendListCreditData listCredit: ListCredit, isLastPage: Bool) {
        
        self.isLast = isLastPage
        
        if isRefresh == false {
            self.creditItems.removeAll(keepCapacity: false)
        }
        
        self.creditItems.appendContentsOf(listCredit.listCredit!)
        
        if listCredit.listCredit?.count > 0 {
            Async.main {
                self.tbvCreditProfile.reloadData()
            }
        }
        
        isRefresh = false
    }
}
