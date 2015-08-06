//
//  VideoTableViewCell.swift
//  DubSwag
//
//  Created by Talha Babar on 8/6/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var videoNameLabel: UILabel!
    static let videoCellIdentifier = "VideoViewCellIdentifier"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
