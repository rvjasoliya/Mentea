//
//  VideoViewController.swift
//  T-Notebook_Client
//
//  Created by Apple on 30/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

import AVFoundation

import FirebaseStorage

import AVKit

import AVFoundation



class VideoViewController: UIViewController, AVPlayerViewControllerDelegate {

    
    @IBOutlet weak var videoView: VideoView!

    var videoUrl = ""

    var playerLayer: AVPlayerLayer?

    var player: AVPlayer?

    var isLoop: Bool = false



    override func viewDidLoad() {

        super.viewDidLoad()

        setLeftBarButton()

        print(videoUrl)

        //videoView.configure(url: videoUrl)

        //videoView.isLoop = false

        //videoView.play()

        // Do any additional setup after loading the view.

        //loadVideo()

        videoPlay(url: videoUrl)
        setLeftBarButton()

    }
    
    func setLeftBarButton() {
              let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named :"back_white1"), style: .plain, target: self, action: #selector(backClicked(_:)))
        //leftBarButton.plainView.frame = CGRect.init(x: 10, y: 10, width: 20, height: 20)
              leftBarButton.tintColor = UIColor.white
              self.navigationItem.leftBarButtonItem = leftBarButton
          }

    

    func videoPlayy(url: String){

        if let videoURL = URL(string: url) {

            let playerController = AVPlayerViewController()

                   playerController.delegate = self

            

            player = AVPlayer(url: videoURL)

            let playerLayer = AVPlayerLayer(player: player)

            playerLayer.frame = self.view.frame

            let playerViewController = AVPlayerViewController()

            playerViewController.player = player

            //player.addChild(playerViewController)

            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect

            self.addChild(playerController)

            self.view.addSubview(playerController.view)

            playerController.view.frame = self.view.frame

//            if let playerLayer = self.playerLayer {

//

//                self.addSublayer(playerLayer)

//            }

            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)

            player?.play()

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

    

    func videoPlay(url: String)

    {

        

        let playerController = AVPlayerViewController()

        playerController.delegate = self



        if let videoURL = URL(string: url) {



        let player = AVPlayer(url: videoURL)

        playerController.player = player

            self.addChild(playerController)

        self.view.addSubview(playerController.view)

        playerController.view.frame = self.view.frame



        player.play()

        }



    }

    

    func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController){

        print("playerViewControllerWillStartPictureInPicture")

    }



    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController)

    {

        print("playerViewControllerDidStartPictureInPicture")



    }

    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error)

    {

        print("failedToStartPictureInPictureWithError")

    }

    func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController)

    {

        print("playerViewControllerWillStopPictureInPicture")

    }

    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController)

    {

        print("playerViewControllerDidStopPictureInPicture")

    }

    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool

    {

        print("playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart")

        return true

    }

    

    func loadVideo(){

        Storage.storage().reference(forURL: videoUrl).getMetadata { (metadata, error) in

            if error != nil{

                print("error getting metadata")

            } else {

                let downloadUrl = metadata?.path

                print(downloadUrl)

                

                if downloadUrl != nil{

                  

                    print("downloadUrl obtained and set")

                }

            }

        }

    }


    

    

    @IBAction func backClicked(_ sender: UIButton) {

        _ = self.navigationController?.popViewController(animated: true)

    }



    /*

    // MARK: - Navigation



    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Get the new view controller using segue.destination.

        // Pass the selected object to the new view controller.

    }

    */



}
