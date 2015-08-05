//
//  DataManager.swift
//  DubSwag
//
//  Created by Talha Babar on 8/5/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class DataManager: NSObject {
   
    static func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
//    static func downloadImage(url:NSURL){
//        println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
//        getDataFromUrl(url) { data in
//            dispatch_async(dispatch_get_main_queue()) {
//                println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
//                imageURL.image = UIImage(data: data!)
//            }
//        }
//    }
}
