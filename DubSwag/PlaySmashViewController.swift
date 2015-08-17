//
//  PlaySmashViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/12/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaySmashViewController: UIViewController {

    @IBOutlet weak var playVideoView: UIView!
    @IBOutlet weak var fbShareButton: FBSDKShareButton!
    @IBOutlet weak var saveToLibrarySwitch: UISwitch!
    
    
    var smashURL: NSURL!
    var moviePlayer: MPMoviePlayerController?
    var uploadedSmashURL: String!
    var uploadedThumbnailURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(smashURL)
        moviePlayer = MediaManager.loadMoviePlayer(smashURL, playerView: playVideoView)
        var videoToShare = FBSDKShareVideo(videoURL: self.smashURL!)
        var content = FBSDKShareVideoContent()
        content.video = videoToShare
        fbShareButton.shareContent = content
        moviePlayer?.play()
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Saving On Server..."
        if (saveToLibrarySwitch.on) {
        AVMerger.saveToLibrary(self, outputURL: self.smashURL)
        }
        let thumbnailData = MediaManager.getVideoThumbnail(self.smashURL)
        var thumbnailName = self.getThumbnailName()
        let smashURLString = smashURL.path
        var smashData = NSFileManager().contentsAtPath(smashURLString!)
        var smashName = self.getSmashName()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            ParseManager.uploadFile(thumbnailData!, fileName: thumbnailName, success: { (file) -> () in
                var imageFile = file["File"] as! PFFile
                self.uploadedThumbnailURL = imageFile.url
                println(imageFile.url)
            })
            ParseManager.uploadFile(smashData!, fileName: smashName, success: { (file) -> () in
            var videoFile = file["File"] as! PFFile
            self.uploadedSmashURL = videoFile.url
            println(videoFile.url)
            var user = PFUser.currentUser()
                if user != nil {
                    ParseManager.uploadSmashes(user!.objectId!, smashURL: self.uploadedSmashURL, thumbnailURL: self.uploadedThumbnailURL!, smashName: smashName)
                    println("Smash Uploaded")
                    progressHUD.hide(true)
                    Router.showSelectVideoFromViewController(self)
                } else {
                    println("NO User")
                }
                })
            
            
        }
    }
    
    @IBAction func twitterShare(sender: AnyObject) {
        let textToShare = "Swift is awesome!  Check out this website about it!"
            if let urlToShare = NSURL(string: "http://files.parsetfss.com/c085d563-3d69-462e-b6fa-ea084d569daa/tfss-eb8f52f8-b7d5-4418-a080-6ecc87a4ddac-video.mov")
            {
                let objectsToShare = [textToShare, urlToShare]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
    }
    
    func getSmashName() -> String {
        var currentDate = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var name = formatter.stringFromDate(currentDate)+".mov"
        return name
    }
    
        func getThumbnailName() -> String {
            var currentDate = NSDate()
            var formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            var name = formatter.stringFromDate(currentDate)+".png"
            return name
        }
        
}

