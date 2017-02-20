//
//  ParentVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/27/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ParentVC: UIViewController {

    var myTitle: String = ""
    var _lableTitle: UILabel?
    var tfSearch: UITextField?
    
    var btnSearch: UIButton?
    
    var rightItem = ItemType.None, centerItem = ItemType.None, lefItem = ItemType.None
    
    enum ItemType{
        case None
        case Title
        case SearchBar
        case Location
        case Back
        case Close
        case Cancel
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(left leftType:ItemType!, center centerType:ItemType!, right rightType:ItemType!){
        self.init(nibName:nil, bundle: nil)
        addItemOnNaviBar(left: leftType, center: centerType, right: rightType)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if ((UIDevice.currentDevice().systemVersion as NSString).floatValue > 7.0){
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if (respondsToSelector("edgesForExtendedLayout")){
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 76, green: 175, blue: 80)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTitleForVC(title:String!, fontText: UIFont){
        _lableTitle?.font = fontText
        myTitle = title
        if centerItem == .Title{
            _lableTitle?.text = title
        }
    }
    
    func addItemOnNaviBar(left leftType:ItemType!, center centerType:ItemType!, right rightType:ItemType!){
        
        if (leftType != ItemType.None){
            lefItem = leftType
            addItemLeft()
        }
        if (centerType != ItemType.None){
            centerItem = centerType
            addItemCenter()
        }
        if (rightType != ItemType.None){
            rightItem = rightType
            addItemRight()
        }
    }
    
    func addItemLeft(){
        let item = createButtonWithType(lefItem)
        
        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        
        if let _ = item.image {
            padding.width = -5
        } else {
            padding.width = 5
        }
        
        
        //self.navigationItem.leftBarButtonItems = [padding,item]
        self.navigationItem.leftBarButtonItem = item
    }
    
    func addItemCenter(){
        switch (centerItem) {
        case .Title:
            setupTitleLabel()
            break
            
        case .SearchBar:
            setupSearchBar()
            break
            
        default:
            break
        }
    }
    
    private func setupTitleLabel() {
        
        _lableTitle = UILabel(frame: CGRectMake(0, 0, 200, 30))
        _lableTitle?.backgroundColor = UIColor.clearColor()
        _lableTitle?.textAlignment = NSTextAlignment.Center
        _lableTitle?.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = _lableTitle
    }
    
    func addItemRight(){
        
        let item = createButtonWithType(rightItem)
        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        if let _ = item.image {
            padding.width = -3
        } else {
            padding.width = 5
        }
        
        //            item.setTitleTextAttributes([NSForegroundColorAttributeName:Constants.kColorDisabled], forState: UIControlState.Disabled)
        
        self.navigationItem.rightBarButtonItems = [padding, item]
    }
    
    private func createButtonWithType(type:ItemType) -> UIBarButtonItem{
        var btn = UIBarButtonItem()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        switch (type) {
        case .Location:
            let image = UIImage(named: "ic_button_location.png")
            btn = createBarButton(image, actionString: "Location")
            
            break
            
        case .Back:
            let image = UIImage(named:"ic_button_back.png")
            btn = createBarButton(image, actionString: "Back")
            
            break
            
        case .Cancel:
            btn = createBarButton("Cancel")
            
            break
            
        case .Close:
            let image = UIImage(named: "ic_button_close.png")
            btn = createBarButton(image, actionString: "Close")
            
            break
            
        default:
            break
        }
        
        return btn
    }
    
    private func createBarButton(image:UIImage?, actionString:String!) -> UIBarButtonItem{
        let str = "btn\(actionString)Tapped"
        
        let btnItem = UIBarButtonItem(image: image, landscapeImagePhone: image, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(str))
        
        return btnItem
    }
    
    private func createBarButton(title:String) -> UIBarButtonItem{
        var actionString = ""
        if (title.characters.count > 0){
            actionString = "btn\(title)Tapped"
        }
        
        let titleString = "ParentVC_\(title)"
        
        let btnItem = UIBarButtonItem(title: titleString, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(actionString))
        btnItem.setTitleTextAttributes([NSFontAttributeName: Regular16], forState: UIControlState.Normal)
        
        return btnItem
    }
    
    
    private func setupSearchBar(){
        btnSearch = UIButton()
        tfSearch = UITextField(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 28))
        
        if let tfSearch = tfSearch {
            tfSearch.layer.cornerRadius = 4
            tfSearch.clipsToBounds = true
            tfSearch.backgroundColor = UIColor(red: 53, green: 133, blue: 56)
            tfSearch.textColor = UIColor.whiteColor()
            tfSearch.font = Regular13
            
            let paddingView = UIView(frame: CGRectMake(0, 0, 16, tfSearch.frame.height))
            tfSearch.leftView = paddingView
            tfSearch.leftViewMode = UITextFieldViewMode.Always
            
            if let btnSearch = btnSearch {
                btnSearch.setTitle("Search", forState: UIControlState.Normal)
                btnSearch.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                btnSearch.setImage(UIImage(named: "ic_search_profilevc.png"), forState: UIControlState.Normal)
                btnSearch.titleLabel?.font = Semibold14
                btnSearch.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                btnSearch.sizeToFit()
                btnSearch.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                btnSearch.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
                btnSearch.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
                btnSearch.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin
                btnSearch.addTarget(self, action: "btnSearchTapped", forControlEvents: UIControlEvents.TouchUpInside)
                
                btnSearch.frame.size.width = 110
                btnSearch.frame.size.height = 28
                
                btnSearch.translatesAutoresizingMaskIntoConstraints = false
                
                let consCenterYButtonSearch = NSLayoutConstraint(item: btnSearch,
                                                          attribute: .CenterY,
                                                          relatedBy: .Equal,
                                                             toItem: tfSearch,
                                                          attribute: .CenterY,
                                                         multiplier: 1,
                                                           constant: 0)
                
                let consCenterXButtonSearch = NSLayoutConstraint(item: btnSearch,
                                                          attribute: .CenterX,
                                                          relatedBy: .Equal,
                                                             toItem: tfSearch,
                                                          attribute: .CenterX,
                                                         multiplier: 1,
                                                           constant: 0)
                
                tfSearch.addSubview(btnSearch)
                tfSearch.addConstraints([consCenterXButtonSearch, consCenterYButtonSearch])
                
                self.navigationItem.titleView =  tfSearch
            }
        }
    }
    
    //MARK: - action
    func btnBackTapped(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func btnLocationTapped(){
        print("location")
    }
    
    func btnCloseTapped(){
        print("close")
    }
    
    func btnCancelTapped(){
        print("cancel")
    }
    
    func btnSearchTapped(){
        tfSearch?.becomeFirstResponder()
        btnSearch?.hidden = true
    }

}
