//
//  PhotoAlbumManageFlow.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class PhotoAlbumManageFlow: NSObject {
    
    // MARK: - Variables
    
    weak var navi:UINavigationController?
    
    // MARK: - Init Method
    
    init(navi:UINavigationController?){
        self.navi = navi
        super.init()
    }
    
    // MARK: - Custom Method
    
    func goToPhotoDetailsVC(photo:Photo, heightPhoto: CGFloat) {
        let photoDetailsVC = PhotoDetailVC()
        photoDetailsVC.photo = photo
        photoDetailsVC.heightImgPhoto = heightPhoto
        photoDetailsVC.hidesBottomBarWhenPushed = true
        self.navi?.pushViewController(photoDetailsVC, animated: true)
    }
}
