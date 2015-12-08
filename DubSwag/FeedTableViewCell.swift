//
//  FeedTableViewCell.swift
//  DubSwag
//
//  Created by Talha Babar on 8/16/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    
    static var feedCellIdentifier = "FeedCellIdentifier"
    var isliked = false
    var smash: Smash!
    var delegate: NewsFeedDelegate?
    var indexPath: NSIndexPath!
    
    @IBAction func likeButtonTapeed(sender: AnyObject) {
        if (isliked) {
                                            
        } else {
            smash.likes = smash.likes + 1
            ParseManager.updateSmashLikes(smash.smashId!, likes: smash.likes)
            self.delegate?.likesUpdatedAtCell(indexPath)
            isliked = true
        }
        
    }
    
    @IBAction func playButtonTapped(sender: AnyObject) {
           self.delegate?.pushPlayFeedSmack(smash.smashURL!)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
