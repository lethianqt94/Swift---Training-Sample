//
//  File.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/18/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

import Haneke

class PhotoView: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    private var total: Int! = 1
    private var listPhoto: [Photo] = []
    
    var viewWidth:CGFloat = UIScreen().bounds.size.width
    var viewHeight:CGFloat = UIScreen().bounds.size.width
    let kSpaceBetweenPhoto:CGFloat = 1
    
    
    internal func setupViewPhotoWithListPhotoObject(list:[Photo], total: Int!){
        
        self.listPhoto = list
        self.total = total
        
    }
    
    private func setupWithOnePhoto(list:[Photo]){
        let pt = list[0]
        
        let imv = imageView(frame: self.bounds)
        CommonFunc.getImageData(pt.getPhotoUrl(), imageView: imv)
        imv.tag = 0
        self.addSubview(imv)
    }
    
    private func setupWithTwoPhoto(list:[Photo]){
        let pt1 = list[0]
        let pt2 = list[1]
        
        
        let imv1 = imageView(frame: CGRectMake(0, 0, viewWidth/2 - kSpaceBetweenPhoto, viewHeight))
        
        CommonFunc.getImageData(pt1.getPhotoUrl(), imageView: imv1)
        imv1.tag = 0
        self.addSubview(imv1)
        
        let imv2 = imageView(frame: CGRectMake(CGRectGetMaxX(imv1.frame) + kSpaceBetweenPhoto, 0, viewWidth/2, viewHeight/2))
        CommonFunc.getImageData(pt2.getPhotoUrl(), imageView: imv2)
        imv2.tag = 1
        self.addSubview(imv2)
    }
    
    private func setupWithThreePhoto(list:[Photo]){
        let pt1 = list[0]
        let pt2 = list[1]
        let pt3 = list[2]
        
        let imv1 = imageView(frame: CGRectMake(0, 0, viewWidth/2 - kSpaceBetweenPhoto, viewHeight))
        
        CommonFunc.getImageData(pt1.getPhotoUrl(), imageView: imv1)
        imv1.tag = 0
        self.addSubview(imv1)
        
        let imv2 = imageView(frame: CGRectMake(CGRectGetMaxX(imv1.frame) + kSpaceBetweenPhoto, 0, viewWidth/2, viewHeight/2 - kSpaceBetweenPhoto))
        CommonFunc.getImageData(pt2.getPhotoUrl(), imageView: imv2)
        imv2.tag = 1
        self.addSubview(imv2)
        
        let imv3 = imageView(frame: CGRectMake(CGRectGetMaxX(imv1.frame) + kSpaceBetweenPhoto , CGRectGetMaxY(imv2.frame) + kSpaceBetweenPhoto, viewWidth/2 - kSpaceBetweenPhoto, viewHeight/2))
        CommonFunc.getImageData(pt3.getPhotoUrl(), imageView: imv3)
        imv3.tag = 2
        self.addSubview(imv3)
    }
    
    private func setupWithFourPhoto(list:[Photo]){
        let pt1 = list[0]
        let pt2 = list[1]
        let pt3 = list[2]
        let pt4 = list[3]
        
        let imv1 = imageView(frame: CGRectMake(0, 0, viewWidth/2 - kSpaceBetweenPhoto, viewHeight/2 - kSpaceBetweenPhoto))
        
        CommonFunc.getImageData(pt1.getPhotoUrl(), imageView: imv1)
        imv1.tag = 0
        self.addSubview(imv1)
        
        let imv2 = imageView(frame: CGRectMake(CGRectGetMaxX(imv1.frame) + kSpaceBetweenPhoto, 0, viewWidth/2, viewHeight/2 - kSpaceBetweenPhoto))
        CommonFunc.getImageData(pt2.getPhotoUrl(), imageView: imv2)
        imv2.tag = 1
        self.addSubview(imv2)
        
        
        let imv3 = imageView(frame: CGRectMake(0, CGRectGetMaxY(imv2.frame) + kSpaceBetweenPhoto, viewWidth/2 - kSpaceBetweenPhoto, viewHeight/2))
        CommonFunc.getImageData(pt3.getPhotoUrl(), imageView: imv3)
        imv3.tag = 2
        self.addSubview(imv3)
        
        let imv4 = imageView(frame: CGRectMake(CGRectGetMaxX(imv3.frame) + kSpaceBetweenPhoto , CGRectGetMaxY(imv2.frame) + kSpaceBetweenPhoto, viewWidth/2, viewHeight/2))
        CommonFunc.getImageData(pt4.getPhotoUrl(), imageView: imv4)
        imv4.tag = 3
        self.addSubview(imv4)
        
    }
    
    private func setupWithMoreThanFourPhoto(list:[Photo]){
        setupWithFourPhoto(list)
        if let imv4 = self.viewWithTag(3) {
            let lbl = UILabel(frame: imv4.frame)
            lbl.font = Regular24
            lbl.textColor = UIColor.whiteColor()
            lbl.font = Semibold24
            lbl.text = "+\(total - 4)"
            lbl.textAlignment = NSTextAlignment.Center
            lbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            addSubview(lbl)
            bringSubviewToFront(lbl)
        }
    }
    
    private func imageView(frame frame:CGRect) -> UIImageView{
        let imv = UIImageView(frame: frame)
        imv.contentMode = UIViewContentMode.ScaleAspectFill
        imv.clipsToBounds = true
        imv.userInteractionEnabled = false
        return imv
    }
    
    override func drawRect(rect: CGRect) {
        
        if listPhoto.count == 0 {
            return
        }
        
        viewWidth = CGRectGetWidth(rect)
        viewHeight = CGRectGetHeight(rect)
        
        switch(total){
        case 1: setupWithOnePhoto(listPhoto)
        case 2: setupWithTwoPhoto(listPhoto)
        case 3: setupWithThreePhoto(listPhoto)
        case 4: setupWithFourPhoto(listPhoto)
            
        default:
            setupWithMoreThanFourPhoto(listPhoto)
        }
        
    }
    
    
}
