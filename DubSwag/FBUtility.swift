//
//  FBUtility.swift
//  
//
//  Created by Talha Babar on 8/3/15.
//
//

import UIKit

class FBUtility: NSObject {
    
    let btnLogin = FBSDKLoginButton()
    
    func getFBLoginButton() -> FBSDKLoginButton {
        return btnLogin
    }
    
    func showFBLoginButton(view: UIView) {
        btnLogin.center = view.center
        view.addSubview(btnLogin)
        btnLogin.readPermissions = ["public_profile","email"]
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

}
