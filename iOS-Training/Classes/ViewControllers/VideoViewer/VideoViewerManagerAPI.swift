//
//  VideoViewerManagerAPI.swift
//  iOS-Training
//
//  Created by Le Thi An on 2/5/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD

protocol VideoViewerManagerAPIDelegate:NSObjectProtocol {
    
    func videoViewerManagerAPIDelegate(sendVideoDataToVC vid:Video) -> Void
}

class VideoViewerManagerAPI {
    
    //MARK: Variables
    var progress:MBProgressHUD?
    weak var delegate:VideoViewerManagerAPIDelegate?
    
    //MARK: Functions
    func getVideoDetails(videoId:String) {
        Async.main{
            self.progress?.show(true)
        }
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = API_VIDEO + videoId
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let itemVideo:ItemVideo! = Mapper<ItemVideo>().map(response.result.value!)
                    //                    print(response.result.value!)
                    if itemVideo.video != nil {
                        self.delegate?.videoViewerManagerAPIDelegate(sendVideoDataToVC: itemVideo.video!)
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        Async.main {
            if self.progress?.alpha == 1 {
                self.progress?.hide(true)
            }
        }
    }

    
}