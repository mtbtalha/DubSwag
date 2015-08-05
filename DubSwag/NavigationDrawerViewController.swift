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
        self.navigationController!.navigationBar.hidden = true
        tableview.delegate = self
        tableview.dataSource = self
        tableviewHeight.constant = 3 * 45
        var user = PFUser.currentUser()
        if user != nil {
            println(user?.username)
        } else {
            println("NO User")
        }
        FBUtility.getFbUsername { (username) -> () in
            self.usernameLabel.text = username
        }
    }
    

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
