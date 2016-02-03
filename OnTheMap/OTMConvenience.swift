//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/9/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
	
	func udacityCreateSession(authDetails: (email: String?, password: String?), callBack: (success: Bool, errorString: String?) -> Void) {
		
		/* GUARD: Check both login fields aren't blank */
		guard let email = authDetails.email, password = authDetails.password where !email.isEmpty && !password.isEmpty else {
			callBack(success: false, errorString: "Missing credentials")
			return
		}
		
		let jsonBody : [String:AnyObject] = [
			"udacity": [
				"username": email,
				"password": password,
			]
		]
		
		taskForPOSTMethod("session", jsonBody: jsonBody) { (result, resultDictionary, error) in
			
			print("result: \(result)")
			print("resultDictionary: \(resultDictionary)")
						
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				callBack(success: false, errorString: error?.localizedDescription)
				return
			}
			
			/* GUARD: Was there a session key */
			guard let session = resultDictionary!["session"] where resultDictionary!["session"] != nil else {
				callBack(success: false, errorString: resultDictionary!["error"] as? String)
				return
			}

			/* GUARD: Was there an account key */
			guard let account = resultDictionary!["account"] where resultDictionary!["account"] != nil else {
				callBack(success: false, errorString: resultDictionary!["error"] as? String)
				return
			}
			
			if let account = account as? [String: AnyObject] {
				self.userID = account["key"] as? String
			}
			
			if let session = session as? [String: AnyObject] {
				self.sessionID = session["id"] as? String
				callBack(success: true, errorString: nil)
			}
		}
	}
	
	func udacityDestroySession(viewController: UIViewController){
		OTMClient.sharedInstance.taskForDELETEMethod("session") { (result, resultDictionary, error) in
			if result {
				dispatch_async(dispatch_get_main_queue(), {
					let logoutController = viewController.presentingViewController as? LoginViewController
					logoutController?.passwordField.text = ""
					let controller = viewController.storyboard?.instantiateViewControllerWithIdentifier("LoginViewIdentifier") as? LoginViewController
					viewController.navigationController?.pushViewController(controller!, animated: true)
					viewController.presentingViewController?.dismissViewControllerAnimated(false, completion: nil )
				})
			} else {
				ViewHelper.sharedInstance.displayError(viewController, errorString: error?.localizedDescription)
			}
		}
	}
	

}

