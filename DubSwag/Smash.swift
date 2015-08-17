//
//  Smash.swift
//  DubSwag
//
//  Created by Talha Babar on 8/12/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class Smash: NSObject {

    var userId: String?
    var smashURL: String?
    var thumbnailURL: String?
    var smashName: String?
    var smashId: String?
    var likes: Int!
    
    init(videoObject: PFObject) {
        self.smashName = videoObject["smashName"] as? String
        self.smashId = videoObject.objectId
        self.userId = videoObject["userId"] as? String
        self.smashURL = videoObject["smashURL"] as? String
        self.thumbnailURL = videoObject["thumbnailURL"] as? String
        self.likes = videoObject["likes"] as! Int
    }

}
