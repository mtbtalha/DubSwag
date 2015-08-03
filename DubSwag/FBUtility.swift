//
//  FBUtility.swift
//  
//
//  Created by Talha Babar on 8/3/15.
//
//

import UIKit

class FBUtility: NSObject, FBSDKLoginButtonDelegate {
    
    let btnLogin = FBSDKLoginButton()
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil)
        {
            println("ERROR: User Cannot LogIn")
        }
        else if result.isCancelled {
            println("User have Cancelled LogIn")
        }
        else {
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("UserLogged Out")
    }
    
    
    func showFBLoginButton(view: UIView) {
        btnLogin.center = view.center
        view.addSubview(btnLogin)
        btnLogin.readPermissions = ["public_profile","email"]
        btnLogin.delegate = self
    }

    static func getFbId() -> String {
        var fbID = ""
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                fbID = result.valueForKey("id") as! String
            }
        })
        if(fbID != "") {
            return fbID
        }
        else {
            return "error"
        }
    }
    
   
    
    static func getFbUsername() -> String {
        var fbUsername = ""
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                fbUsername = result.valueForKey("name") as! String
            }
        })
        if(fbUsername != "") {
            return fbUsername
        }
        else {
            return "error"
        }
    }

    static func getFbAccessToken() -> FBSDKAccessToken {
        return FBSDKAccessToken.currentAccessToken()
    }

}
