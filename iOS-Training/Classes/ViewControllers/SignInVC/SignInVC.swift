//
//  SignInVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignInVC: UIViewController, UITextFieldDelegate, AccountManagerDelegate {
    
    // MARK: - Variables
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    var screenHeight: CGFloat!
    var accountManager: AccountManager?
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var consBottomViewCenterToSelfView: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        accountManager = AccountManager()
        
        tfEmail.delegate = self
        tfPassword.delegate = self
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        self.navigationController?.navigationBarHidden = true
        
        tfEmail.layer.cornerRadius = 4
        tfEmail.clipsToBounds = true
        tfEmail.attributedPlaceholder = CommonFunc.getAttributePlaceholder("Email")
        
        tfPassword.layer.cornerRadius = 4
        tfPassword.clipsToBounds = true
        tfPassword.attributedPlaceholder = CommonFunc.getAttributePlaceholder("Password")
        
        btnSignIn.layer.cornerRadius = 4
        btnSignIn.clipsToBounds = true
        
        lblSignUp.attributedText = CommonFunc.getAttributeStringSignUp()
        lblSignUp.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: "tapToSignUp")
        lblSignUp.addGestureRecognizer(tapGesture)
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 16, self.tfEmail.frame.height))
        tfEmail.leftView = paddingView
        tfEmail.leftViewMode = UITextFieldViewMode.Always
        
        let paddingView2 = UIView(frame: CGRectMake(0, 0, 16, self.tfPassword.frame.height))
        tfPassword.leftView = paddingView2
        tfPassword.leftViewMode = UITextFieldViewMode.Always
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let rect = UIScreen.mainScreen().bounds
        screenHeight = rect.size.height
        consBottomViewCenterToSelfView.constant = (screenHeight / 2) - 117
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Override Method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func tapToHomeVC(sender: AnyObject) {
        CommonFunc.showIndicator(title: "Loading...", view: self.view)
        
        if let accountManager = accountManager {
            accountManager.delegate = self
//            accountManager.requestLogin(email: tfEmail.text!, password: tfPassword.text!)
            accountManager.requestLogin(email: "011@gmail.com", password: "111111")
        }
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
        return true
    }
    
    // MARK: - AccountManagerDelegate Method
    
    func accountManager(user user: Users) {
        if user.code == 200 {
            let user = AccountManager.sharedInstance.getInfoUser()
            userDefault.setObject(user.accessToken, forKey: "accesstoken")
            userDefault.setObject(user.email, forKey: "email")
            userDefault.setObject(tfPassword.text, forKey: "password")
            userDefault.synchronize()
            
            let signInFlow = SignInVCManagerFlow()
            signInFlow.pushToHomeVC()
        } else if user.code == 401 {
            CommonFunc.hideIndicator(self.view)
            let alert = UIAlertController(title: "NOTICE",
                message: "Username or Password is not correct",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            CommonFunc.hideIndicator(self.view)
            let alert = UIAlertController(title: "NOTICE",
                message: "Error not found",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Custom Methods
    
    func tapToSignUp() {
        print("Tap To Sign Up")
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        if consBottomViewCenterToSelfView.constant <= (screenHeight / 2) - 117 {
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut , animations: {
                self.consBottomViewCenterToSelfView.constant = userInfo.height
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if consBottomViewCenterToSelfView.constant > (screenHeight / 2) - 117 {
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut , animations: {
                self.consBottomViewCenterToSelfView.constant = (self.screenHeight / 2) - 117
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
}
