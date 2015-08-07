//
//  ViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 7/30/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var accessToken: FBSDKAccessToken?
    var fbUtility = FBUtility()
    var fbLoginButton: FBSDKLoginButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessToken = FBSDKAccessToken.currentAccessToken()
        if(accessToken == nil) {
            fbUtility.showFBLoginButton(self.view)
            fbLoginButton = fbUtility.getFBLoginButton()
            fbLoginButton?.delegate = self
        } else {
            PFFacebookUtils.logInInBackgroundWithAccessToken(FBSDKAccessToken.currentAccessToken(), block: {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    println("User logged in through Facebook!")
                } else {
                    println("Uh oh. There was an error logging in.")
                }
            })
            
            Router.showSelectVideoFromViewController(self)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil)
        {
            println("ERROR: User Cannot LogIn")
        }
        else if result.isCancelled {
            println("User have Cancelled LogIn")
        }
        else {
            Router.showSelectVideoFromViewController(self)
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("UserLogged Out")
    }
}

