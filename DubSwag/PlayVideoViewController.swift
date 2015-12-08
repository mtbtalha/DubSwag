//
//  PlayVideoViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/7/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayVideoViewController: UIViewController, AVMergerDelegate {

    @IBOutlet weak var playerView: UIView!
    
    var video: UserVideos?
    //var player = Player()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var moviePlayer: MPMoviePlayerController?
    var videoURL: NSURL?
    var progressHUD: MBProgressHUD!
    var downloadedVideoURL: NSURL?
    var uploadUserVideo: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let video = self.video {
            println(video.videoURL)
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            if (uploadUserVideo == true) {
            videoURL = NSURL(string: video.videoURL!)
            } else {
            videoURL = NSURL(fileURLWithPath: video.videoURL!)
            }
            moviePlayer = MediaManager.loadMoviePlayer(videoURL!, playerView: playerView)
            moviePlayer?.controlStyle = MPMovieControlStyle.Embedded
        }
    }

    @IBAction func startSmashingButtonTapped(sender: AnyObject) {
        if let moviePlayer = self.moviePlayer {
            moviePlayer.pause()
        }
        if let videoURL = self.videoURL {
            self.moviePlayer?.pause()
            self.progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.progressHUD.labelText = "Downloading Video File..."
            DataManager.loadFileAsync(videoURL, completion: { (path, error) -> Void in
                if (error == nil){
                   self.downloadedVideoURL = path
                    self.moviePlayer?.pause()
                    if(DataManager.alreadyDownloaded){
                        self.progressHUD.hide(true)
                        Router.showRecordSmashViewController(self, videoURL: path)
                    } else {
                    
                    var merger = AVMerger(videoURL: path)
                    merger.removeAudio()
                    merger.delegate = self
                    DataManager.alreadyDownloaded = true
                    merger.exportVideoAt()
                    }
                }
                else {
                    println(error)
                }
            })
        } else {
            println("ERROR: videoURL isn't right")
        }
    }
   
    
    func exportDidEnd() {
        progressHUD.hide(true)
        Router.showRecordSmashViewController(self, videoURL: self.downloadedVideoURL!)
    }
}
