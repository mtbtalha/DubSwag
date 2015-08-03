//
//  ViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 7/30/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var accessToken: FBSDKAccessToken?
    var fbUtility = FBUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessToken = FBUtility.getFbAccessToken()
        if(accessToken == nil) {
        fbUtility.showFBLoginButton(self.view)
        } else {
            PFFacebookUtils.logInInBackgroundWithAccessToken(FBUtility.getFbAccessToken(), block: {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    println("User logged in through Facebook!")
                } else {
                    println("Uh oh. There was an error logging in.")
                }
            })
        }
    }
}

