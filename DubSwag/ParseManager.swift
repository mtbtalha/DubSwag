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
}
