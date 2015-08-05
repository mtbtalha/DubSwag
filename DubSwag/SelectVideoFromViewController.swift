//
//  SelectVideoFromViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/3/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MobileCoreServices

class SelectVideoFromViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func selectVideoFromServerTapped(sender: AnyObject) {
        Router.showCategorySelectionViewController(self)
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
                let videoURLString = videoURL.path
                println(videoURLString)
            var videoData: NSData = NSFileManager().contentsAtPath(videoURLString!)!
            let alert = UIAlertController(title: "Select Video",
                message: "Video Size must be less than 10MB",
                preferredStyle: UIAlertControllerStyle.Alert)
            let actionYes = UIAlertAction(title: "Yes", style: .Default) { (alertAction) -> Void in
            }
            let actionNo = UIAlertAction(title: "No", style: .Default) { (alertAction) -> Void in
            }

            alert.addAction(actionYes)
            alert.addAction(actionNo)
            self.presentViewController(alert, animated: true,
                completion: nil)

            }
        }
    }
    
}
  

