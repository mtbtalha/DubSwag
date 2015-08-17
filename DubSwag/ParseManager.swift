//
//  ParseManager.swift
//  DubSwag
//
//  Created by Talha Babar on 8/6/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit


class ParseManager: NSObject {
    static func uploadFile(data: NSData,fileName: String,success: (PFObject) ->  ()) {
        let file = PFFile(name: fileName, data: data)
        var fileObject = PFObject(className:"Files")
        fileObject["fileName"] = fileName
        fileObject["File"] = file
        fileObject.saveInBackgroundWithBlock { (bool, error) -> Void in
            if error != nil {
                println("Error: Uploading file Object")
            } else {
                success(fileObject)
            }
        }
    }
    
    static func uploadUser_video(categoryId: String, userId: String, videoURL: String, thumbnailURL: String) {
        var videoObject = PFObject(className:"User_Videos")
        videoObject["VideoName"] = "video.mov"
        videoObject["categoryId"] = categoryId
        videoObject["userId"] = userId
        videoObject["videoURL"] = videoURL
        videoObject["thumbnailURL"] = thumbnailURL
        videoObject.saveInBackground()
    }
    
    static func uploadSmashes(userId: String, smashURL: String, thumbnailURL: String, smashName: String,userName: String ,likes : Int = 0) {
        var videoObject = PFObject(className:"Smashes")
        videoObject["smashName"] = smashName
        videoObject["userId"] = userId
        videoObject["smashURL"] = smashURL
        videoObject["thumbnailURL"] = thumbnailURL
        videoObject["likes"] = likes
        videoObject["userName"] = userName
        videoObject.saveInBackground()
    }
    
    
    static func getCategories(success: ([PFObject]) ->  ()) {
        var query = PFQuery(className:"Categories")
        query.limit = 100
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                success(objects as! [PFObject])
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    static func updateSmashLikes(smashId: String, likes: Int){
        var smashObject = PFObject(withoutDataWithClassName: "Smashes", objectId: smashId)
        smashObject.setValue(likes, forKey: "likes")
        smashObject.saveInBackground()
    }
    
    
    static func updateUserName(userName: String){
        var userObject = PFObject(withoutDataWithClassName: "_User", objectId: PFUser.currentUser()!.objectId!)
        userObject.setValue(userName, forKey: "userName")
        userObject.saveInBackground()
    }
    
    static func getUserVideos(categoryId: String, success: ([PFObject]) -> ()){
        var query = PFQuery(className: "User_Videos")
        query.whereKey("categoryId", equalTo:categoryId)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                success(objects as! [PFObject])
            
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    
    
    static func getUser(success: (PFObject) -> ()){
        var user = PFUser.currentUser()
        if let pfUser = user
        {
            var query = PFQuery(className:"_User")
            query.whereKey("objectId", equalTo:pfUser.objectId!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            println("I am here")
                           success(object)
                        }
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }

        }
    }
    
    static func getSmashes(success: ([PFObject]) ->  ()) {
        var query = PFQuery(className:"Smashes")
        query.limit = 100
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                success(objects as! [PFObject])
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    static func getMySmashes(success: ([PFObject]) ->  ()) {
        var query = PFQuery(className:"Smashes")
        query.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                success(objects as! [PFObject])
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    
    
    static func getUserForId(userId: String,success: (PFObject) -> ()){
            var query = PFQuery(className:"_User")
            query.whereKey("objectId", equalTo:userId)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            println("I am here")
                            success(object)
                        }
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
    }
}
