//
//  NavigationDrawerViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/4/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class NavigationDrawerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    var fbUtility = FBUtility()
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
//        tableview.frame = CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y, tableview.frame.width, 3*45 )
        tableviewHeight.constant = 3 * 45
        FBUtility.getFbUsername { (username) -> () in
            self.usernameLabel.text = username
        }
    }
    
//    self.tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.row){
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "Feeds"
            cell.textLabel?.font.fontWithSize(14.0)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "Smashes"
            cell.textLabel?.font.fontWithSize(14.0)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "My Smack"
            cell.textLabel?.font.fontWithSize(14.0)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "None"
            cell.textLabel?.font.fontWithSize(9.0)
            return cell
            
        }
    }
}
