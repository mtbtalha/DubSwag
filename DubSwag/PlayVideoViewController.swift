//
//  PlayVideoViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/7/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
//import Player
import MediaPlayer

class PlayVideoViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    
    var video: UserVideos?
    //var player = Player()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var moviePlayer: MPMoviePlayerController?
    var videoURL: NSURL?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let video = self.video {
            println(video.videoURL)
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            videoURL = NSURL(string: video.videoURL!)
            loadMoviePlayer(videoURL!)
            
//            self.player.view.frame = self.playerView.bounds
//            
//            self.addChildViewController(self.player)
//            self.playerView.addSubview(self.player.view)
//            self.player.didMoveToParentViewController(self)
//            self.player.path = video.videoURL!
        }
    }

    @IBAction func startSmashingButtonTapped(sender: AnyObject) {
//         self.player.fillMode = AVLayerVideoGravityResizeAspect
//         self.player.playFromBeginning()
    }
   
    
    func loadMoviePlayer(moviePath: NSURL) {
        self.moviePlayer = MPMoviePlayerController(contentURL: moviePath)
        
        self.moviePlayer!.view.hidden = false
        self.moviePlayer!.view.frame = CGRectMake(0, 0, playerView.frame.size.width, playerView.frame.size.height)
        self.moviePlayer!.view.backgroundColor = UIColor.clearColor()
        self.moviePlayer!.scalingMode = MPMovieScalingMode.AspectFit
        moviePlayer!.fullscreen = false
        moviePlayer!.prepareToPlay()
        moviePlayer!.readyForDisplay
        moviePlayer!.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer!.play()
        moviePlayer!.shouldAutoplay = true
        playerView.addSubview(moviePlayer!.view)
//        activityIndicator.hidden = true
    }
}
