//
//  FBUtility.swift
//  
//
//  Created by Talha Babar on 8/3/15.
//
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

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

    static func getFbId() -> String? {
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
            return nil
        }
    }
    
   
    
    static func getFbUsername(success: (String) ->  ()) {
        var fbUsername : String?
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//                println("Error: \(error)")
//            }
//            else
//            {
//                println(result)
//                fbUsername = result.valueForKey("name") as? String
//                println(fbUsername)
//            }
//        })
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                
                fbUsername = result.valueForKey("name") as? String ?? ""
                if(fbUsername != "") {
                    success(fbUsername!)
                }
                else {
                    success("")
                }
            }
        })
    }

}
