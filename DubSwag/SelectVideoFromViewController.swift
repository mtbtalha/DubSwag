//
//  SelectVideoFromViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/3/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

protocol SelectionFromDrawerDelegate {
    func pushViewControllerForIndexPath(indexPathRow: Int)
}

protocol CategorySelectionDelegate {
    func categoryDidSelect(category: Category)
}

class SelectVideoFromViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, CategorySelectionDelegate, SelectionFromDrawerDelegate {

    var videoFileURL: String?
    var thumbnailFileURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        ParseManager.getUser { (user) -> () in
//            if (user["smackURL"] as? String == nil) {
//                let alert = UIAlertController(title: "Create MySmack",
//                        message: "Please Create MySmack first.",
//                        preferredStyle: UIAlertControllerStyle.Alert)
//                    let actionNo = UIAlertAction(title: "OK", style: .Default) { (alertAction) -> Void in
//                        Router.showCreateMySmackViewController(self)
//                    }
//                    alert.addAction(actionNo)
//                    self.presentViewController(alert, animated: true,
//                        completion: nil)
//            }
//        }
        
        FBUtility.getFbUsername { (username) -> () in
            ParseManager.updateUserName(username)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func selectVideoFromServerTapped(sender: AnyObject) {
        Router.showCategorySelectionViewController(self, delegate: nil)
    }

    @IBAction func NavigationDrawerButtonTapped(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }

    @IBAction func uploadVideoButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Select Video",
            message: "Video Size must be less than 10MB",
            preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { (alertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.PhotoLibrary
                    imagePicker.mediaTypes = [kUTTypeMovie as NSString]
                    
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true,
                        completion: nil)
            }
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true,
            completion: nil)
        
   
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeImage as! String {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
     
        } else { if (mediaType == kUTTypeMovie as! String) {
                let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
                let thumbnailData = MediaManager.getVideoThumbnail(videoURL)
                let videoURLString = videoURL.path
                println(videoURLString)
            var videoData: NSData = NSFileManager().contentsAtPath(videoURLString!)!
            let alert = UIAlertController(title: "Save Video",
                message: "Do you want to save your video on Server?",
                preferredStyle: UIAlertControllerStyle.Alert)
            let actionYes = UIAlertAction(title: "Yes", style: .Default) { (alertAction) -> Void in
                let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                progressHUD.labelText = "Uploading..."
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                        ParseManager.uploadFile(videoData, fileName: "video.mov", success: { (file) -> () in
                        var videoFile = file["File"] as! PFFile
                        self.videoFileURL = videoFile.url
                        println(videoFile.url)
                        progressHUD.hide(true)
                        Router.showCategorySelectionViewController(self, delegate: self)
                    })
                    ParseManager.uploadFile(thumbnailData!, fileName: "thumbnail.png", success: { (file) -> () in
                        var imageFile = file["File"] as! PFFile
                        self.thumbnailFileURL = imageFile.url
                        println(imageFile.url)
                    })
                }
            }
            let actionNo = UIAlertAction(title: "No", style: .Default) { (alertAction) -> Void in
                var videoCopiedToDocumentDirectoryURL = DataManager.saveVideoFromCameraRollToDocumentsDirectory(videoData)
                var userVideoPFObject = PFObject(className: "User_Videos")
                userVideoPFObject["VideoName"] = "video.mov"
                userVideoPFObject["videoURL"] = videoCopiedToDocumentDirectoryURL.path!
                var userVideo = UserVideos(videoObject: userVideoPFObject)
                Router.showPlayVideoViewController(self, video: userVideo, UploadVideo: false)
            }
            alert.addAction(actionYes)
            alert.addAction(actionNo)
            self.presentViewController(alert, animated: true,
                completion: nil)
            }
        }
    }
    
    func categoryDidSelect(category: Category){
        println(category.categoryName)
        var user = PFUser.currentUser()
        if user != nil {
            
            ParseManager.uploadUser_video(category.categoryId!, userId: user!.objectId!, videoURL: self.videoFileURL!, thumbnailURL: self.thumbnailFileURL!)
            var userVideoPFObject = PFObject(className: "User_Videos")
            userVideoPFObject["VideoName"] = "video.mov"
            userVideoPFObject["categoryId"] = category.categoryId!
            userVideoPFObject["userId"] = user!.objectId!
            userVideoPFObject["videoURL"] = self.videoFileURL!
            userVideoPFObject["thumbnailURL"] = self.thumbnailFileURL!
            var userVideo = UserVideos(videoObject: userVideoPFObject)
            Router.showPlayVideoViewController(self, video: userVideo)
            println("User_video Uploaded")
        } else {
            println("NO User")
        }
    }
    
    func pushViewControllerForIndexPath(indexPathRow: Int) {
        switch(indexPathRow){
        case 0:
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.closeDrawerAnimated(true, completion: { (BOO) -> Void in
            })
            Router.showNewsFeedViewController(self)
        case 1:
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.closeDrawerAnimated(true, completion: { (BOO) -> Void in
            })
            Router.showNewsFeedViewController(self, onlyMySmash: true)
        case 2:
            println("2")
        default:
            println("Default of Drawer")
        }
    }
}


