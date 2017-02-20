//
//  TriggerCellManagerFlow.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import UIKit

class TriggerCellManagerFlow:NSObject {
    
    //Outlets +  Variables
    
    weak var navi:UINavigationController?
    
    weak var feed: Feed?
    
    init(navi:UINavigationController?){
        self.navi = navi
        super.init()
    }
    
    
    func goToPhotoDetailsVC(photo:Photo) {
        let photoDetailsVC = PhotoDetailVC()
        photoDetailsVC.photo = photo
        photoDetailsVC.hidesBottomBarWhenPushed = true
        self.navi?.pushViewController(photoDetailsVC, animated: true)
        
    }
    
    
    func goToAlbumDetailsVC(album:Album) {
        let photoAlbumVC = PhotoAlbumVC()
        photoAlbumVC.album = album
        self.navi?.pushViewController(photoAlbumVC, animated: true)
    }
    
    func goToArticleDetailsVC(articleId:String) {
        let articleVC = ArticleDetailVC()
        articleVC.articleId = articleId
        self.navi?.pushViewController(articleVC, animated: true)
    }
    
    func goToVideoDetailsVC(videoId:String) {
        let videoVC = VideoViewerVC()
        videoVC.videoId = videoId
        videoVC.hidesBottomBarWhenPushed = true
        self.navi?.pushViewController(videoVC, animated: true)
    }
    
}