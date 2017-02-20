//
//  PickerViewCustom.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/29/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

let DEVICE_SCREEN_WIDTH =    UIScreen.mainScreen().bounds.size.width
let DEVICE_SCREEN_HEIGHT =    UIScreen.mainScreen().bounds.size.height

protocol PickerViewCustomDelegate:class{
    func hidePickerView(pickerViewCustomDelegate:PickerViewCustomDelegate) ->Void
    func tapToDone(pickerViewCustomDelegate:PickerViewCustomDelegate) ->Void
}

class PickerViewCustom: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: Outlets + variables
    
    @IBOutlet weak var view: PickerViewCustom!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var viewWidth:CGFloat = DEVICE_SCREEN_WIDTH
    var viewHeight:CGFloat = DEVICE_SCREEN_HEIGHT
    
    var delegate:PickerViewCustomDelegate?
    
    //MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func initSubviews() {
        if let nibsView = NSBundle.mainBundle().loadNibNamed("PickerViewCustom", owner: self, options: nil) as? [UIView] {
            let nibRoot = nibsView[0]
            self.addSubview(nibRoot)
            nibRoot.frame = self.bounds
        }
    }
    
    override func drawRect(rect: CGRect) {
        viewWidth = CGRectGetWidth(rect)
        viewHeight = CGRectGetHeight(rect)
    }
    
    //MARK: Actions
    
    @IBAction func tapToCancel(sender: UIButton) {
        delegate?.hidePickerView(delegate!)
    }
    
    @IBAction func tapToDone(sender: UIButton) {
        delegate?.tapToDone(delegate!)
    }
    
    
}
