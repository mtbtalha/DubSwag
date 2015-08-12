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
    
    static func showCategorySelectionViewController(fromViewController: UIViewController, delegate: CategorySelectionDelegate?){
                let mainStoryboard = UIStoryboard(name: "selectVideoFrom", bundle: NSBundle.mainBundle())
                let vc = mainStoryboard.instantiateViewControllerWithIdentifier("CategorySelectionViewController") as! CategorySelectionViewController
//        if fromViewController is SelectVideoFromViewController {
//            vc.delegate = fromViewController as! SelectVideoFromViewController
//        }
                 vc.delegate = delegate
                 fromViewController.navigationController?.pushViewController(vc, animated: true )
    }
    
    static func showListOfCategoryVideosViewController(fromViewController: UIViewController, categoryId: String){
        let mainStoryboard = UIStoryboard(name: "ListOfCategoryVideos", bundle: NSBundle.mainBundle())
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("ListofCategoryVideosViewController") as! ListofCategoryVideosViewController
        vc.categoryId = categoryId
        fromViewController.navigationController?.pushViewController(vc, animated: true )
    }
    
    static func showPlayVideoViewController(fromViewController: UIViewController, video: UserVideos){
        let mainStoryboard = UIStoryboard(name: "PlayVideo", bundle: NSBundle.mainBundle())
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("PlayVideoViewController") as! PlayVideoViewController
        vc.video = video
        fromViewController.navigationController?.pushViewController(vc, animated: true )
    }

    static func showRecordSmashViewController(fromViewController: UIViewController, videoURL: NSURL){
        let mainStoryboard = UIStoryboard(name: "RecordSmash", bundle: NSBundle.mainBundle())
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("RecordSmashViewController") as! RecordSmashViewController
        vc.videoURL = videoURL
        fromViewController.navigationController?.pushViewController(vc, animated: true )
    }
    
    static func showPlaySmashViewController(fromViewController: UIViewController, smashURL: NSURL){
        let mainStoryboard = UIStoryboard(name: "RecordSmash", bundle: NSBundle.mainBundle())
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("PlaySmashViewController") as! PlaySmashViewController
        vc.smashURL = smashURL
        fromViewController.navigationController?.pushViewController(vc, animated: true )
    }
}
