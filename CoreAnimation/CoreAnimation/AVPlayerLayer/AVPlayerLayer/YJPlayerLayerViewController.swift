//
//  YJPlayerLayerViewController.swift
//  AVPlayerLayer
//
//  Created by ddn on 16/8/16.
//  Copyright © 2016年 张永俊. All rights reserved.
//
/*
 AVPlayerLayer还有一些附加属性：
 
 videoGravity设置视频显示的缩放行为。
 readyForDisplay检测是否准备好播放视频。
 另一方面，AVPlayer也有不少附加属性和方法，有一个值得注意的是rate属性，对于0到1之间的播放速率，0代表暂停，1代表常速播放（1x）。
 
 不过rate属性的设置是与播放行为联动的，也就是说调用pause()方法和把rate设为0是等价的，调用play()与把rate设为1也一样。
 
 那快进、慢动作和反向播放呢？交给AVPlayerLayer把。rate大于1时会令播放器以相应倍速进行播放，例如rate设为2就是二倍速。
 
 如你所想，rate为负时会让播放器以相应倍速反向播放。
 
 然而，在以非常规速率播放之前，AVPlayerItem上会调用适当方法，验证是否能够以相应速率进行播放：
 
 canPlayFastForward()对应大于1
 canPlaySlowForward()对应0到1之间
 canPlayReverse()对应-1
 canPlaySlowReverse()对应-1到0之间
 canPlayFastReverse()对应小于-1
 */
import UIKit
import AVFoundation

class YJPlayerLayerViewController: UIViewController {
    @IBOutlet weak var someView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    var player : AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        someView.bounds = view.bounds
        
        let playerLayer = AVPlayerLayer()
        playerLayer.frame = someView.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResize
        
        
        let url = Bundle.main.url(forResource: "colorfulStreak", withExtension: "m4v")
        player = AVPlayer(url: url!)
        
        
        player!.actionAtItemEnd = .none
        playerLayer.player = player
        someView.layer.addSublayer(playerLayer)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReachEndNotificationHandler(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player!.currentItem)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if playButton.titleLabel?.text == "Play" {
            player!.play()
            playButton.setTitle("Pause", for: .normal)
        } else {
            player!.pause()
            playButton.setTitle("Play", for: .normal)
        }
        
//        updatePlayButtonTitle()
//        updateRateSegmentedControl()
    }
    
    
    func playerDidReachEndNotificationHandler(_ notification: Notification) {
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: kCMTimeZero)
    }


}
