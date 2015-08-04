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
//        let mainStoryboard = UIStoryboard(name: "selectVideoFrom", bundle: NSBundle.mainBundle())
//        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("SelectVideoFrom") as! SelectVideoFromViewController
//        
//         fromViewController.navigationController?.pushViewController(vc, animated: true )
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var rootViewController = appDelegate.window!.rootViewController
        
        let selectVideoFromStoryboard: UIStoryboard = UIStoryboard(name: "selectVideoFrom", bundle: nil)
        
        var centerViewController = selectVideoFromStoryboard.instantiateViewControllerWithIdentifier("SelectVideoFromViewController") as! SelectVideoFromViewController
        
        var leftViewController = selectVideoFromStoryboard.instantiateViewControllerWithIdentifier("NavigationDrawerViewController") as! NavigationDrawerViewController
        
        var leftSideNav = UINavigationController(rootViewController: leftViewController)
        var centerNav = UINavigationController(rootViewController: centerViewController)
        
       appDelegate.centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav)
        
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
        appDelegate.centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;
        
        appDelegate.window!.rootViewController = appDelegate.centerContainer
        appDelegate.window!.makeKeyAndVisible()

    }
   
}
