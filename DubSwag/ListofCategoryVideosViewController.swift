//
//  ListofCategoryVideosViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/6/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class ListofCategoryVideosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var categoryId: String?
    var userVideoObjects = [UserVideos]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        ParseManager.getUserVideos(self.categoryId!) { (objects) -> () in
            for object in objects {
                var userVideo = UserVideos(videoObject: object)
                //println(category.categoryName)
                self.userVideoObjects.append(userVideo)
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVideoObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCellWithIdentifier(VideoTableViewCell.videoCellIdentifier, forIndexPath: indexPath) as! VideoTableViewCell
            let videoObject = userVideoObjects[indexPath.row]
            var thumbnailURL = NSURL(string: videoObject.thumbnailURL!)
            cell.videoThumbnailImageView.sd_setImageWithURL(thumbnailURL!)
            cell.videoNameLabel.text = videoObject.videoName
            return cell
    }
}
