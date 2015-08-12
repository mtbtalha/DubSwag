//
//  UserVideos.swift
//  DubSwag
//
//  Created by Talha Babar on 8/6/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class UserVideos: NSObject {
   
    var categoryId: String?
    var userId: String?
    var videoURL: String?
    var thumbnailURL: String?
    var videoName: String?
    
    init(videoObject: PFObject) {
        self.videoName = videoObject["VideoName"] as? String
        self.categoryId = videoObject["categoryId"] as? String
        self.userId = videoObject["userId"] as? String
        self.videoURL = videoObject["videoURL"] as? String
        self.thumbnailURL = videoObject["thumbnailURL"] as? String
    }

}
