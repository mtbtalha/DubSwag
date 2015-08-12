//
//  DataManager.swift
//  DubSwag
//
//  Created by Talha Babar on 8/5/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class DataManager: NSObject {
   static var alreadyDownloaded = false
    static func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    static func loadFileAsync(url: NSURL, completion:(path: NSURL, error:NSError!) -> Void) {
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let destinationUrl = documentsUrl.URLByAppendingPathComponent(url.lastPathComponent!)
        if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
            println("file already exists [\(destinationUrl.path!)]")
            self.alreadyDownloaded = true
            completion(path: destinationUrl, error:nil)
        } else {
            
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if (error == nil)
                {
                    if let response = response as? NSHTTPURLResponse
                    {
                        println("response=\(response)")
                        if response.statusCode == 200 {
                            if data.writeToURL(destinationUrl, atomically: true) {
                                println("file saved [\(destinationUrl.path!)]")
                                
                                completion(path: destinationUrl, error:error)
                            }
                            else
                            {
                                println("error saving file")
                                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                                completion(path: destinationUrl, error:error)
                            }
                        }
                    }
                }
                else {
                    println("Failure: \(error.localizedDescription)");
                    completion(path: destinationUrl, error:error)
                }
            })
            task.resume()
        }
    }
}
