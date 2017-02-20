//
//  VideoViewerVC.swift
//  iOS-Training
//
//  Created by Le Thi An on 2/4/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVKit
import AVFoundation

class VideoViewerVC: UIViewController, VideoViewerManagerAPIDelegate {
    
    //MARK: Outlet + Variables
    
    var videoId:String = ""
    var video:Video?
    
    @IBOutlet weak var viewContaintButton: UIView!
    @IBOutlet weak var viewContaintControl: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var btnControl: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblView: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnControl2: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var imvBg: UIImageView!
    
    
    var progress: MBProgressHUD? = nil
    var apiManager:VideoViewerManagerAPI?
    
    var playerViewController = AVPlayerViewController()
    var player = AVPlayer()
    
    var isPlaying: Bool = true
    var vidLength: Double = 0
    var playbackTimeObserver:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("video id===: \(videoId)")
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        
        progress = MBProgressHUD(view: self.view)
        self.view.addSubview(progress!)
        
        apiManager = VideoViewerManagerAPI()
        apiManager?.progress = progress
        apiManager?.delegate = self
        
        apiManager?.getVideoDetails(videoId)
    }
    
    deinit {
        print("deinit")
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            print("Landscape")
            viewContaintButton.alpha = 0
            viewContaintControl.alpha = 0
            imvBg.alpha = 0
        } else {
            print("Portrait")
            viewContaintButton.alpha = 1
            viewContaintControl.alpha = 1
            imvBg.alpha = 1
        }
    }
    
    
    
    //MARK: set content to view
    
    func resetContent() {
        lblView.text = ""
        lblInfo.text = ""
    }
    
    func setContentToView(vid:Video) {
        slider.setThumbImage(UIImage(named:"ic_slider_thumb_video.png"), forState:UIControlState.Normal)
        btnLike.selected = vid.isLiked!
        lblTime.text = getTotalTime(vid.vidLength!)
        btnLike.selected = vid.isLiked!
        lblView.attributedText = getAttributeString((video?.vidView!)!, action: "View")
        lblInfo.attributedText = setInfoLabel((video?.vidLike)!, cmt: (video?.vidComment)!, share: (video?.vidShare)!)
    }
    
    //MARK: support functions
    
    func setInfoLabel(like:Int, cmt:Int, share:Int)->NSAttributedString {
        
        let stringLike:NSAttributedString = getAttributeString(like, action: "Like")
        let stringComment:NSAttributedString = getAttributeString(cmt, action: "Comment")
        let stringShare:NSAttributedString = getAttributeString(share, action: "Share")
        
        let tmpStr : NSMutableAttributedString = stringLike.mutableCopy() as! NSMutableAttributedString
        tmpStr.appendAttributedString(stringComment)
        tmpStr.appendAttributedString(stringShare)
        
        return tmpStr.copy() as! NSAttributedString
    }
    
    func getAttributeString(number:Int, action:String)->NSMutableAttributedString {
        
        let stringAction = number > 1 ? "\(action)s" : "\(action)"
        
        let info: NSMutableAttributedString = NSMutableAttributedString(string: String(number), attributes: [NSFontAttributeName: Regular12])
        info.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(),
            range: NSRange(location: 0, length: info.length))
        
        let string: NSMutableAttributedString = NSMutableAttributedString(string: " \(stringAction) ", attributes: [NSFontAttributeName: Regular12])
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "#B6B6B6"),
            range: NSRange(location: 0, length: string.length))
        
        info.appendAttributedString(string)
        return info
    }
    
    func setupLayoutForViewVideo(view:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let consTopViewToSuperView = NSLayoutConstraint(item: view,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.viewVideo,
            attribute: .Top,
            multiplier: 1,
            constant: 0)
        let consBottomViewToSuperView = NSLayoutConstraint(item: view,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.viewVideo,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0)
        let consLeftViewToSuperView = NSLayoutConstraint(item: view,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.viewVideo,
            attribute: .Left,
            multiplier: 1,
            constant: 0)
        let consRightViewToSuperView = NSLayoutConstraint(item: view,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self.viewVideo,
            attribute: .Right,
            multiplier: 1,
            constant: 0)
        self.viewVideo.addSubview(view)
        self.viewVideo.addConstraints([consTopViewToSuperView,consBottomViewToSuperView,consLeftViewToSuperView,consRightViewToSuperView])
    }
    
    func getTotalTime(dateString:String)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.dateFromString(dateString)
        if date != nil {
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Hour, .Minute, .Second], fromDate: date!)
            
            let hour = comp.hour > 9 ? "\(comp.hour)" : "0\(comp.hour)"
            let minute = comp.minute > 9 ? "\(comp.minute)" : "0\(comp.minute)"
            let second = comp.second > 9 ? "\(comp.second)" : "0\(comp.second)"
            
            if comp.hour > 0 {
                return "\(hour):\(minute):\(second)"
            } else {
                return "\(minute):\(second)"
            }
        } else {
            return "00:00"
        }
    }
    
    func playYoutubeVideo(videoIdentifier: String?) {
        
        XCDYouTubeClient.defaultClient().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: NSError?) in
            if let streamURL = (video?.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ??
                video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ??
                video?.streamURLs[XCDYouTubeVideoQuality.Medium360.rawValue] ??
                video?.streamURLs[XCDYouTubeVideoQuality.Small240.rawValue]) {
                    self.player = AVPlayer(URL: streamURL)
                    playerViewController?.player = self.player
                    playerViewController?.showsPlaybackControls = false
                    self.setupLayoutForViewVideo((playerViewController?.view)!)
                    self.player.play()
                    self.addObserver()
            } else {
                print("bi chi day roi!!!")
            }
        }
        
    }
    
    func youtubeIDFromYoutubeURL(youtubeURL: NSURL) -> String? {
        if let
            youtubeHost = youtubeURL.host,
            youtubePathComponents = youtubeURL.pathComponents {
                let youtubeAbsoluteString = youtubeURL.absoluteString
                if youtubeHost == "youtu.be" as String? {
                    return youtubePathComponents[1]
                } else if youtubeAbsoluteString.rangeOfString("www.youtube.com/embed") != nil {
                    return youtubePathComponents[2]
                } else if youtubeHost == "youtube.googleapis.com" ||
                    youtubeURL.pathComponents!.first == "www.youtube.com" as String? {
                        return youtubePathComponents[2]
                } else if let searchParam = youtubeURL.queryStringComponents()["v"] as? String {
                        return searchParam
                }
        }
        return nil
    }
    
    func updateTime(second:Double)->String{
        if second.isNaN{
            return "00:00"
        } else {
            let minute_ = abs(Int((second / 60) % 60))
            let second_ = abs(Int(second % 60))
            let hour_   = abs(Int(second / 60 / 60) % 60)
            
            let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
            let second = second_ > 9 ? "\(second_)" : "0\(second_)"
            let hour   = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
            
            if hour_ > 0 {
                return "\(hour):\(minute):\(second)"
            } else {
                return "\(minute):\(second)"
            }
        }
        
    }
    
    //MARK: Video Playback
    
    func addObserver(){
        self.player.currentItem!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        self.player.currentItem!.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.New, context: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        print("keyPath: \(keyPath)")
        let playerItem:AVPlayerItem = object as! AVPlayerItem
        if keyPath == "status" {
            if playerItem.status ==  AVPlayerItemStatus.ReadyToPlay{
                print("AVPlayerItemStatusReadyToPlay")
            } else if playerItem.status == AVPlayerItemStatus.Failed {
                print("AVPlayerItemStatusFailed")
            }
        } else if keyPath == "loadedTimeRanges" {
            let currentTime = playerItem.currentTime().seconds
            let totalDuration = playerItem.duration.seconds
//            print("value: \(Float(currentTime/totalDuration))")
            self.monitoringPlayback(player.currentItem!)
            self.slider.setValue(Float(currentTime/totalDuration), animated: false)
        }
    }
    
    func monitoringPlayback(playerItem:AVPlayerItem) {
        self.playbackTimeObserver = self.player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: nil, usingBlock: { (time) -> Void in
            let currentSecond:Double = playerItem.currentTime().seconds
            self.updateVideoSlider(currentSecond)
            let timeString = self.updateTime(playerItem.duration.seconds - currentSecond)
//            print("time string: \(timeString)")
            self.lblTime.text = timeString
        })
    }
    
    func updateVideoSlider(currentSecond:Double) {
        let value = currentSecond/(player.currentItem?.duration.seconds)!
        slider.setValue(Float(value), animated: true)
    }
    
    func moviePlayDidEnd(noti:NSNotification)->Void {
        btnControl2.setImage(UIImage(named:"ic_vid_play.png"), forState: .Normal)
        slider.value = 0.0
        isPlaying = false
        player.seekToTime(CMTimeMakeWithSeconds(0.0, player.currentTime().timescale))
        lblTime.text = updateTime((self.player.currentItem?.duration.seconds)!)
    }
    
    //MARK: VideoViewerManagerAPIDelegate
    
    func videoViewerManagerAPIDelegate(sendVideoDataToVC vid: Video) {
        video = vid
        Async.main {
            self.setContentToView(self.video!)
            var vidIdentifier = ""
            if let vidYoutubeUrl = self.video!.vidYoutubeUrl {
                vidIdentifier = self.youtubeIDFromYoutubeURL(NSURL(string: vidYoutubeUrl)!)!
                self.playYoutubeVideo(vidIdentifier)
            }
        }
    }

    //MARK: Actions
    
    @IBAction func goBack(sender: UIButton) {
        if isPlaying == true {
            isPlaying = false
            self.player.seekToTime(CMTimeMake(0, 1))
            self.player.pause()
            btnControl2.setImage(UIImage(named:"ic_vid_play.png"), forState: .Normal)
        }
        
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        self.navigationController?.popViewControllerAnimated(true)
        UIApplication.sharedApplication().statusBarHidden = false
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func doLikeVideo(sender: UIButton) {
        if video?.isLiked == false {
            TriggerCellManagerAPI.doLikeObject(ResourceType.Video, objId: videoId)
            btnLike.selected = true
            lblInfo.attributedText = setInfoLabel((video?.vidLike)! + 1, cmt: (video?.vidComment)!, share: (video?.vidShare)!)
        } else {
            print("like roi...")
            btnLike.selected = false
            lblInfo.attributedText = setInfoLabel((video?.vidLike)! - 1, cmt: (video?.vidComment)!, share: (video?.vidShare)!)
        }
    }
    
    @IBAction func tapActionVideo(sender: UIButton) {
        if isPlaying == true {
            
            isPlaying = false
            self.player.pause()
            btnControl2.setImage(UIImage(named:"ic_vid_play.png"), forState: .Normal)
            
        } else {
            
            isPlaying = true
            self.player.play()
            btnControl2.setImage(UIImage(named:"ic_vid_stop.png"), forState: .Normal)
            
        }

    }
    
    @IBAction func tapFakeBtnAction(sender: UIButton) {
        tapActionVideo(sender)
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let newtime:CMTime = CMTimeMakeWithSeconds(Double(slider.value) * (player.currentItem?.duration.seconds)!, player.currentTime().timescale)
        player.seekToTime(newtime)
        let restTime = (player.currentItem?.duration.seconds)! - (player.currentItem?.currentTime().seconds)!
        lblTime.text = updateTime(restTime)
    }
    
}
