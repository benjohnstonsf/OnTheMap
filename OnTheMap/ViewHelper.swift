//
//  ViewHelper.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/28/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Modify UI

class ViewHelper {
	
	static let sharedInstance = ViewHelper()
	
	func displayError(viewController: UIViewController, errorString: String?){
		dispatch_async(dispatch_get_main_queue(), {
			if let errorString = errorString {
				let alertController = UIAlertController(title: "Oops", message: errorString, preferredStyle: .Alert)
				let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
					alertController.dismissViewControllerAnimated(true, completion: nil)
				}
				alertController.addAction(OKAction)
				viewController.presentViewController(alertController, animated: true, completion: nil)
			}
		})
	}

	
}