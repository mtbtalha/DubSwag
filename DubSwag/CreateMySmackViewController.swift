//
//  CreateMySmackViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/13/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer

class CreateMySmackViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVMergerDelegate {

    @IBOutlet weak var useCameraButton: UIButton!
    @IBOutlet weak var saveMySmackButton: UIButton!
    @IBOutlet weak var playVideoView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    
    var alert: UIAlertController!
    var moviePlayer: MPMoviePlayerController!
    var smackURL: NSURL!
    var savedMySmackURL: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideoView.hidden = true
        warningLabel.hidden = true
        saveMySmackButton.hidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func useCameraButtonTapped(sender: AnyObject) {
        alert = UIAlertController(title: "MySmack",
            message: "MySmack should be of 5 seconds only. Else it will be shortened to 5 seconds.",
            preferredStyle: UIAlertControllerStyle.Alert)
        let actionNo = UIAlertAction(title: "OK", style: .Default) { (alertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.Camera) {
                    
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.Camera
                    imagePicker.mediaTypes = [kUTTypeVideo as NSString]
                    imagePicker.allowsEditing = false
                    
                    self.presentViewController(imagePicker, animated: true,
                        completion: nil)
            }
        }
        alert.addAction(actionNo)
        self.presentViewController(alert, animated: true,
            completion: nil)
        //newMedia = true
    }
    
    @IBAction func saveMySmackButtonTapped(sender: AnyObject) {
        var createMySmack = AVMerger()
        createMySmack.delegate = self
        savedMySmackURL = createMySmack.createSmack(smackURL)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let alert = UIAlertController(title: "ERROR",
            message: "Please pick a video of 5 sec",
            preferredStyle: UIAlertControllerStyle.Alert)
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeImage as! String {
            self.presentViewController(alert, animated: true,
                completion: nil)
//            
//            if (newMedia == true) {
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                    "image:didFinishSavingWithError:contextInfo:", nil)
        } else if mediaType == kUTTypeMovie as! String {
                // Code to support video here
            playVideoView.hidden = false
            smackURL = info[UIImagePickerControllerMediaURL] as! NSURL
            moviePlayer = MediaManager.loadMoviePlayer(smackURL, playerView: playVideoView)
            moviePlayer.play()
            warningLabel.hidden = false
            saveMySmackButton.hidden = false
        }
    }
    
    func exportDidEnd() {
        var smackData = NSData(contentsOfURL: savedMySmackURL)
        ParseManager.uploadFile(smackData!, fileName: savedMySmackURL.lastPathComponent!) { (fileObject) -> () in
            var smackFile = fileObject["File"] as! PFFile
            var smackFileURL = smackFile.url
            ParseManager.getUser({ (userObject) -> () in
                userObject["smackURL"] = smackFileURL
                userObject.saveInBackground()
                Router.showSelectVideoFromViewController(self)
            })
        }
    }


}
