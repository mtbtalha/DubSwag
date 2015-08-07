//
//  CategorySelectionViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/5/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit


class CategorySelectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var categoryObjects = [Category]()
    var delegate: CategorySelectionDelegate?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        ParseManager.getCategories { (objects) -> () in
            for object in objects {
                var category = Category(category: object)
                //println(category.categoryName)
                self.categoryObjects.append(category)
            }
            self.tableView.reloadData()
        }
    }
    
//     func getCategories(success: ([PFObject]) ->  ()) {
//        var query = PFQuery(className:"Categories")
//        query.limit = 100
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                success(objects as! [PFObject])
//            } else {
//                // Log details of the failure
//                println("Error: \(error!) \(error!.userInfo!)")
//            }
//        }
//
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = self.delegate {
        delegate.categoryDidSelect(categoryObjects[indexPath.row])
        } else {
        Router.showListOfCategoryVideosViewController(self, categoryId: categoryObjects[indexPath.row].categoryId!)
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryObjects.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellIdentifier", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = self.categoryObjects[indexPath.row].categoryName
            cell.textLabel?.font.fontWithSize(14.0)
            return cell
            
    }


}
