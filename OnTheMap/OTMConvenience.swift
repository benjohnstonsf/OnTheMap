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
		

		let jsonBody : [String:AnyObject] = [
			"udacity": [
				"username": authDetails.email!,
				"password": authDetails.password!,
			]
		]
		
		taskForPOSTMethod("session", jsonBody: jsonBody) { (result, error) in
						
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				callBack(success: false, errorString: error?.localizedDescription)
				return
			}
			
			if let result = result as? [String: AnyObject] {
				
				/* GUARD: Was there a session key */
				guard let session = result["session"] where result["session"] != nil else {
					callBack(success: false, errorString: result["error"] as? String)
					return
				}
				
				if let session = session as? [String: AnyObject] {
					self.sessionID = session["id"] as? String
					callBack(success: true, errorString: nil)
				}
			}
		}
	}
}

