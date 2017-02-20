//
//  ProfileCreditCell.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/20/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire

protocol ProfileCreditCellDelegate:NSObjectProtocol {
    func chooseQuantity(cell:ProfileCreditCell)
    func getThisItem(item:Credit)
}

class ProfileCreditCell: UITableViewCell {

    //MARK: outlets and variables
    
    @IBOutlet var imvCredit: UIImageView!
    @IBOutlet var lblCreditPrice: UILabel!
    @IBOutlet var vCreditTotal: UIView!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var btnStatus: UIButton!
    @IBOutlet weak var btnQuantity: UIButton!
    
    
    @IBOutlet weak var consHeightImvCredit: NSLayoutConstraint!
    
    var creditItem:Credit! = Credit()
    
    var delegate:ProfileCreditCellDelegate?
    
    //MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblQuantity.layer.cornerRadius = 5
        self.lblQuantity.layer.masksToBounds = true
        
        self.lblQuantity.layer.borderColor = UIColor(red: 182, green: 182, blue: 182).CGColor
        self.lblQuantity.layer.borderWidth = 1
        
        self.imvCredit.layer.borderColor = UIColor(red: 182, green: 182, blue: 182).CGColor
        self.imvCredit.layer.borderWidth = 1
        
        lblTotal.text = String(creditItem.creditPrice)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: "tapToChooseQuantity:")
//        tapGesture.delegate = self
//        tapGesture.cancelsTouchesInView = false
//        lblQuantity.addGestureRecognizer(tapGesture)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: config cell's content
    
    func setContentToCreditCell() {
        let imvCreditUrl:String! = CommonFunc.getImgFromAvatar(creditItem.creditImage!)
        CommonFunc.getImageData(imvCreditUrl, imageView: self.imvCredit)
        var imageAspectRatio:CGFloat = 1
        var newImage:UIImage = UIImage()
        
        CommonFunc.downloadObjectWithStringURL(imvCreditUrl, success: { (dataFile, error) -> Void in
            if let image:UIImage = UIImage(data: dataFile!)  {
                imageAspectRatio = image.size.height / image.size.width
//                print("imageAspectRatio inside\(imageAspectRatio)")
                newImage = image
                self.consHeightImvCredit.constant = self.imvCredit.frame.size.width * imageAspectRatio
                self.imvCredit.layoutIfNeeded()
                self.imvCredit.image = newImage
            }
            }) { (value) -> Void in
                
        }

        let credit = creditItem.creditNumber!
        let price = creditItem.creditPrice!
        
        lblTotal.text = String((AccountManager.sharedInstance.getInfoUser().credit)!)
        setTextForLblCreditPrice(credit, price: price)
        
    }
    
    func setTextForLblCreditPrice(credit:String, price:String) {
        let info: NSMutableAttributedString = NSMutableAttributedString(string: credit, attributes: [NSFontAttributeName:Regular13])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 33, green: 33, blue: 33), range: NSMakeRange(0, info.length))
        
        let price:NSMutableAttributedString = NSMutableAttributedString(string: " ($" + price + ")", attributes: [NSFontAttributeName:Regular13])
        price.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 114, green: 114, blue: 114), range: NSMakeRange(0, price.length))
        info.appendAttributedString(price)
        
        lblCreditPrice.attributedText = info
        
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isKindOfClass(UITableView) {
            return false
        }
        return true
    }
    
    //MARK:UITapGestureRecognizer
//    
//    func tapToChooseQuantity(sender:UIGestureRecognizer) {
//        print("tap gesture")
//        delegate?.chooseQuantity(self)
//    }
    
    //MARK: Action
    @IBAction func getItem(sender: UIButton) {
        delegate?.getThisItem(creditItem)
    }
    
    @IBAction func didTapButton(sender: AnyObject) {
        print("tap gesture")
        delegate?.chooseQuantity(self)
    }
    
  }
