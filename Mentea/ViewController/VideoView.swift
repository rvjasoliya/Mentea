//
//  File.swift
//  T-Notebook_Client
//
//  Created by Apple on 30/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(url: String) {
        
        
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            //player.addChild(playerViewController)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            if let playerLayer = self.playerLayer {
                
                layer.addSublayer(playerLayer)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    func play() {
        if #available(iOS 10.0, *) {
            if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
                player?.play()
            }
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 10.0, *) {
            if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
                player?.play()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}
