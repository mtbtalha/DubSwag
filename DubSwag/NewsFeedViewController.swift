//
//  NewsFeedViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/16/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

protocol NewsFeedDelegate{
    func pushPlayFeedSmack(smackURLString: String)
    func likesUpdatedAtCell(indexPathRow: NSIndexPath)
}




class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,NewsFeedDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var smashes = [Smash]()
    var onlyMySmash: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if (onlyMySmash == true) {
            ParseManager.getMySmashes({ (smashObjects) -> () in
                for smashObject in smashObjects {
                    var smash = Smash(videoObject: smashObject)
                    self.smashes.append(smash)
                }
                self.tableView.reloadData()
            })
        } else {
            ParseManager.getSmashes { (smashObjects) -> () in
            for smashObject in smashObjects {
                var smash = Smash(videoObject: smashObject)
                self.smashes.append(smash)
            }
//            for smash in self.smashes {
//                
//            }
            self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smashes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedTableViewCell.feedCellIdentifier, forIndexPath: indexPath) as! FeedTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.smash = smashes[indexPath.row]
        let smashObject = smashes[indexPath.row]
        var thumbnailURL = NSURL(string: smashObject.thumbnailURL!)
        cell.thumbnailImageView.sd_setImageWithURL(thumbnailURL!)
        cell.usernameLabel.hidden = true
        cell.likesLabel.text = "\(smashObject.likes)"
        return cell
    }
    
    func pushPlayFeedSmack(smackURLString: String) {
        Router.showPlayFeedSmackViewController(self, smackURLSting: smackURLString)
    }
    
    func likesUpdatedAtCell(indexPathRow: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPathRow) as! FeedTableViewCell
        let smashObject = smashes[indexPathRow.row]
        cell.likesLabel.text = "\(smashObject.likes)"
        
    }
}
