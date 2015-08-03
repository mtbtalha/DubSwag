//
//  Router.swift
//  DubSwag
//
//  Created by Talha Babar on 8/3/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    static func showSelectVideoFromViewController(fromViewController: UIViewController){
        let mainStoryboard = UIStoryboard(name: "selectVideoFrom", bundle: NSBundle.mainBundle())
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("SelectVideoFrom") as! SelectVideoFromViewController
         fromViewController.navigationController?.pushViewController(vc, animated: true )
    }
   
}
