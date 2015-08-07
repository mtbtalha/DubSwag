//
//  PlayVideoViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/7/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
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
        }
    }

    @IBAction func startSmashingButtonTapped(sender: AnyObject) {
        if let moviePlayer = self.moviePlayer {
            moviePlayer.stop()
        }
        Router.showRecordSmashViewController(self)
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
