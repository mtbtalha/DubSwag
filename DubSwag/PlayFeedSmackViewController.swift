//
//  PlayFeedSmackViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/16/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayFeedSmackViewController: UIViewController {

    
    @IBOutlet weak var playerView: UIView!
    
    var moviePlayer: MPMoviePlayerController!
    var smashURLString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var smashURL = NSURL(string: smashURLString)
        println("\(smashURL!)")
       moviePlayer = MediaManager.loadMoviePlayer(smashURL!, playerView: playerView)
       moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        //moviePlayer.play()
    }

}
