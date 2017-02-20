//
//  ButtonCell.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/21/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Variables
    
    var stringImgCollection: String?
    var stringTitleCollection: String?
    var user: Users?
    var arrStat = NSMutableArray()
    var arrTitleStat: NSMutableArray?
    var dicCollection: NSMutableDictionary?
    
    // MARK: - Outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibCellCollection = UINib.init(nibName: "InfoCollectionCell", bundle: nil)
        collectionView.registerNib(nibCellCollection, forCellWithReuseIdentifier: "InfoCollectionCell")
        
        arrTitleStat = ["Topics", "Followings", "Friends", "Collections", "Articles", "Photos", "Links", "Videos"]
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStat.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InfoCollectionCell", forIndexPath: indexPath) as! InfoCollectionCell
        cell.lblNumber.text = String(arrStat[indexPath.row])
        if let arrTitleStat = arrTitleStat {
            cell.lblTitleCollection.text = String(arrTitleStat[indexPath.row])
        }
        switch (indexPath.row) {
        case 0:
            if let imgString = dicCollection?.objectForKey("Topic") as? String {
                CommonFunc.getImageData(imgString, imageView: cell.imgCollection)
            }
        case 1:
            if let imgString = dicCollection?.objectForKey("Following") as? String {
                CommonFunc.getImageData(imgString, imageView: cell.imgCollection)
            }
        case 2:
            if let imgString = dicCollection?.objectForKey("Friend") as? String {
                CommonFunc.getImageData(imgString, imageView: cell.imgCollection)
            }
        case 3:
            if let imgString = dicCollection?.objectForKey("Collection") as? String {
                CommonFunc.getImageData(imgString, imageView: cell.imgCollection)
            }
        case 5:
            if let imgString = dicCollection?.objectForKey("Photo") as? String {
                CommonFunc.getImageData(imgString, imageView: cell.imgCollection)
            }
        case 6:
            if let imgString = dicCollection?.objectForKey("Link") as? String {
                CommonFunc.getImageData(imgString, imageView: cell.imgCollection)
            }
        default:
            cell.imgCollection.image = UIImage(named: "img_no_useravatar.png")
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate Methods
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 98, height: 65)
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
