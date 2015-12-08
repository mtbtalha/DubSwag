//
//  MediaManager.swift
//  DubSwag
//
//  Created by Talha Babar on 8/10/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaManager: NSObject {
   
    static func loadMoviePlayer(moviePath: NSURL, playerView: UIView) -> MPMoviePlayerController {
       var moviePlayer = MPMoviePlayerController(contentURL: moviePath)
        
        moviePlayer.view.hidden = false
        moviePlayer.view.frame = CGRectMake(0, 0, playerView.frame.size.width, playerView.frame.size.height)
        moviePlayer.view.backgroundColor = UIColor.clearColor()
        moviePlayer.scalingMode = MPMovieScalingMode.AspectFit
        moviePlayer.fullscreen = false
        moviePlayer.prepareToPlay()
        moviePlayer.readyForDisplay
        moviePlayer.controlStyle = MPMovieControlStyle.None
        moviePlayer.shouldAutoplay = false
        playerView.addSubview(moviePlayer.view)
        return moviePlayer
    }

    static func getVideoThumbnail(url: NSURL) -> NSData? {
        var err: NSError? = nil
        let asset = AVURLAsset(URL: url, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        let cgImage = imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil, error: &err)
        // !! check the error before proceeding
        if (err != nil) {
            //
            //        let imageView = UIImageView(image: uiImage)
            println("ERROR: Can't make video Thumbnail")
            return nil
        } else {
            let uiImage = UIImage(CGImage: cgImage)
            var data = UIImagePNGRepresentation(uiImage)
            return data
        }
    }
}
